#!/bin/bash

(git pull | head -1 | grep -v ^Already) \
	&& echo "git log for $(date)" \
	&& git --no-pager log -5 --pretty=oneline \
	&& ./deploy-gradhandbook.sh
