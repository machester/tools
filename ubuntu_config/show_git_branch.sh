#!/bin/bash

function git_branch {
   branch="`git branch 2>/dev/null | grep "^\*" | sed -e "s/^\*\ //"`"
   if [ "${branch}" != "" ];then
       if [ "${branch}" = "(no branch)" ];then
           branch="(`git rev-parse --short HEAD`...)"
       fi
       echo " ($branch)"
   fi
}

export PS1='<\u> \\ \[${CYAN}\]\W\[${GREEN}\]$(git_branch)\[${WHITE}\]\$ '


# Show current git branch in command line
# parse_git_branch() {
#      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
# }
# # export PS1="\[\033[37m\]{\u}@\w\[\033[33m\]\$(parse_git_branch)\[\033[0m\] $ "
# # export PS1="\[\033[37m\](\u)@\w\[\033[33m\][$(parse_git_branch)]\[\033[0m\]$:"
# export PS1="\[\033[31m\](\u)\[\033[37m\]@\w\[\033[33m\]$(parse_git_branch)\[\033[0m\]$ "
