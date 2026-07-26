# My dot files

- `links.sh`: Creates a link in the home directory for each file in `files`.
- `osx-bootstrap.sh`: Install common programs and utilities on clean macOS.
- for zsh:
```
git config --add oh-my-zsh.hide-status 1
git config --add oh-my-zsh.hide-dirty 1
```

API key and other personal ENV vars are expected to be listed in `~/.secrets.sh`

# FreeBSD
## GPG
```
# pkg install pcsc-lite pcsc-tools devel/libccid

$ cat <<EOF > $HOME/.gnupg/scdaemon.conf
disable-ccid
pcsc-driver /usr/local/lib/libpcsclite.soconf
EOF

# cat <<EOF > /etc/rc.conf.d/pcscd
pcscd_flags="--disable-polkit"
EOF

# sysrc pcscd_enable="YES"
# system pcscd start

$ gpgconf --kill all
$ gpg --card-status
```

