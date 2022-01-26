# Loyola University Chicago CS Dept. Graduate Handbook 

> [https://gradhandbook.cs.luc.edu](https://gradhandbook.cs.luc.edu)

![GH Pages Deployment](https://github.com/LoyolaChicagoCS/gradhandbook/actions/workflows/main.yml/badge.svg)

## About

This repository contains the source code for the Loyola University Chicago (LUC)
CS Dept. graduate program handbook.

These listings contain information about the graduate programs offered by the
CS Dept. at LUC. 

## How To Build The Site

The site is built and deployed automatially using a GitHub Action with
Python and Sphinx.

### How To Build the Site Locally

#### Requirements

* git
* Python 3.7+ (Python 3.9.6+ preferred)

### Build steps

```
git clone https://github.com/LoyolaChicagoCS/gradhandbook
cd gradhandbook
python3 -m venv env
source env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
make html
```

After building, the site is located in `build/html`

### Contact

Current developers working on the project:

* Nicholas Synovic @ [nsynovic@luc.edu](mailto:nsynovic@luc.edu)
* Alvaaro de Landaluce @ [adelandaluce@luc.edu](mailto:adelandaluce@luc.edu)
