rsync -av -e "ssh -oPort=22222" \
	--delete \
	--exclude .htaccess \
	$(pwd)/build/ \
	gradhandbook.cs.luc.edu:/var/www/vhosts/gradhandbook.cs.luc.edu/htdocs/

