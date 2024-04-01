#!/usr/bin/env bash
. "$HOME/.profile"

# tag_allowed_chars='[A-z_\-]'  #FYI
# written by Richard Cook 2022-11-03

# OBSOLETE
# THE CODE HERE IS WRONG, INCOMPLETE, AND UNMAINTAINED. 
# I'M MOVING TO MY PLUGIN

errexit "Sorry, I no longer want to play with you."

# Usage: obsidian-tag-delete.sh <tag1> <tag2> ... [dir or file] 
# dirname must be last argument
# "#-deleteme" is always deleted with this script, it's a featured side-effect
if [[ "x${1}" = "x" || x"$1" = x'-h' ]]; then
    echo 'ERROR: missing dir or filename argument'
    echo 'Usage: obsidian-tag-delete.sh <tag1> <tag2> ... [dir or file]' 
    echo "The last argument is taken as the file or dir to operate on"
    echo "'#_-deleteme' variants are always deleted with this script, it's a featured side-effect"
    exit 1
fi
numfiles=0
tags=("[_-]*deleteme") # note no # for tag, it's optional but will be stripped if given 
verbose=false
while [[ "x$2" != x ]]; do
    if [[ "${1:0:1}" = '#' ]]; then
        tags+=("${1:1}")
    elif [[ "$1" = "-v" || "$1" = "--verbose" ]]; then 
        verbose=true
    else 
        tags+=("$1")
    fi
    shift
done
dir="$1"
shift
grep="grep --include='*.md' -rl -E "
sed="gsed -i.bak -E "
for tag in "${tags[@]}"; do
    echo "Deleting all instances of '#${tag}' in '${dir}'"
    grep+="-e $tag "
    # YAML, not nested.  Thanks to https://regex101.com for debugging 
    lineselect='/[Tt]ags:/' 
    sed+="-e '${lineselect} s=(${tag})]=\1 ]=' -e '${lineselect} s=(\[|^|[[:space:]])(${tag},?)(]|\$|[[:space:]])=\1 \2 \3=g' -e '${lineselect} s=([^A-z_\-])(${tag},?)([^A-z_\-])=\1\3=g' -e '${lineselect} s=[[:space:]]+= =g' "
    # BODY: 
    lineselect='/#'"${tag}"'[^A-z_\-\$]/'
    sed+="-e '${lineselect} s=([^A-z]|[^/_\-]|^)(#${tag})([^A-z/_\-]|\\$)=\1 \2 \3=g' -e '${lineselect} s= #${tag} ==g' "
    # NOTE:  DOES NOT WORK WITH THIS FORM OF NESTED TAGS IN YAML:
    nothandled='
Tags: 
- tag1
- testtag
- testtag
'
done
if testbool "$verbose"; then 
    echo dir is "$dir"
    echo tags is "${tags[@]}"
    echo grep is "$grep"
    echo sed is "$sed"
fi

# 2022-05-26
# This is where the magic happens

while IFS= read -r line; do 
    # echo "$sed $line"
    echo "Found a possible tag match in '$line'"
    eval "$sed" "'$line'"
done < <(eval "$grep" "'$dir'")
    
exit 

# ======================================================================
# TEST CODE YAML: THIS WORKS BEAUTIFULLY
echo '****************************************************'
lineselect='/[Tt]ags:/' 
yamlpattern1="-e '${lineselect} s=(testtag)]=\1 ]=' -e '${lineselect} s=(\[|[[:space:]])(testtag,?)(]|[[:space:]])=\1 \2 \3=g' " 
#eval "gsed -E $yamlpattern1 testfile.md"
yamlpattern2="-e '${lineselect} s=([^A-z_\-])(testtag,?)([^A-z_\-])=\1\3=g' "
#eval "gsed -E $yamlpattern1 $yamlpattern2 testfile.md"
yamlpattern3="-e '${lineselect} s=[[:space:]]+= =g' "
#eval "gsed -E $yamlpattern1 $yamlpattern2 $yamlpattern3 testfile.md"

# full answer: 
sed="gsed -E "
sed+="$yamlpattern1 $yamlpattern2 $yamlpattern3"
eval "$sed" testfile.md
# ======================================================================
# TEST CODE BODY: THIS WORKS BEAUTIFULLY
echo '****************************************************'
lineselect='/#testtag[^A-z_\-\$]/'
bodypattern1="-e '${lineselect} s=([^A-z]|[^/_\-]|^)(#testtag)([^A-z/_\-]|\\$)=\1  \2 \3=g' "
#eval "gsed -E $bodypattern testfile.md"
bodypattern2="-e '${lineselect} s= #testtag ==g'"
#eval "gsed -E $bodypattern testfile.md"
sed="gsed -E "
sed+="$bodypattern1 $bodypattern2"
eval "$sed" testfile.md

# ========================================================================
# TEST CORPUS
---
# use tags to express LATCH element types: locations category hierarchy
tags: [testtag testtag blah testtag  testtag, testtag]  # tags: commas are optional, quotes are not used
Tags: 
 - tag1
 - testtag
 - testtag

Aliases: [  ]  # aliases: commas and quotes are mandatory
created: 2022-11-02
---
- Last modified: `= this.file.mtime`
# testfile
#testtag #testtag #testtagnot 
This is another #testtag so it must be deleted

