#! /bin/bash

cp ~/.vimrc ~/scripts/configs 
cp ~/.zshrc ~/scripts/configs 
cp ~/.zsh_aliases ~/scripts/configs 
cp ~/.zsh_func ~/scripts/configs
cp ~/.p10k.zsh ~/scripts/configs

cd ~/scripts

git add configs/.vimrc configs/.zshrc configs/.zsh_func configs/.p10k.zsh configs/.zsh_aliases

git commit -m "Updated vim and zsh config"

git push
