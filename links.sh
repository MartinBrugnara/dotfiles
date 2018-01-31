#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

find "$DIR/files" -maxdepth 1 |while read -r fname; do
  file=$(basename "$fname")
  echo "$fname"
  dst="$HOME/$file"
  [[ "$file" != "files" ]] &&  \
    [[ ! -a "$dst" ]] && \
    ln -vs "$fname" "$dst"
done
