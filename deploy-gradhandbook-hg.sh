#!/bin/bash

echo "<<< $(date) >>>"
echo
hg incoming && hg pull && hg update --clean && ./deploy-gradhandbook.sh
echo
