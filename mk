#!/bin/bash

printUse(){
    echo "Indended use: mk NAME GITHUB_URL"
}

matchUrl(){
    reg="^(https?:\/\/)?(github\.com)"
    if [[  "${1}" =~ ${reg} ]]; then
        return 1
    fi
    return 0
}

matchFile(){
    reg="(?:#|<|\$|\+|%|>|!|\`|&|\*|'|\|{|\?|\"|=|}|\/|:|\\| |@)"
    if [[ "${1}" =~ ${reg} ]] ; then
        echo "Illegal directory name"
        return 1
    fi
    return 0
}

readName(){
    echo -n "Name: "
    #while matchFile $name ;
        read name
}

readUrl(){
    url=''
    while matchUrl $url ;
    do
        echo -n "GitHub URL: "
        read url
    done
}

# creates a student folder and clones the repo
theWork(){
    if [[ ! -d $1 ]] ; then
        mkdir $1
    fi
    cd $1
    git clone $2
    cd ..
}

#if there are 2 args
#    name=$1
#    if the first arg matches
#        printUse
#        readName
#        url=$1
#    if the second arg matches
#        url=$2
#    else
#        printUse
#        readUrl
#else
#    printUse
#    if there is 1 arg
#        if arg 1 matches
#            readName
#            url=$1
#        else
#            name=arg1
#            readUrl
#    else
#        readName
#        readUrl
#theWork name url


# if there are no command line arguments, collect them
if [[ $# -ne 2 ]] ; then
    printUse
    readName
    readUrl
    theWork $name $url
else
    theWork $1 $2
fi
