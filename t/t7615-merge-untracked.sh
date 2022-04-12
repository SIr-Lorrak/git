#!/bin/sh

test_description='test when merge with untracked file'

. ./test-lib.sh


test_expect_success 'overwrite the file when fastforward and the same content' '
    echo content >README.md &&
    test_commit "init" README.md &&
    git branch A &&
    git checkout -b B &&
    echo content >file &&
    git add file &&
    git commit -m "tracked" &&
    git switch A &&
    echo content >file &&
    git merge B
'

test_expect_success 'merge fail with fastforward and different content' '
    rm * &&
    rm -r .git &&
    git init &&
    echo content >README.md &&
    test_commit "init" README.md &&
    git branch A &&
    git checkout -b B &&
    echo content >file &&
    git add file &&
    git commit -m "tracked" &&
    git switch A &&
    echo dif >file &&
    test_must_fail git merge B
'

test_expect_success 'normal merge with untracked with the same content' '
    rm * &&
    rm -r .git &&
    git init &&
    echo content >README.md &&
    test_commit "init" README.md &&
    git branch A &&
    git checkout -b B &&
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

test_expect_success 'normal merge fail when untracked with different content' '
    rm * &&
    rm -r .git &&
    git init &&
    echo content >README.md &&
    test_commit "init" README.md &&
    git branch A &&
    git checkout -b B &&
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
    test_must_fail git merge B -m "merge"
'

test_done