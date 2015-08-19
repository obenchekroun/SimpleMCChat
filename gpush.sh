#!/bin/bash
git add --all
git commit -m "$*"
git push
terminal-notifier -title "SimpleMCChat git update" -message "Task done. See terminal for potential errors"

