# Neovim Installation

Source: https://github.com/neovim/neovim/wiki/Installing-Neovim

Neovim is available through EPEL (Extra Packages for Enterprise Linux)

```bash
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
yum install -y neovim python3-neovim
```

# Prerequisite

Need to clone the packer repo for the things to work
```sh
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Download NerdFonts and copy them in ~/.local/share/fonts/
```sh 
# mkdir -p ~/.local/share/fonts/NerdFonts/
# ls ~/.local/share/fonts/NerdFonts/
 ```

