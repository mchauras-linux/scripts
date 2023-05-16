#! /bin/bash

git branch | grep -v "master$" | grep -v "main$" | xargs git branch -D
