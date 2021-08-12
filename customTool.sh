#!/usr/bin/env bash

input=""

function emit() {
    printf "$1"
}

function tellAll() {
    emit '{ "version" : 3, "name" : "customTool" }'
}

function tellVersion() {
    emit 3
}

function run() {
	echo '{}'
}

NEXT_PR_FILE=".next-pr"

function finalize() {

	# write to file, commit to branch
	git clean -ffdx &> /dev/null
	touch $NEXT_PR_FILE
	next=$(cat $NEXT_PR_FILE)
	if [ -z $next ]; then
		echo "1" > $NEXT_PR_FILE
		curr=0
		next=1
	else
		curr=$next
		echo $(( next + 1 )) > $NEXT_PR_FILE
	fi
	(
	git add -A
	git commit -m "record next number ($next)"
	) &> /dev/null
	commit=$(git rev-parse HEAD)

	# output PR structure
	echo "{ \"pullRequest\": { \"title\": \"Lift Test PR ${curr}\", \
				\"body\": \"This is a test pull request opened by Lift\", \
				\"source_commit\": \"$commit\" \
			} }"
}

function applicable() {
    echo "true"
}

function tellName() {
	emit "CustomTool"
}


function main() {
    case "$3" in
        run)
            run "$2"
            ;;
        name)
            tellName
            ;;

	applicable)
            applicable
            ;;

	version)
            tellVersion
            ;;
	finalize)
			finalize
			;;
	esac
}

main $*
