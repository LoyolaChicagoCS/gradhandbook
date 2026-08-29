# LUC-CS-Graduate-Handbook

> The LUC CS Department's Graduate Student Handbook

![GH Pages Deployment](https://github.com/LoyolaChicagoCS/gradhandbook/actions/workflows/main.yml/badge.svg?branch=master)
![Latest Release](https://img.shields.io/github/v/release/LoyolaChicagoCS/gradhandbook?label=latest%20release)

## Where is this site located?

The published site is at https://gradhandbook.cs.luc.edu

PDF and EPUB copies of the handbook are attached to each
[tagged release](https://github.com/LoyolaChicagoCS/gradhandbook/releases).

## Maintainer

This repository is maintained by **George Thiruvathukal**
([@gkthiruvathukal](https://github.com/gkthiruvathukal)), the CS Graduate
Program Director. If you're unsure whether a change is appropriate, or need
something merged/tagged, reach out to the maintainer directly or via an issue
or pull request as described below.

## How to suggest a change

There are two ways to contribute, depending on how comfortable you are with
Git/GitHub and how big the change is.

### 1. Open an issue (simplest)

For typos, outdated contact info, broken links, or content you'd like added
or corrected but don't want to edit yourself, open an issue:
https://github.com/LoyolaChicagoCS/gradhandbook/issues

Describe what's wrong or missing and where (page name is enough — you don't
need to find the source file). The maintainer will make the edit or route it
to the right person.

### 2. Submit a pull request from a fork

If you want to make the edit yourself:

1. [Fork](https://github.com/LoyolaChicagoCS/gradhandbook/fork) this
   repository to your own GitHub account.
2. Clone your fork and create a branch for your change.
3. Edit the relevant page(s) under `source/` (see **Building the site**
   below to preview your changes locally before submitting).
4. Commit and push to your fork, then open a pull request back to
   `LoyolaChicagoCS/gradhandbook` (`master` branch).
5. The maintainer will review, may suggest changes, and will merge and tag a
   new release once it's ready to publish.

You do not need write access to this repository to contribute this way —
only to your own fork.

## Building the site locally

You don't need to build anything to file an issue or even to submit a small
pull request (GitHub can edit files and open a PR for you directly in the
browser for simple, single-file changes). Building locally is useful when you
want to preview how your edit renders before opening a pull request, or when
making changes across multiple pages.

### 1. Set up a Python virtual environment

Requires Python 3.9+.

```bash
python3 -m venv .venv
source .venv/bin/activate        # on Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

(Alternatively, this repo includes a VS Code Dev Container: install Docker
and the
[Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
extension, open the project, and it will set up the environment for you —
then just run `pip install -r requirements.txt` inside it.)

Activate the virtual environment (`source .venv/bin/activate`) in every new
terminal session before running the build commands below.

### 2. Build the HTML site

```bash
make html
```

Output goes to `build/html/` — open `build/html/index.html` in a browser to
preview.

If you've added a new page (a new `.rst` file listed in the table of
contents in `source/index.rst`), do a full rebuild rather than an
incremental one, so the sidebar navigation picks it up correctly:

```bash
rm -rf build
make html
```

### 3. Build the EPUB

```bash
make epub
```

Output goes to `build/epub/`.

### 4. Build the PDF

The PDF is built by first generating LaTeX, then compiling it with a TeX
distribution:

```bash
make latex
make -C build/latex
```

This requires a full TeX Live installation (e.g. `texlive-full` on Debian/
Ubuntu, or [MacTeX](https://www.tug.org/mactex/) on macOS) — it's a large
download, so unless you specifically need to test PDF rendering, it's usually
easier to preview HTML/EPUB locally and let the automated release build
(described below) produce the PDF.

## How releases are published

Pushing a Git tag matching `v*` (e.g. `v0.9.8`) triggers a GitHub Actions
workflow that builds the HTML, EPUB, and PDF, deploys the HTML to GitHub
Pages, and attaches the PDF/EPUB to a new GitHub Release for that tag. Only
the maintainer normally creates release tags.

## More technical documentation

See [`AGENTS.md`](AGENTS.md) for repository layout, content-editing
conventions, and maintenance scripts (e.g. pruning old releases).
