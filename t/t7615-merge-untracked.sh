#!/bin/sh

test_description='test when merge with untracked files and the option --overwrite-same-content'

GIT_TEST_DEFAULT_INITIAL_BRANCH_NAME=main
export GIT_TEST_DEFAULT_INITIAL_BRANCH_NAME

. ./test-lib.sh

test_expect_success 'setup' '
	test_commit "init" README.md "content" &&
	git checkout -b A
'

test_expect_success 'fastforward overwrite untracked file that has the same content' '
	test_when_finished "git branch -D B && git reset --hard init && git clean --force" &&
	git checkout -b B &&
	test_commit --no-tag "tracked" file "content" &&
	git checkout A &&
	echo content >file &&
	git merge --overwrite-same-content B
'

test_expect_success 'fastforward fail when untracked file has different content' '
	test_when_finished "git branch -D B && git reset --hard init && git clean --force" &&
	git checkout -b B &&
	test_commit --no-tag "tracked" file "content" &&
	git switch A &&
	echo other >file &&
	test_must_fail git merge --overwrite-same-content B
'

test_expect_success 'normal merge overwrite untracked file that has the same content' '
	test_when_finished "git branch -D B && git reset --hard init && git clean --force" &&
	git checkout -b B &&
	test_commit --no-tag "tracked" file "content" fileB "content" &&
	git switch A &&
	test_commit --no-tag "exA" fileA "content" &&
	echo content >file &&
	git merge --overwrite-same-content B
'

test_expect_success 'normal merge fail when untracked file has different content' '
	test_when_finished "git branch -D B && git reset --hard init && git clean --force" &&
	git checkout -b B &&
	test_commit --no-tag "tracked" file "content" fileB "content" &&
	git switch A &&
	test_commit --no-tag "exA" fileA "content" &&
	echo dif >file &&
	test_must_fail git merge --overwrite-same-content B
'

test_expect_success 'merge fail when tracked file modification is unstaged' '
	test_when_finished "git branch -D B && git reset --hard init && git clean --force" &&
	test_commit --no-tag "unstaged" file "other" &&
	git checkout -b B &&
	test_commit --no-tag "staged" file "content" &&
	git switch A &&
	echo content >file &&
	test_must_fail git merge --overwrite-same-content B
'

test_expect_success 'fastforward overwrite untracked file that has the same content with the configuration variable' '
    test_when_finished "git branch -D B && git reset --hard init && git clean --force" &&
    test_config merge.overwritesamecontent true &&
    git checkout -b B &&
    test_commit --no-tag "tracked" file "content" &&
    git checkout A &&
    echo content >file &&
    git merge B
'

test_expect_success 'normal merge overwrite untracked file that has the same content with the configuration variable' '
    test_when_finished "git branch -D B && git reset --hard init && git clean --force" &&
    test_config merge.overwritesamecontent true &&
    git checkout -b B &&
	test_commit --no-tag "tracked" file "content" fileB "content" &&
	git switch A &&
	test_commit --no-tag "exA" fileA "content" &&
	echo content >file &&
    git merge B
'

test_done
