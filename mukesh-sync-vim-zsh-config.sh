#! /bin/bash

cp ~/.vimrc ~/scripts/configs 
cp ~/.zshrc ~/scripts/configs 
cp ~/.zsh_func ~/scripts/configs

cd ~/scripts

git add configs/.vimrc configs/.zshrc configs/.zsh_func

git commit -m "Updated vim and zsh config"

git push
