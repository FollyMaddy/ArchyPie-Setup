#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="lr-bsnes"
rp_module_desc="Super Nintendo Entertainment System Libretro Core"
rp_module_help="ROM Extensions: .bml .sfc .smc .zip\n\nCopy SNES ROMs To: ${romdir}/snes"
rp_module_licence="GPL3 https://raw.githubusercontent.com/libretro/bsnes/master/LICENSE.txt"
rp_module_repo="git https://github.com/libretro/bsnes master"
rp_module_section="opt"
rp_module_flags=""

function sources_lr-bsnes() {
    gitPullOrClone
}

function build_lr-bsnes() {
    local params=('target="libretro"' 'build="release"' 'binary="library"')
    make -C bsnes clean "${params[@]}"
    make -C bsnes "${params[@]}"
    md_ret_require="${md_build}/bsnes/out/bsnes_libretro.so"
}

function install_lr-bsnes() {
    md_ret_files=('bsnes/out/bsnes_libretro.so')
}

function configure_lr-bsnes() {
    if [[ "${md_mode}" == "install" ]]; then
        mkRomDir "snes"
        defaultRAConfig "snes"
    fi

    addEmulator 1 "${md_id}" "snes" "${md_inst}/bsnes_libretro.so"

    addSystem "snes"
}
