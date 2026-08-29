#!/usr/bin/env bash
#
# Delete GitHub releases for this repo, keeping only the ones you name.
#
# Usage:
#   scripts/purge-releases.sh --keep-current-tag [--also-keep TAG ...] [options]
#
# Options:
#   --keep-current-tag     Keep the release GitHub currently marks "latest"
#   --also-keep TAG        Additional tag to keep (repeatable, or comma-separated)
#   --cleanup-tag          Also delete the underlying git tag for each purged release
#   --repo OWNER/REPO      Repository to operate on (default: current repo via gh)
#   --dry-run              Print what would be deleted; make no changes
#   -y, --yes              Skip the confirmation prompt
#   -h, --help             Show this help
#
# Examples:
#   scripts/purge-releases.sh --keep-current-tag
#   scripts/purge-releases.sh --keep-current-tag --also-keep v0.9.4 --also-keep v0.9
#   scripts/purge-releases.sh --also-keep v1.0.0,v1.1.0 --dry-run

set -eo pipefail

repo=""
keep_current_tag=false
cleanup_tag=false
dry_run=false
assume_yes=false
also_keep=()

usage() {
    sed -n '2,26p' "$0" | sed 's/^# \{0,1\}//'
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --keep-current-tag)
            keep_current_tag=true
            shift
            ;;
        --also-keep)
            [[ $# -ge 2 ]] || { echo "error: --also-keep requires a value" >&2; exit 2; }
            IFS=',' read -ra parts <<< "$2"
            also_keep+=("${parts[@]}")
            shift 2
            ;;
        --cleanup-tag)
            cleanup_tag=true
            shift
            ;;
        --repo)
            [[ $# -ge 2 ]] || { echo "error: --repo requires a value" >&2; exit 2; }
            repo="$2"
            shift 2
            ;;
        --dry-run)
            dry_run=true
            shift
            ;;
        -y|--yes)
            assume_yes=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "error: unknown argument: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

if ! command -v gh >/dev/null 2>&1; then
    echo "error: gh (GitHub CLI) is required but not found in PATH" >&2
    exit 1
fi

repo_args=()
[[ -n "$repo" ]] && repo_args=(--repo "$repo")

releases_json=$(gh release list "${repo_args[@]}" --json tagName,isLatest,createdAt --limit 1000)

if [[ "$(echo "$releases_json" | jq 'length')" -eq 0 ]]; then
    echo "No releases found."
    exit 0
fi

keep_tags=()
if $keep_current_tag; then
    latest_tag=$(echo "$releases_json" | jq -r '.[] | select(.isLatest) | .tagName')
    if [[ -n "$latest_tag" ]]; then
        keep_tags+=("$latest_tag")
    else
        echo "warning: --keep-current-tag given but no release is marked 'latest'" >&2
    fi
fi
keep_tags+=("${also_keep[@]}")

if [[ ${#keep_tags[@]} -eq 0 ]]; then
    echo "error: refusing to run with an empty keep list." >&2
    echo "       pass --keep-current-tag and/or --also-keep TAG to specify what to keep." >&2
    exit 2
fi

# De-duplicate the keep list (word-splitting is fine: tags don't contain whitespace).
keep_tags=($(printf '%s\n' "${keep_tags[@]}" | sort -u))

all_tags=$(echo "$releases_json" | jq -r '.[].tagName')

to_delete=()
while IFS= read -r tag; do
    [[ -z "$tag" ]] && continue
    keep=false
    for k in "${keep_tags[@]}"; do
        [[ "$tag" == "$k" ]] && { keep=true; break; }
    done
    $keep || to_delete+=("$tag")
done <<< "$all_tags"

echo "Keeping:"
for k in "${keep_tags[@]}"; do echo "  $k"; done
echo

if [[ ${#to_delete[@]} -eq 0 ]]; then
    echo "Nothing to delete -- all releases are in the keep list."
    exit 0
fi

echo "Will delete ${#to_delete[@]} release(s)$($cleanup_tag && echo " and their tags"):"
for t in "${to_delete[@]}"; do echo "  $t"; done
echo

if $dry_run; then
    echo "Dry run -- no changes made."
    exit 0
fi

if ! $assume_yes; then
    read -r -p "Proceed with deletion? [y/N] " reply
    case "$reply" in
        [yY]|[yY][eE][sS]) ;;
        *) echo "Aborted."; exit 1 ;;
    esac
fi

delete_args=(--yes)
$cleanup_tag && delete_args+=(--cleanup-tag)

for t in "${to_delete[@]}"; do
    echo "Deleting $t..."
    gh release delete "$t" "${repo_args[@]}" "${delete_args[@]}"
done

echo "Done."
