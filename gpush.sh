#!/usr/local/bin/bash

function notifyDone () { command="$@"; terminal-notifier -title "SimpleMCChat Git update" -message "Done with '$command'!" -activate com.googlecode.iterm2; }
function notifyError () { command="$@"; terminal-notifier -title "SimpleMCChat Git update ERROR!" -message "'$command' exited with error!" -activate com.googlecode.iterm2; }
function wn () { ($@ && notifyDone $@) || notifyError $@; }
function n () { $@; notifyDone $@;}

git add --all
git commit -m "$*"
wn git push

