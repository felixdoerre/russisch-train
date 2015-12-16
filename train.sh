#!/bin/bash

cd $1

touch success
touch fail

while true; do
    if diff -q <(sort <(cat words.txt words.txt words.txt| cut -f1 -d\;) fail) <(sort success) > /dev/null; then
        echo finished
        exit
    fi
    line=$(shuf -n 1 words.txt)
    IFS=";"
    parts=($line)
    cnt=$(grep -c '^'"${parts[0]}"'$' success)
    cntm=$(grep -c '^'"${parts[0]}"'$' fail)
    if [[ $((cnt-cntm)) -gt 2 ]]; then
        #echo "Skipped: ${parts[0]}"
        continue;
    fi
    echo $cnt"; Required: "$((cntm+3))
    IFS=" "

    failed="NO"
    while true; do
        read -r -p "${parts[1]}: " entry
        if [[ "${parts[0]}" == "$entry" ]]; then
            tput setaf 2
            echo Success
            tput setaf 7
            if [[ $failed == "NO" ]]; then
                echo "${parts[0]}" >> success
            fi
            break;
        else
            tput setaf 1
            echo -n "Fail: "
            tput setaf 2
            echo "${parts[0]}"
            tput setaf 7
            if [[ $failed == "NO" ]]; then
                failed="YES"
                echo "${parts[0]}" >> fail
            fi
        fi
    done
done
