#!/bin/bash


# example parameters -s https://www.jdoodle.com/test-bash-shell-script-online/ -f 2 -r 3

# set defaults incase no params provided
retries=1
frequency=20

while getopts s:r:f: flag
do
    case "${flag}" in
        s) site=${OPTARG};;
        r) retries=${OPTARG};;
        f) frequency=${OPTARG};;
    esac
done

# check a URL was given
if [ "$site" == "" ]; then
    echo "No URL provided"
    exit 1
fi

# set place holders
flag=0
counter=0
while [ $counter -lt $retries ]
do
    # curl to site (used -L because testing with google.com was weird)
    result=$(curl -I -s -L $site)
    # if there is 200 in the response then the site is available
    if [[ "$result" == *" 200"* ]]; then
        let "flag=1"
        break
    else
        # wait in seconds before running again
        sleep $frequency
    fi
    let "counter=counter+1"
done

# resturn the result
if [[ "$flag" == 1 ]]
then
    echo "We got it"
    exit 0
else
    echo "No luck, tired $counter times";  exit 1
fi
