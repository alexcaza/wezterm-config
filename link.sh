#!/bin/bash

ln wezterm.lua ~/.wezterm.lua

mkdir -p ~/.weztermocil

ln -s $(pwd)/weztermocil/configs/* ~/.weztermocil/

chmod +x $(pwd)/weztermocil/weztermocil.sh

echo "Linking weztermocil... Might need sudo priviledges"
sudo ln weztermocil/weztermocil.sh /usr/local/bin/weztermocil
