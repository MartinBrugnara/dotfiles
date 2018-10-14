#!/bin/bash

echo "> Install homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "> Tap repos"
brew tap caskroom/cask
brew tap homebrew/dupes
brew tap jeffreywildman/homebrew-virt-manager

# Quirks in install may assign this root (then everything breaks)
mkdir -p $HOME/.config

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
brew install bash cmake gpatch less m4 make

echo "> Install GPG stuff"
brew install gnupg pinentry-mac
cat <<EOF > $HOME/.gnupg/gpg-agent.conf
default-cache-ttl 600
max-cache-ttl 7200
enable-ssh-support
write-env-file ~/.gpg-agent-info
pinentry-program /usr/local/bin/pinentry-mac
EOF

echo "> Install daily programs/utilities"
brew install android-platform-tools axel clang-format file-formula git go \
    haskell-stack htop imagemagick install lynx mercurial mozjpeg neomutt \
    neovim --override-system-vi openssh openvpn perl python python3 rsync \
    ruby sassc screen sshfs svn tmux unzip ykpers youtube-dl

echo "> Install applications"
brew cask install postgres
brew install mariadb virt-manager virt-viewer

echo "> Install python pkgs"
# Mutt
pip2 install goobook isort


# After install
echo "> Post installation action required"
echo "- please execute 'goobook authenticate'"

echo "> Be sure the owner of ~/.config is $USER"
