#!/bin/bash

set -x

function _info() { echo -e "$(tput setaf 2)$(tput rev)$(tput bold) \xE2\x9C\x93 $1 $(tput sgr0)"; "${@:2}"; }
function _executable() { command "$1" &>/dev/null; }
function _installed() { [ -f ~/.fzf.zsh ]; }

_install_homebrew() {
  _executable brew && return
  _info "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  
}

_install_homebrew_packages() {
  [ -e "$HOME"/.Brewfile ] || return
  _info "Installing/upgrading homebrew packages"
  brew update # update homebrew itself and the list of brew package versions
  brew bundle --global                  # install/upgrade from ~/.Brewfile
  brew upgrade                          # upgrade all homebrew packages
  brew upgrade --cask                   # upgrade all homebrew casks
  brew cleanup                          # remove outdated versions and dead symlinks from the homebrew prefix. WARNING this could break dependencies if low level libs are not pinned!!
  brew bundle --global cleanup --force  # remove brew packages not in ~/.Brewfile
  brew unlink node
}

_install_zsh() {
  _executable zsh && return
  _info "Installing zsh"
  echo "$(brew --prefix)/opt/zsh/bin/zsh" | sudo tee -a /etc/shells
  sudo chsh -s "$(brew --prefix)/opt/zsh/bin/zsh" "${USER}"
}

_install_antigen() {
  curl -L git.io/antigen > .antigen.zsh
}

_install_fzf() {
  _installed ~/.fzf.zsh && return
  # To install useful key bindings and fuzzy completion:
  $(brew --prefix)/opt/fzf/install
}

_install_fonts() {
  mkdir -p ~/.fonts
  curl -sLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf --output-dir ~/.fonts
  curl -sLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf --output-dir ~/.fonts
  curl -sLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf --output-dir ~/.fonts 
  curl -sLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf --output-dir ~/.fonts 
}

_install_homebrew
_install_homebrew_packages
_install_zsh
_install_antigen
_install_fzf
_install_fonts

