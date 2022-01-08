#!/bin/bash

# Quick and dirty bash script to encrypt all sops managed files

for regex in $(cat .sops.yaml | grep path_regex | awk '{ print $3}'); do
	for file in $(find . -regextype posix-extended -regex ".*\/$regex" -print | grep -v '.enc'); do
		sops -e $file > "$file.enc"
	done
done
