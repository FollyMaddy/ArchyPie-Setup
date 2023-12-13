#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="lr-theodore"
rp_module_desc="Thomson TO7, TO7/70, TO8, TO8D, TO9, TO9+, MO5 & MO6 Libretro Core"
rp_module_help="ROM Extensions: .fd .k7 .m5 .m7 .rom .sap .zip\n\nCopy Thomson Games To: ${romdir}/moto"
rp_module_licence="GPL3 https://raw.githubusercontent.com/Zlika/theodore/master/LICENSE"
rp_module_repo="git https://github.com/Zlika/theodore master"
rp_module_section="exp"
rp_module_flags=""

function sources_lr-theodore() {
    gitPullOrClone
}

function build_lr-theodore() {
    make clean
    make
    md_ret_require="theodore_libretro.so"
}

function install_lr-theodore() {
    md_ret_files=('theodore_libretro.so')
}

function configure_lr-theodore() {
    if [[ "${md_mode}" == "install" ]]; then
        mkRomDir "moto"
        defaultRAConfig "moto"
    fi

    addEmulator 1 "${md_id}" "moto" "${md_inst}/theodore_libretro.so"

    addSystem "moto"
}
