#!/bin/bash

[ -f ~/.env/sphinx/bin/activate ] && . ~/.env/sphinx/bin/activate

make clean
make html
make latexpdf
make epub

# I don't like having a PDF in the repository. But if we are going to keep
# them here, please put them in pdf.in so the top-level directory remains
# relatively uncluttered.

cp pdf.in/* build

./rsync-gradhandbook.sh
