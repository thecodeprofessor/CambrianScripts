#!/bin/bash
set -e

printUse() {
     echo "Usage: mk {-g|-p|-u URL} STUDENT 

    -g, --grade       enter grading mode
    -h, -?, --help    print this help list
    -p, --pull        pull the latest changes
    -u, --url=URL     clone the provided git repository"
}

# Changes to the target directory. Creates the directory if it doesn't exist
changeDir() {
    # this reg doesn't seem to work
    reg="(?:#|<|\$|\+|%|>|!|\`|&|\*|'|\|{|\?|\"|=|}|\/|:|\\| |@)"
    if [[ $dir =~ $reg ]] ; then
        echo "Illegal directory name. Exiting"
        exit 1
    fi
    if [ ! -d "$dir" ] ; then
        mkdir "$dir"
    fi
    cd "$dir"
}

# Builds, then runs the assignment
grade() {
    ktFile=`find . -name *.java`
    kotlinc $ktFile
    classFile=`find . -name *.class`
    base=`basename $classFile`
    dir=`dirname $classFile`
    cd $dir
    kotlin "${base%.*}"
    cd -
}

pull() {
    git pull
}

clone() {
    reg="(https?:\/\/)?(github\.com)"
    if [[ $1 =~ $reg ]] ; then
        if ! git clone $1 ; then
            echo "Clone already exists. Switching to git pull..."
            pull
        fi
    else
        echo "Not a valid GitHub URL. Exiting."
        exit 1
    fi
}

# Save the target directory
for last in "$@"; do :; done
dir=$last
# Save the current directory for later
cdir=`pwd`
# Save the previous directory for later
odir=$OLDPWD
changeDir "$dir"

# Convert long-name ags to short-name
for arg in "$@"; do
    shift
    case "$arg" in
        '--grade')  set -- "$@" '-g'     ;;
        '--help')   set -- "$@" '-h'     ;;
        '--pull')   set -- "$@" '-p'     ;;
        '--url')    set -- "$@" '-u'     ;;
        *)          set -- "$@" "$arg"  ;;
    esac
done
# Parse  arguments
while getopts "ghpu:" opt; do
    case "$opt" in
        'g')
            grade
            ;;
        'h' | '?')
            printUse
            exit 0
            ;;
        'p')
            pull
            ;;
        'u')
            clone "$OPTARG"
            ;;
        '--' | '*')
            printUse
            exit 2
            ;;
     esac
done

# Restore OLDWD and pwd
cd "$odir"
cd "$pwd"
