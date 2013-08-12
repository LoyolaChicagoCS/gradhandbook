#!/bin/bash

rsync -av \
	--delete \
	--exclude .htaccess \
	$(pwd)/build/ \
	gradhandbook.cs.luc.edu:/var/www/vhosts/gradhandbook.cs.luc.edu/htdocs/

