#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="lr-handy"
rp_module_desc="Atari Lynx Libretro Core"
rp_module_help="ROM Extensions: .lnx .zip\n\nCopy Atari Lynx ROMs To: ${romdir}/atarilynx\n\nCopy BIOS File: lynxboot.img To: ${biosdir}/atarilynx"
rp_module_licence="ZLIB https://raw.githubusercontent.com/libretro/libretro-handy/master/lynx/license.txt"
rp_module_repo="git https://github.com/libretro/libretro-handy master"
rp_module_section="main"

function sources_lr-handy() {
    gitPullOrClone
}

function build_lr-handy() {
    make clean
    make
    md_ret_require="${md_build}/handy_libretro.so"
}

function install_lr-handy() {
    md_ret_files=('handy_libretro.so')
}

function configure_lr-handy() {
    if [[ "${md_mode}" == "install" ]]; then
        mkRomDir "atarilynx"
        mkUserDir "${biosdir}/atarilynx"
        defaultRAConfig "atarilynx"
    fi

    addEmulator 1 "${md_id}" "atarilynx" "${md_inst}/handy_libretro.so"

    addSystem "atarilynx"
}
