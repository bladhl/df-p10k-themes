#!/usr/bin/env zsh
#
# WCAG 2.x contrast checker used by tests/contrast.bats.
#
# Deliberately re-implements relative-luminance/contrast math rather than
# calling _df_p10k_on_color from themes/_bindings.zsh, so a regression in
# that function has an independent check watching it instead of grading its
# own homework.
#
# Usage: wcag_contrast.zsh <active.zsh-path> <theme-name> <style-name>
# The caller pre-sets POWERLEVEL9K_DIR_BACKGROUND/POWERLEVEL9K_BACKGROUND (or
# neither, for lean) in the environment before invoking this script, the
# same way the CLI-produced dropin would see them from a sourced ~/.p10k.zsh.
#
# Exits 0 with "CHECKS=<n>" on stdout when every pair meets its threshold
# (or when called with no arguments, to run the sanity check alone). Exits 1
# and prints one "theme style SEGMENT fg(role) bg(role) ratio (want >= t)"
# line per failing pair, plus the same CHECKS=<n> line, otherwise.

emulate -L zsh

active=$1
theme=$2
style=$3

_contrast_luminance() {
  emulate -L zsh
  local hex=$1
  local -F r=$(( (16#${hex[2,3]}) / 255.0 ))
  local -F g=$(( (16#${hex[4,5]}) / 255.0 ))
  local -F b=$(( (16#${hex[6,7]}) / 255.0 ))
  local -F lr=$(( r <= 0.03928 ? r/12.92 : ((r+0.055)/1.055)**2.4 ))
  local -F lg=$(( g <= 0.03928 ? g/12.92 : ((g+0.055)/1.055)**2.4 ))
  local -F lb=$(( b <= 0.03928 ? b/12.92 : ((b+0.055)/1.055)**2.4 ))
  REPLY=$(( 0.2126*lr + 0.7152*lg + 0.0722*lb ))
}

_contrast_ratio() {
  emulate -L zsh
  local fg=$1 bg=$2
  _contrast_luminance $fg; local -F l1=$REPLY
  _contrast_luminance $bg; local -F l2=$REPLY
  REPLY=$(( l1 > l2 ? (l1+0.05)/(l2+0.05) : (l2+0.05)/(l1+0.05) ))
}

_is_hex() {
  [[ $1 == '#'[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F] ]]
}

# Sanity-check the math itself against known WCAG values before trusting it
# for the real assertions below.
_contrast_ratio '#000000' '#ffffff'
if (( REPLY < 20.99 || REPLY > 21.01 )); then
  print -r -- "SANITY FAIL: black/white = $REPLY, want 21.0"
  exit 1
fi
_contrast_ratio '#777777' '#ffffff'
if (( REPLY < 4.46 || REPLY > 4.50 )); then
  print -r -- "SANITY FAIL: #777777/white = $REPLY, want ~4.48"
  exit 1
fi

if [[ -z $active ]]; then
  print -r -- "CHECKS=0"
  exit 0
fi

source $active

checks=0
failed=0

# Resolves a hex value back to the semantic role name it came from, purely
# to make a failure line actionable (which role to retune, not just which
# raw hex). Falls back to the hex itself when nothing matches.
_role_name() {
  emulate -L zsh
  local hex=$1 name
  for name in c_accent c_ok c_warn c_error c_info c_muted c_subtext \
              c_base c_surface c_text \
              c_red c_ruby c_peach c_yellow c_green c_teal c_cyan c_sky \
              c_sapphire c_blue c_lavender c_mauve c_purple c_pink; do
    [[ ${(P)name} == $hex ]] && { REPLY=$name; return }
  done
  REPLY=$hex
}

_check_pair() {
  emulate -L zsh
  local seg=$1 fg=$2 bg=$3
  [[ -z $fg || -z $bg ]] && return 0
  _is_hex $fg || return 0
  _is_hex $bg || return 0
  # Policy: prompt segments are short, bold, colored UI labels, not body
  # text — WCAG 1.4.11 (non-text/UI contrast, 3.0:1) is the right floor for
  # them, not 1.4.3's 4.5:1 body-text rule. The one exception is c_text
  # itself sitting directly on a neutral surface (c_base/c_surface): that IS
  # a body-text-shaped pair (the closest thing this contract has to reading
  # text), so it keeps the stricter 4.5:1. A rainbow on-color result sitting
  # on a hue pill is excluded even when it happens to equal c_text, because
  # that pairing is a colored UI chip, not reading text.
  local threshold=3.0
  [[ $fg == $c_text && ( $bg == $c_base || $bg == $c_surface ) ]] && threshold=4.5
  checks=$(( checks + 1 ))
  _contrast_ratio $fg $bg
  local -F ratio=$REPLY
  if (( ratio < threshold )); then
    failed=$(( failed + 1 ))
    _role_name $fg; local fgrole=$REPLY
    _role_name $bg; local bgrole=$REPLY
    printf '%s %s %-28s %-8s(%s) %-8s(%s) %.2f (want >= %.1f)\n' \
      $theme $style $seg $fg $fgrole $bg $bgrole $ratio $threshold
  fi
}

# Every real POWERLEVEL9K_*_FOREGROUND, paired with its background: the
# matching per-segment BACKGROUND if set, else the shared classic surface if
# non-empty, else c_base (lean has neither, so this is the terminal's own
# unknowable background — c_base is the closest available proxy).
for v in ${(k)parameters}; do
  [[ $v == POWERLEVEL9K_*_FOREGROUND ]] || continue
  local seg=${v#POWERLEVEL9K_}
  seg=${seg%_FOREGROUND}
  local fg=${(P)v}
  local bgvar="POWERLEVEL9K_${seg}_BACKGROUND"
  local bg=${(P)bgvar:-}
  if [[ -z $bg ]]; then
    if [[ -n $POWERLEVEL9K_BACKGROUND ]]; then
      bg=$POWERLEVEL9K_BACKGROUND
    else
      bg=$c_base
    fi
  fi
  _check_pair $seg $fg $bg
done

# my_git_formatter's inline colors aren't real POWERLEVEL9K_* segments, so
# they're paired by hand against every background they actually render
# behind: each VCS state pill p10k can paint under the "found" set (a clean
# repo sits on VCS_CLEAN, not VCS_MODIFIED) and the "still loading" case.
for state in CLEAN MODIFIED UNTRACKED; do
  local bgvar="POWERLEVEL9K_VCS_${state}_BACKGROUND"
  local vcs_found_bg=${(P)bgvar:-${POWERLEVEL9K_BACKGROUND:-$c_base}}
  for role in BRANCH_ICON NAME STAGED UNSTAGED UNTRACKED CONFLICTED AHEAD_BEHIND STASH; do
    local fgvar="_DF_P10K_VCS_${role}"
    _check_pair "VCS_${state}_FMT_${role}" ${(P)fgvar} $vcs_found_bg
  done
done
vcs_loading_bg=${POWERLEVEL9K_VCS_LOADING_BACKGROUND:-${POWERLEVEL9K_BACKGROUND:-$c_base}}
_check_pair VCS_FMT_MUTED        $_DF_P10K_VCS_MUTED        $vcs_loading_bg

print -r -- "CHECKS=$checks"
exit $(( failed > 0 ? 1 : 0 ))
