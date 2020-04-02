#!/bin/bash

# Never do this

git checkout --orphan temp
git add --all
git commit --all --message "I miss the old Kanye"
git branch --delete --force master
git branch --move master
git push origin master --force
