#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="lr-desmume2015"
rp_module_desc="Nintendo DS Libretro Core"
rp_module_help="ROM Extensions: .bin .nds .zip\n\nCopy Nintendo DS ROMs To: ${romdir}/nds\n\nOPTIONAL: Copy BIOS Files: bios7.bin, bios9.bin & firmware.bin To: ${biosdir}/nds"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/desmume/master/desmume/COPYING"
rp_module_repo="git https://github.com/libretro/desmume2015 master"
rp_module_section="exp"

function depends_lr-desmume2015() {
   depends_lr-desmume
}

function sources_lr-desmume2015() {
    gitPullOrClone
}

function build_lr-desmume2015() {
    local params=()
    isPlatform "arm" && params+=("platform=unixarmvhardfloat")
    isPlatform "aarch64" && params+=("DESMUME_JIT=0")

    make -C desmume clean
    make -C desmume "${params[@]}"
    md_ret_require="${md_build}/desmume/desmume2015_libretro.so"
}

function install_lr-desmume2015() {
    md_ret_files=('desmume/desmume2015_libretro.so')
}

function configure_lr-desmume2015() {
    if [[ "${md_mode}" == "install" ]]; then
        mkRomDir "nds"
        mkUserDir "${biosdir}/nds"
        defaultRAConfig "nds"
    fi

    addEmulator 0 "${md_id}" "nds" "${md_inst}/desmume2015_libretro.so"

    addSystem "nds"
}
