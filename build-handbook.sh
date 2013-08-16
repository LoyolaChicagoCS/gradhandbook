[ -f ~/.env/sphinx/bin/activate ] && . ~/.env/sphinx/bin/activate

make clean
make html
make latexpdf
make epub
