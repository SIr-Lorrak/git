#!/bin/sh

test_description='test when merge with untracked file'

. ./test-lib.sh


test_expect_success 'untracked fastforward' '
    echo content >README.md &&
    git add README.md &&
    git commit -m "init" &&
    git branch A &&
    git checkout -B B &&
    echo content >file &&
    git add file &&
    git commit -m "tracked" &&
    git switch A &&
    echo content >file &&
    git merge B
'

test_expect_failure 'untracked fastforward different content' '
    rm * &&
    rm -r .git &&
    git init &&
    echo content >README.md &&
    git add README.md &&
    git commit -m "init" &&
    git branch A &&
    git checkout -B B &&
    echo content >file &&
    git add file &&
    git commit -m "tracked" &&
    git switch A &&
    echo dif >file &&
    git merge B
'

test_expect_success 'untracked normal merge' '
    rm * &&
    rm -r .git &&
    git init &&
    echo content >README.md &&
    git add README.md &&
    git commit -m "init" &&
    git branch A &&
    git checkout -B B &&
    echo content >fileB &&
    echo content >file &&
    git add fileB &&
    git add file &&
    git commit -m "tracked" &&
    git switch A &&
    echo content >fileA &&
    git add fileA &&
    git commit -m "exA" &&
    echo content >file &&
    git merge B -m "merge"
'

test_expect_failure 'untracked normal merge different content' '
    rm * &&
    rm -r .git &&
    git init &&
    echo content >README.md &&
    git add README.md &&
    git commit -m "init" &&
    git branch A &&
    git checkout -B B &&
    echo content >fileB &&
    echo content >file &&
    git add fileB &&
    git add file &&
    git commit -m "tracked" &&
    git switch A &&
    echo content >fileA &&
    git add fileA &&
    git commit -m "exA" &&
    echo dif >file &&
    git merge B -m "merge"
'

test_done