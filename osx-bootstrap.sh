#!/bin/bash

echo "> Install homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "> Tap repos"
brew tap caskroom/cask
brew tap homebrew/dupes
brew tap jeffreywildman/homebrew-virt-manager

echo "> Install gnu utilities"
brew install binutils coreutils diffutils gawk gnu-getopt gnutls gzip watch wget \
  ed --with-default-names \
  findutils --with-default-names \
  gnu-indent --with-default-names \
  gnu-sed --with-default-names \
  gnu-tar --with-default-names \
  gnu-which --with-default-names \
  grep --with-default-names \
  wdiff --with-gettext

echo "> Update existing gnu utilities"
brew install bash  gpatch less m4 make

echo "> Install daily programs/utilities"
brew install file-formula git openssh perl python pypy go ruby rsync \
  svn mercurial unzip screen tmux htop neovim  --override-system-vi \
  openvpn sshfs android-platform-tools youtube-dl

echo "> Install applications"
brew cask install postgres
brew install virt-manager virt-viewer
