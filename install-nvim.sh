#!/bin/bash
set -e
apt update
apt install -y git sudo
mkdir -p ~/work/
cd ~/work/
rm -rf neovim
git clone git@github.com:neovim/neovim.git
cd neovim
git fetch --all --tags
git checkout tags/stable
git status
rm -rf build/
sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
make install
export PATH="$HOME/neovim/bin:$PATH"
cat >> ~/.bashrc <<EOF
export PATH="$HOME/neovim/bin:$PATH"
EOF
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
source ~/.bashrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm
nvm install 12.16.3
node -v
#init.vim
cd ~
rm -rf dadiortemp
git clone git@github.com:dadiorchen/dadiortemp.git
cd dadiortemp
cd openfile/
npm i
cd ..
mkdir -p ~/.config/nvim/
rm -rf ~/.config/nvim/init.vim
ln -s ~/dadiortemp/init.vim ~/.config/nvim/init.vim

#plugin
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
set +e
nvim --headless +PlugInstall +qa
set -e

cat >> ~/.bashrc <<EOF
alias nn="node ~/dadiortemp/openfile/nn.js"
alias nv="nvim --listen /tmp/nvim"
EOF
