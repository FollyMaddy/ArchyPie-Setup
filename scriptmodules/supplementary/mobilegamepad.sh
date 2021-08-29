#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="mobilegamepad"
rp_module_desc="Mobile Universal Gamepad for ArchyPie"
rp_module_licence="GPL3 https://raw.githubusercontent.com/sbidolach/mobile-gamepad/master/LICENSE"
rp_module_repo="git https://github.com/sbidolach/mobile-gamepad.git master"
rp_module_section="exp"
rp_module_flags="noinstclean nobin"

function depends_mobilegamepad() {
    depends_virtualgamepad "$@"
}

function remove_mobilegamepad() {
    pm2 stop app
    pm2 delete app
    rm -f /etc/apt/sources.list.d/nodesource.list
}

function sources_mobilegamepad() {
    gitPullOrClone "$md_inst"
    chown -R $user:$user "$md_inst"
}

function install_mobilegamepad() {
    npm install -g grunt-cli
    npm install pm2 -g --unsafe-perm
    cd "$md_inst"
    sudo -u $user npm install
}

function configure_mobilegamepad() {
    [[ "$md_mode" == "remove" ]] && return
    pm2 start app.sh
    pm2 startup
    pm2 save
}
