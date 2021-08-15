#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="advmame-1.4"
rp_module_desc="AdvanceMAME v1.4 - Arcade Emulator"
rp_module_help="ROM Extension: .zip\n\nCopy your AdvanceMAME roms to either $romdir/mame-advmame or\n$romdir/arcade"
rp_module_licence="GPL2 https://raw.githubusercontent.com/amadvance/advancemame/master/COPYING"
rp_module_repo="file $__archive_url/advancemame-1.4.tar.gz"
rp_module_section="opt"
rp_module_flags="!mali !kms"

function depends_advmame-1.4() {
    local depends=(sdl)
    getDepends "${depends[@]}"
}

function _sources_patch_advmame-1.4() {
    # update internal names to separate out config files (due to incompatible options)
    sed -i "s/advmame\.rc/$md_id.rc/" advance/v/v.c advance/cfg/cfg.c

    if grep -q "ADVANCE_NAME" advance/osd/emu.h; then
        sed -i "s/ADVANCE_NAME \"advmame\"/ADVANCE_NAME \"$md_id\"/" advance/osd/emu.h
    else
        sed -i "s/ADV_NAME \"advmame\"/ADV_NAME \"$md_id\"/" advance/osd/emu.h
    fi

    if isPlatform "rpi"; then
        if grep -q "MAP_FIXED" advance/linux/vfb.c; then
            sed -i 's/MAP_SHARED | MAP_FIXED,/MAP_SHARED,/' advance/linux/vfb.c
        fi

        # patch advmame to use a fake generated mode with the exact dimensions for fb - avoids need for configuring monitor / clocks.
        # the pi framebuffer doesn't use any of the framebuffer timing configs - it hardware scales from chosen dimensions to actual size
        applyPatch "$scriptdir/scriptmodules/$md_type/advmame/01_rpi_framebuffer.diff"
    fi
}

function sources_advmame-1.4() {
    downloadAndExtract "$md_repo_url" "$md_build" --strip-components 1
    _sources_patch_advmame-1.4 1.4
}

function build_advmame-1.4() {
    ./configure CFLAGS="$CFLAGS -fsigned-char -fno-stack-protector" LDFLAGS="-s -lm -Wl,--no-as-needed" --prefix="$md_inst"
    make clean
    make
}

function install_advmame-1.4() {
    make install
}

function configure_advmame-1.4() {
    configure_advmame
}
