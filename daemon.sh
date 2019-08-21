#!/bin/bash

echo $$ > killme.pid

JENKINS_URL=<host>
JENKINS_USER=<user>
API_TOKEN=<token>
APP_TOKEN=<token>

while true
do
	echo "$(date +%Y-%m-%d:%H:%M)" > log.txt
	while IFS= read -r repository
	do
		REPO=$(echo $repository | cut -d ':' -f 1)
		NAME=$(echo $REPO | cut -d '/' -f 2)
		SKIP_HASH=$(echo $repository | cut -d ':' -f 2)
		LATEST_HASH=$(git ls-remote -h https://x-access-token:$APP_TOKEN@github.com/$REPO.git master | cut -d$'\t' -f 1)
		if [ $SKIP_HASH != $LATEST_HASH ]; then
			echo "Build $REPO:$LATEST_HASH" >> log.txt
			sed -i "s/$SKIP_HASH/$LATEST_HASH/" repositories.list
			curl -X POST $JENKINS_URL/job/$NAME/build --user $JENKINS_USER:$API_TOKEN
		else
			echo "No changes for $REPO" >> log.txt
		fi
	done < repositories.list
	sleep 60s
done
