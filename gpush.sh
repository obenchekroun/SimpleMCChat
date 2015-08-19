#!/bin/bash
git add --all
git commit -m "$*"
git push | terminal-notifier -title "SimpleMCChat pushed online"

