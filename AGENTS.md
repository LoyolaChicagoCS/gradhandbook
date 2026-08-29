# AGENTS.md

Instructions for building, editing, and releasing the LUC CS Graduate Student
Handbook. This is a Sphinx (reStructuredText) documentation site published to
https://gradhandbook.cs.luc.edu via GitHub Pages, with PDF/EPUB artifacts
attached to tagged GitHub Releases.

## Repo layout

- `source/*.rst` — the handbook content. `source/index.rst` holds the master
  `toctree` that defines page order in the sidebar; every new top-level page
  must be added there.
- `source/conf.py` — Sphinx config. Theme is `sphinx_book_theme`
  (`show_toc_level: 2`). `rst_epilog` defines reusable substitutions (e.g.
  `|gpd|`, `|math201|`) available in every `.rst` file without an explicit
  `.. include::`.
- `requirements.txt` — `sphinx`, `sphinx-book-theme`.
- `Makefile` / `make.bat` — standard Sphinx-generated build targets.
- `.github/workflows/main.yml` — CI: builds HTML/LaTeX/EPUB, builds the PDF
  via TeX Live, deploys `build/html` to GitHub Pages on push to `master`, and
  (on a `v*` tag push) attaches the built PDF/EPUB to a GitHub Release.
- `scripts/purge-releases.sh` — local script to delete old GitHub Releases
  while keeping a specified set. See its `--help` for usage.
- `new-content/` — untracked staging area with legacy LaTeX source
  (`main.tex`, `phd-handbook.tex`) that has not yet been fully merged into the
  RST handbook. Treat it as source material to mine, not published content.

## Environment setup

A `.venv` may already exist in the repo root. If not:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Building the site

```bash
source .venv/bin/activate
make html
open build/html/index.html   # macOS; use xdg-open on Linux
```

**Always do a clean build before treating a build as final**, i.e.
`rm -rf build && make html`. Sphinx's incremental build can leave a stale
cached environment that silently drops entries from the sidebar `toctree` on
pages it doesn't happen to rebuild (seen firsthand: a newly added page was
missing from the left nav on most — but not all — pages until a full clean
rebuild). A quick way to sanity-check the sidebar after adding a page:

```bash
python3 - <<'EOF'
import re, glob
for f in sorted(glob.glob('build/html/*.html')):
    html = open(f).read()
    idx = html.find('class="caption-text">Contents')
    if idx == -1:
        continue
    end = html.find('</ul>', idx)
    items = re.findall(r'>([^<]+)</a>', html[idx:end])
    print(f.split('/')[-1], '->', len(items), 'entries')
EOF
```
All pages should report the same entry count.

Other targets (also used by CI): `make latex`, `make epub`,
`make -C build/latex` (requires a TeX Live install; on CI this uses
`texlive-full` via `apt-get`).

## Editing content

- New top-level page: add `source/<name>.rst`, then list it in the
  `.. toctree::` block in `source/index.rst` (order there = sidebar order).
  Do a clean rebuild afterward (see above) and check the sidebar.
- Section headings: RST heading level is inferred per-file from the order
  adornment characters first appear, not from the specific character used.
  Every top-level page in this repo uses `#############` (overline + same
  underline) for its title, matching the pattern of the others — follow that
  convention for consistency rather than for any functional reason.
- Cross-references: `sphinx.ext.autosectionlabel` is enabled with
  `autosectionlabel_prefix_document = True`, so any heading can be targeted
  as `` :ref:`filename:Heading Text` ``. The existing `.. _label:` anchors
  (e.g. `_roles:` in `department-info.rst`) predate this and are used for the
  shorter `` :ref:`roles` `` form — prefer reusing an existing named anchor
  when referring to Key Roles & Contacts.
- Contact info lives in the "Key Roles & Contacts" tables in
  `source/department-info.rst`. When adding or fixing a contact, verify the
  name/title/email against Loyola's current staff directory (e.g.
  `https://www.luc.edu/gradschool/about/contactus/` for Graduate School
  roles) rather than trusting older source material — titles and names in
  `new-content/*.tex` are known to be stale (e.g. an outdated spelling of
  "Kate Phillippo" and a placeholder `--` for her and the Dean's email).

## Releases

Tags matching `v*` pushed to GitHub trigger `.github/workflows/main.yml` to
build and attach `LoyolaComputerScienceGraduateHandbook.pdf`/`.epub` to a
GitHub Release for that tag.

To prune old releases locally, keeping only specific ones:

```bash
# Keep whatever GitHub currently marks "latest"
scripts/purge-releases.sh --keep-current-tag

# Also keep specific older releases
scripts/purge-releases.sh --keep-current-tag --also-keep v0.9.4,v0.9

# Preview without deleting anything
scripts/purge-releases.sh --keep-current-tag --dry-run
```

By default this deletes only the GitHub Release entries, not the underlying
git tags; pass `--cleanup-tag` to remove tags too. The script refuses to run
if the keep-list would be empty (it will not silently delete everything).
Requires the `gh` CLI, authenticated with access to the repo.
