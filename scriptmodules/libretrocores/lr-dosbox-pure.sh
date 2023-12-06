#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="lr-dosbox-pure"
rp_module_desc="DOSBox Pure Libretro Core"
rp_module_help="ROM Extensions: .bat .com .conf .cue .dosz .exe .ima .img .ins .iso .jrc .m3u .m3u8 .tc .vhd .zip\n\nCopy DOS Games To: ${romdir}/pc\n\nOPTIONAL: Copy Soundfont *.sf2 & MT32 Files _control.rom & _pcm.rom To: ${biosdir}/pc"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/dosbox-pure/main/LICENSE"
rp_module_repo="git https://github.com/libretro/dosbox-pure main"
rp_module_section="exp"
rp_module_flags=""

function sources_lr-dosbox-pure() {
    gitPullOrClone
}

function build_lr-dosbox-pure() {
    make clean
    make
    md_ret_require="${md_build}/dosbox_pure_libretro.so"
}

function install_lr-dosbox-pure() {
    md_ret_files=(
        'dosbox_pure_libretro.so'
        'README.md'
    )
}

function configure_lr-dosbox-pure() {
    if [[ "${md_mode}" == "install" ]]; then
        mkRomDir "pc"
        mkUserDir "${biosdir}/pc"
        defaultRAConfig "pc"
    fi

    addEmulator 0 "${md_id}" "pc" "${md_inst}/dosbox_pure_libretro.so"

    addSystem "pc"
}
