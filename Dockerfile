FROM ubuntu:18.04

RUN apt update
RUN apt install -y git sudo
RUN git config --global user.email "dadiorchen@outlook.com"
RUN git config --global user.name "dadiorchen"
RUN mkdir -p ~/work/
RUN cd ~/work/ && \
  rm -rf neovim && \
  git clone https://github.com/neovim/neovim.git &&\
  cd neovim && \
  git fetch --all --tags && \
  git checkout tags/v0.4.3 && \
  git status && \
  rm -rf build/ && \
  sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip && \
  make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim" && \
  make install

RUN export PATH="$HOME/neovim/bin:$PATH"
RUN echo 'export PATH="$HOME/neovim/bin:$PATH"\n'\
  >> ~/.bashrc

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash && \
  . ~/.bashrc && \
  export NVM_DIR="$HOME/.nvm" && \
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && \
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  && \
  nvm && \
  nvm install 12.16.3 && \
  node -v && \
  cd ~ && \
  rm -rf dadiortemp && \
  git clone https://github.com/dadiorchen/dadiortemp.git && \
  cd dadiortemp && \
  cd openfile/ && \
  export NVM_DIR="$HOME/.nvm" && \
  npm i && \
  cd .. && \
  mkdir -p ~/.config/nvim/ && \
  rm -rf ~/.config/nvim/init.vim && \
  ln -s ~/dadiortemp/init.vim ~/.config/nvim/init.vim

#plugin
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
#set +e
#nvim --headless +PlugInstall +qa
#set -e

RUN echo 'alias nn="node ~/dadiortemp/openfile/nn.js"\n\
alias nv="nvim --listen /tmp/nvim"\n'\
>> ~/.bashrc

#coc
RUN rm -rf ~/.config/nvim/coc-settings.json
RUN ln -s ~/dadiortemp/coc-settings.json ~/.config/nvim/coc-settings.json

RUN echo "done!"
