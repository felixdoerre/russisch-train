#!/bin/bash

cd $1

touch success
touch fail

while true; do
    if diff -q <(sort <(cat words.txt words.txt words.txt| cut -f1 -d\;) fail) <(sort success) > /dev/null; then
        echo finished
        exit
    fi
    IFS=';' read -r ru de < <(shuf -n1 words.txt)
    cnt=$(grep -c '^'"$ru"'$' success)
    cntm=$(grep -c '^'"$ru"'$' fail)
    if [[ $((cnt-cntm)) -gt 2 ]]; then
        #echo "Skipped: $ru"
        continue;
    fi
    echo $cnt"; Required: "$((cntm+3))

    failed="NO"
    while true; do
        read -r -p "$de: " entry
        if [[ "$ru" == "$entry" ]]; then
            tput setaf 2
            echo Success
            tput setaf 7
            if [[ $failed == "NO" ]]; then
                echo "$ru" >> success
            fi
            break;
        else
            tput setaf 1
            echo -n "Fail: "
            tput setaf 2
            echo "$ru"
            tput setaf 7
            if [[ $failed == "NO" ]]; then
                failed="YES"
                echo "$ru" >> fail
            fi
        fi
    done
done
