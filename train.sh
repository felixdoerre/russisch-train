#!/bin/bash

cd $1

while true; do
    
    LINE=`shuf -n 1 words.txt`
    IFS=";"
    PARTS=($LINE)
    cnt=$(grep -c '^'"${PARTS[0]}"'$' success)
    cntm=$(grep -c '^'"${PARTS[0]}"'$' fail)
    if [[ $((cnt-cntm)) -gt 2 ]]; then
	#echo "Skipped: ${PARTS[0]}"
	continue;
    fi
    echo $cnt"; Required: "$((cntm+3))
    IFS=" "

    failed="NO"
    while true; do
	read -r -p "${PARTS[1]}: " ENTRY
	if [[ "${PARTS[0]}" == "$ENTRY" ]]; then
	    tput setaf 2
	    echo Success
	    tput setaf 7
	    if [[ $failed == "NO" ]]; then
		echo "${PARTS[0]}" >> success
	    fi
	    break;
	else
	    tput setaf 1
	    echo -n "Fail: "
	    tput setaf 2
	    echo "${PARTS[0]}"
	    tput setaf 7
	    if [[ $failed == "NO" ]]; then
		failed="YES"
		echo "${PARTS[0]}" >> fail
	    fi
	fi
    done
done
