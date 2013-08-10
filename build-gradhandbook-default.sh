#!/bin/bash

# This for when Andy wants a default build.
# Not intended for deployment on production site.

[ -f ~/.env/sphinx/bin/activate ] && . ~/.env/sphinx/bin/activate

make clean
make CONFIG=default html
make latexpdf
make epub


