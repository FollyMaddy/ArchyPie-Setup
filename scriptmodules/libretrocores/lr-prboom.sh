#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="lr-prboom"
rp_module_desc="PrBoom (Doom, Doom II, Final Doom & Doom IWAD Mods) Libretro Core"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/libretro-prboom/master/COPYING"
rp_module_repo="git https://github.com/libretro/libretro-prboom.git master"
rp_module_section="opt"

function depends_lr-prboom() {
    getDepends perl-rename
}

function sources_lr-prboom() {
    gitPullOrClone
}

function build_lr-prboom() {
    make clean
    make
    md_ret_require="$md_build/prboom_libretro.so"
}

function install_lr-prboom() {
    md_ret_files=(
        'prboom_libretro.so'
        'prboom.wad'
    )
}

function _game_data_lr-prboom() {
    local dest="$romdir/ports/doom"

    if [[ -f "$dest/doom1/doom1.wad" || -f $dest/doom1/DOOM1.WAD]]; then
        return
    else
        # Download DOOM Shareware.
        download "$__archive_url/doom1.wad" "$dest/doom1/doom1.wad"
    fi
    if ! echo "e9bf428b73a04423ea7a0e9f4408f71df85ab175 $dest/freedoom/freedoom1.wad" | sha1sum -c &>/dev/null; then
        # Download or Update Freedoom
        downloadAndExtract "https://github.com/freedoom/freedoom/releases/download/v0.12.1/freedoom-0.12.1.zip" "$dest/freedoom" -j -LL
    fi
    chown -R "$user:$user" "$dest"
}

function _add_games_lr-prboom() {
    local cmd="$1"
    local dir
    local game
    declare -A games=(
        ['doom1/doom1.wad']="Doom (Shareware)"
        ['doom1/doom.wad']="Doom: The Ultimate Doom"
        ['doom1/doomu.wad']="Doom: The Ultimate Doom"
        ['doom2/doom2.wad']="Doom II: Hell on Earth"
        ['doom2/masterlevels.wad']="Doom II: Master Levels"
        ['finaldoom/tnt.wad']="Final Doom: TNT: Evilution"
        ['finaldoom/plutonia.wad']="Final Doom: The Plutonia Experiment"
        ['freedoom/freedoom1.wad']="Freedoom: Phase I"
        ['freedoom/freedoom2.wad']="Freedoom: Phase II"
    )
    if [[ "$md_id" == "gzdoom" || "$md_id" == "lzdoom" ]]; then
        games+=(
            ['addons/bloom/bloom.pk3']="Doom II: Bloom"
            ['addons/brutal/brutal.pk3']="Doom: Brutal Doom"
            ['addons/brutal/brutality.wad']="Doom: Project Brutality"
            ['addons/brutal/brutalwolf.pk3']="Doom: Brutal Wolfenstein"
            ['addons/sigil/sigil.wad']="Doom: SIGIL"
            ['chex/chex.wad']="Chex Quest"
            ['chex/chex2.wad']="Chex Quest 2"
            ['chex/chex3.wad']="Chex Quest 3"
            ['hacx/hacx.wad']="HacX"
            ['heretic/heretic.wad']="Heretic: Shadow of the Serpent Riders"
            ['heretic/hexdd.wad']="Hexen: Deathkings of the Dark Citadel"
            ['heretic/hexen.wad']="Hexen: Beyond Heretic"
            ['strife/strife1.wad']="Strife: Quest for the Sigil"
        )
    fi

    # Create .sh Files for Each Game Found. Uppercase Filnames Will Be Converted to Lowercase.
    for game in "${!games[@]}"; do
        dir="$romdir/ports/doom/${game%/*}"
        if [[ "$md_mode" == "install" ]]; then
            pushd "$dir" || return
            perl-rename 'y/A-Z/a-z/' [^.-]{*,*/*}
            popd || return
        fi
        if [[ -f "$dir/${game##*/}" ]]; then
            if [[ "${game##*/}" == "sigil.wad" || "${game##*/}" == "bloom.wad" || "${game##*/}" =~ "brutal" ]]; then
                addPort "$md_id" "doom" "${games[$game]}" "$cmd -file %ROM%" "${game##*/}"
            elif [[ "$md_id" == "gzdoom" || "$md_id" == "lzdoom" ]]; then
                addPort "$md_id-addon" "doom" "${games[$game]}" "$cmd -file $romdir/ports/doom/addons/misc/*" "${game##*/}"
            else
                addPort "$md_id" "doom" "${games[$game]}" "$cmd" "${game##*/}"
            fi
        fi
    done
}

function configure_lr-prboom() {
    if [[ "$md_mode" == "install" ]]; then
        mkRomDir "ports/doom"
        mkUserDir "$biosdir/doom"

        _game_data_lr-prboom

        cp "$md_inst/prboom.wad" "$biosdir/doom/"
    fi

    setConfigRoot "ports"

    defaultRAConfig "doom" "system_directory" "$biosdir/doom"

    _add_games_lr-prboom "$md_inst/prboom_libretro.so"
}
