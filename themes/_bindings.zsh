#
# Shared bindings consumed by every df-p10k-themes theme file.
#
# A theme file declares its palette + semantic roles (see _template.zsh) and
# then sources this file. The CLI concatenates theme + bindings into a single
# active.zsh so the dropin is self-contained at runtime.
#
# Expected role variables (set by the theme file BEFORE sourcing this):
#   semantic — $c_accent  $c_ok  $c_warn  $c_error  $c_info  $c_muted  $c_subtext
#   surfaces — $c_base  $c_surface  $c_text
#              c_base is the palette's own page/terminal background; c_surface
#              is the step used as the shared segment background in classic
#              style (the darkest neutral on a dark theme, the lightest on a
#              light one, distinct from c_base where the palette has such a
#              step); c_text is the primary on-surface text color.
#   palette  — $c_red  $c_ruby  $c_peach  $c_yellow  $c_green  $c_teal
#              $c_cyan  $c_sky  $c_sapphire  $c_blue  $c_lavender
#              $c_mauve  $c_purple  $c_pink
#
# Expected metadata (also set by the theme file):
#   THEME_ACCENTS=(name1 name2 ...)
#   THEME_ACCENT_DEFAULT=<name>
#   typeset -gA THEME_PALETTE=(name1 color1 name2 color2 ...)
#
# Color values may be xterm-256 integers (0..255) OR truecolor hex strings
# like "#cba6f7" — p10k accepts both. c_base/c_surface/c_text specifically
# must be "#rrggbb" hex (every shipped theme already uses hex for these) so
# _df_p10k_on_color below can do WCAG contrast math on them.
#
# Segments are mapped to colors based on tool brand identity (e.g. Node→green,
# Rust→peach, K8s→sapphire) so the prompt reads as a harmonious palette rather
# than a few colors repeated everywhere.
#
# p10k prompt styles (lean/pure, classic, rainbow) are detected below from
# what the already-sourced ~/.p10k.zsh left behind, and every segment is
# emitted differently per style: lean gets a plain foreground, classic adds
# one shared surface background on top of the same foregrounds, and rainbow
# paints the hue as the segment's own background and derives a contrasting
# on-color foreground instead of using the hue as text.
#

#--- style detection ---------------------------------------------------------
# The dropin sources after ~/.p10k.zsh, so by now the active preset's own
# variables are visible. Fingerprints (see p10k-{lean,classic,rainbow}.zsh):
#   rainbow  sets ~105 per-segment *_BACKGROUND vars, always including DIR's.
#   classic  sets exactly one shared POWERLEVEL9K_BACKGROUND, no per-segment.
#   lean/pure set neither — pure is indistinguishable from lean here, and
#            that's fine: neither one paints segment surfaces.
# GOTCHA: a lean config can set POWERLEVEL9K_BACKGROUND to an EMPTY string on
# purpose (transparent background — the maintainer's own dotfiles do this).
# Empty is not "set": always test for a NON-EMPTY value, never for the
# variable merely existing.
# ponytail: a hand-edited ~/.p10k.zsh that mixes markers (e.g. sets
# POWERLEVEL9K_DIR_BACKGROUND by hand while otherwise running lean) will
# mis-detect. Upgrade path: an explicit DF_P10K_THEMES_STYLE=lean|classic|
# rainbow override, checked before this heuristic — not implemented here.
if   [[ -n $POWERLEVEL9K_DIR_BACKGROUND ]]; then typeset -g _DF_P10K_STYLE=rainbow
elif [[ -n $POWERLEVEL9K_BACKGROUND ]];     then typeset -g _DF_P10K_STYLE=classic
else                                              typeset -g _DF_P10K_STYLE=lean
fi

#--- contrast helpers (WCAG 2.x relative luminance) --------------------------
# Only used in rainbow style, where each segment paints its own background
# and needs a foreground picked for contrast rather than for brand identity.
# Both functions return through $REPLY (zsh convention) instead of a
# subshell + command substitution, so shell startup never forks for this.
typeset -gA _DF_P10K_LUM_CACHE=()
typeset -gA _DF_P10K_ON_COLOR_CACHE=()

_df_p10k_luminance() {
  emulate -L zsh
  local hex=$1
  if [[ -n ${_DF_P10K_LUM_CACHE[$hex]:-} ]]; then
    REPLY=${_DF_P10K_LUM_CACHE[$hex]}
    return
  fi
  # A plain (non-extendedglob) character class repeated by hand, since
  # `emulate -L zsh` turns extendedglob off and (#c6)-style qualifiers with
  # it — a hand-rolled six-slot class is simpler than re-enabling it.
  if [[ $hex != '#'[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F] ]]; then
    REPLY=-1 # not a hex color — caller decides the fallback
    return
  fi
  local -F r=$(( (16#${hex[2,3]}) / 255.0 ))
  local -F g=$(( (16#${hex[4,5]}) / 255.0 ))
  local -F b=$(( (16#${hex[6,7]}) / 255.0 ))
  local -F lr=$(( r <= 0.03928 ? r/12.92 : ((r+0.055)/1.055)**2.4 ))
  local -F lg=$(( g <= 0.03928 ? g/12.92 : ((g+0.055)/1.055)**2.4 ))
  local -F lb=$(( b <= 0.03928 ? b/12.92 : ((b+0.055)/1.055)**2.4 ))
  REPLY=$(( 0.2126*lr + 0.7152*lg + 0.0722*lb ))
  _DF_P10K_LUM_CACHE[$hex]=$REPLY
}

# _df_p10k_on_color <hex-background>... — sets $REPLY to whichever of $c_base
# or $c_text has the higher WCAG contrast ratio against <hex-background>. Given
# several backgrounds (one text that renders on any of them, like
# my_git_formatter on the clean/modified/untracked pills) it picks by the
# worst case, so the same color stays readable on every one of them.
_df_p10k_on_color() {
  emulate -L zsh
  local key=$*
  if [[ -n ${_DF_P10K_ON_COLOR_CACHE[$key]:-} ]]; then
    REPLY=${_DF_P10K_ON_COLOR_CACHE[$key]}
    return
  fi
  local hex pick=$c_text
  local -F bg_lum text_lum base_lum r ratio_text=99 ratio_base=99
  _df_p10k_luminance $c_text; text_lum=$REPLY
  _df_p10k_luminance $c_base; base_lum=$REPLY
  for hex in "$@"; do
    _df_p10k_luminance $hex; bg_lum=$REPLY
    # A value that isn't #rrggbb keeps the c_text fallback. ponytail: every
    # shipped theme only ever hands this hex values, so falling back rather
    # than decoding an xterm-256 index is the whole handling this needs.
    (( bg_lum < 0 )) && { ratio_base=0; break; }
    r=$(( bg_lum > text_lum ? (bg_lum+0.05)/(text_lum+0.05) : (text_lum+0.05)/(bg_lum+0.05) ))
    (( r < ratio_text )) && ratio_text=$r
    r=$(( bg_lum > base_lum ? (bg_lum+0.05)/(base_lum+0.05) : (base_lum+0.05)/(bg_lum+0.05) ))
    (( r < ratio_base )) && ratio_base=$r
  done
  (( ratio_base > ratio_text )) && pick=$c_base
  _DF_P10K_ON_COLOR_CACHE[$key]=$pick
  REPLY=$pick
}

#--- os icon ----------------------------------------------------------------
# P10k picks the glyph from /etc/os-release (or uname) but always paints it
# with the stock foreground. Map the detected OS to the closest hue in the
# active palette so the icon keeps its vendor identity — Ubuntu orange,
# Android green, Debian red — while still belonging to the theme.
#
# Keys are /etc/os-release IDs. Compound IDs (opensuse-leap, manjaro-arm)
# fall back to the part before the first dash; anything unmapped uses the
# theme accent. Adding a distro is one entry here.
typeset -gA _DF_P10K_OS_COLOR=(
  ubuntu      $c_peach     debian      $c_red       raspbian    $c_pink
  arch        $c_sapphire  artix       $c_cyan      manjaro     $c_green
  endeavouros $c_mauve     garuda      $c_ruby      cachyos     $c_green
  fedora      $c_blue      rhel        $c_red       centos      $c_purple
  rocky       $c_green     almalinux   $c_blue      amzn        $c_peach
  opensuse    $c_green     sabayon     $c_subtext
  linuxmint   $c_green     elementary  $c_sky       zorin       $c_sky
  pop         $c_cyan      neon        $c_teal      mageia      $c_sapphire
  alpine      $c_blue      gentoo      $c_purple    slackware   $c_blue
  nixos       $c_sapphire  guix        $c_yellow    void        $c_green
  devuan      $c_purple    kali        $c_blue      coreos      $c_peach
  aosc        $c_red
  android     $c_green     macos       $c_subtext   windows     $c_sky
  freebsd     $c_red       solaris     $c_red
)

() {
  emulate -L zsh
  local id=''
  case $OSTYPE in
    darwin*)                              id=macos ;;
    freebsd*|openbsd*|netbsd*|dragonfly*) id=freebsd ;;
    solaris*)                             id=solaris ;;
    cygwin*|msys*|mingw*)                 id=windows ;;
    linux-android*)                       id=android ;;
    *)
      # _DF_P10K_OS_RELEASE exists so the tests can point at a fixture;
      # nothing but the test suite is expected to set it.
      local osrelease=${_DF_P10K_OS_RELEASE:-/etc/os-release}
      # -f as well as -r: reading a fifo or a character device here would
      # hang or never end, and this runs on every interactive shell.
      if [[ -f $osrelease && -r $osrelease ]]; then
        local -a ids=(${(M)${(f)"$(<$osrelease)"}:#ID=*})
        if (( $#ids == 1 )); then
          # os-release(5) restricts ID to [a-z0-9._-], so stripping blanks
          # is lossless — and it saves a CRLF file from resolving to a
          # lookalike id that carries a trailing \r and misses the map.
          id=${${(Q)${ids[1]#ID=}}//[[:space:]]/}
        fi
      elif [[ -e /etc/artix-release ]]; then
        id=artix
      fi
      ;;
  esac
  local hue=${_DF_P10K_OS_COLOR[$id]:-${_DF_P10K_OS_COLOR[${id%%-*}]:-$c_accent}}
  if [[ $_DF_P10K_STYLE == rainbow ]]; then
    typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=$hue
    _df_p10k_on_color $hue
    typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$REPLY
  else
    typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$hue
  fi
}

#--- prompt char --------------------------------------------------------------
# No style branch: stock p10k leaves PROMPT_CHAR_BACKGROUND unset/empty in
# lean, classic AND rainbow alike (it's rendered outside any segment), so a
# plain foreground is correct in every style.
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$c_ok
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$c_error

#--- directory ----------------------------------------------------------------
# Special-cased rather than folded into the table below: ANCHOR/SHORTENED are
# sub-parts of the DIR segment (they render inside DIR's own background, and
# have none of their own), so in rainbow they must share DIR's on-color
# rather than keep their lean/classic brand hue.
if [[ $_DF_P10K_STYLE == rainbow ]]; then
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=$c_accent
  _df_p10k_on_color $c_accent
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$REPLY
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$REPLY
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$REPLY
  # p10k never reads a DIR_ANCHOR/DIR_SHORTENED background (they're not
  # segments of their own) — these mirror DIR's so anything inspecting
  # "this foreground's background" (our own contrast tests included) finds
  # the surface they actually render on instead of guessing c_base.
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BACKGROUND=$c_accent
  typeset -g POWERLEVEL9K_DIR_SHORTENED_BACKGROUND=$c_accent
else
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$c_accent
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$c_subtext
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$c_sapphire
fi

#--- vcs visual identifier (segment-level colors live in the table below) ----
if [[ $_DF_P10K_STYLE != rainbow ]]; then
  # Stock p10k configs often hardcode this — override so the leading git icon
  # picks up the theme accent rather than a baked-in integer. Stock rainbow
  # leaves both of these unset too (p10k's own rainbow default already
  # handles them), so we mirror that instead of guessing an on-color for a
  # background that changes with repo state.
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=$c_accent
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=$c_muted
fi

#--- segment → hue map (brand identity) ---------------------------------------
# One table, one loop, emitted per style:
#   lean/pure  POWERLEVEL9K_<seg>_FOREGROUND = hue            (today's behavior)
#   classic    same foreground, plus one shared surface background below
#   rainbow    POWERLEVEL9K_<seg>_BACKGROUND = hue
#              POWERLEVEL9K_<seg>_FOREGROUND = on-color of hue
typeset -gA _DF_P10K_SEGMENT_HUE=(
  VCS_CLEAN                        $c_ok       VCS_MODIFIED               $c_warn
  VCS_UNTRACKED                    $c_sapphire
  STATUS_OK                        $c_ok       STATUS_OK_PIPE             $c_teal
  STATUS_ERROR                     $c_error    STATUS_ERROR_PIPE          $c_ruby
  STATUS_ERROR_SIGNAL              $c_mauve
  COMMAND_EXECUTION_TIME           $c_peach
  CONTEXT                          $c_yellow   CONTEXT_ROOT               $c_error
  BACKGROUND_JOBS                  $c_lavender
  BATTERY_LOW                      $c_error    BATTERY_DISCONNECTED       $c_peach
  LOAD_CRITICAL                    $c_error    LOAD_WARNING               $c_peach
  LOAD_NORMAL                      $c_green
  DISK_USAGE_CRITICAL              $c_error    DISK_USAGE_WARNING         $c_peach
  DISK_USAGE_NORMAL                $c_green
  RAM                              $c_pink     SWAP                       $c_mauve
  ASDF_NODEJS                      $c_green
  ASDF_GOLANG                      $c_sky      ASDF_PYTHON                $c_yellow
  ASDF_RUST                        $c_peach    ASDF_RUBY                  $c_ruby
  ASDF_JAVA                        $c_peach    ASDF_LUA                   $c_blue
  ASDF_PERL                        $c_pink     ASDF_PHP                   $c_mauve
  ASDF_HASKELL                     $c_lavender ASDF_ELIXIR                $c_purple
  ASDF_ERLANG                      $c_ruby     ASDF_FLUTTER               $c_sapphire
  ASDF_DOTNET_CORE                 $c_mauve    ASDF_JULIA                 $c_pink
  ASDF_POSTGRES                    $c_sapphire
  NODE_VERSION                     $c_green    NODENV                     $c_green
  NODEENV                          $c_green    NVM                        $c_green
  GO_VERSION                       $c_sky      GOENV                      $c_sky
  RUST_VERSION                     $c_peach
  RBENV                            $c_ruby     RVM                        $c_ruby
  PYENV                            $c_yellow   VIRTUALENV                 $c_green
  ANACONDA                         $c_teal
  JAVA_VERSION                     $c_peach    JENV                       $c_peach
  LUAENV                           $c_blue
  PERLBREW                         $c_pink     PLENV                      $c_pink
  PHPENV                           $c_mauve    PHP_VERSION                $c_mauve
  DOTNET_VERSION                   $c_mauve    HASKELL_STACK              $c_lavender
  LARAVEL_VERSION                  $c_red      FVM                        $c_sapphire
  SCALAENV                         $c_red      CPU_ARCH                   $c_yellow
  TERRAFORM_VERSION                $c_mauve    TERRAFORM_OTHER            $c_mauve
  PACKAGE                          $c_red
  AWS_DEFAULT                      $c_peach    AWS_EB_ENV                 $c_green
  AZURE_OTHER                      $c_sky      GCLOUD                     $c_sapphire
  GOOGLE_APP_CRED_DEFAULT          $c_sapphire KUBECONTEXT_DEFAULT        $c_sapphire
  CHEZMOI_SHELL                    $c_teal
  IP                                $c_sapphire
  VPN_IP                           $c_teal     NORDVPN                    $c_sapphire
  PROXY                            $c_lavender WIFI                       $c_sky
  NIX_SHELL                        $c_sapphire VIM_SHELL                  $c_green
  MIDNIGHT_COMMANDER                $c_yellow  RANGER                     $c_peach
  NNN                              $c_teal     LF                         $c_sky
  XPLR                             $c_sapphire YAZI                       $c_pink
  TOOLBOX                          $c_mauve
  TASKWARRIOR                      $c_blue     TIMEWARRIOR                $c_lavender
  TODO                             $c_yellow   DIRENV                     $c_peach
  PER_DIRECTORY_HISTORY_GLOBAL     $c_peach    PER_DIRECTORY_HISTORY_LOCAL $c_mauve
)

for _df_p10k_seg _df_p10k_hue in "${(@kv)_DF_P10K_SEGMENT_HUE}"; do
  if [[ $_DF_P10K_STYLE == rainbow ]]; then
    typeset -g "POWERLEVEL9K_${_df_p10k_seg}_BACKGROUND=$_df_p10k_hue"
    _df_p10k_on_color $_df_p10k_hue
    typeset -g "POWERLEVEL9K_${_df_p10k_seg}_FOREGROUND=$REPLY"
  else
    typeset -g "POWERLEVEL9K_${_df_p10k_seg}_FOREGROUND=$_df_p10k_hue"
  fi
done
unset _df_p10k_seg _df_p10k_hue
[[ $_DF_P10K_STYLE == classic ]] && typeset -g POWERLEVEL9K_BACKGROUND=$c_surface

#--- muted / de-emphasized segments -------------------------------------------
# RULER, MULTILINE_FIRST_PROMPT_GAP and VCS_LOADING are decorative or
# placeholder content, not "real" segments; TIME, the generic ASDF fallback
# and PUBLIC_IP are deliberately low-emphasis info. All of them stay a plain
# muted/subtext foreground in every style — in lean/classic that's identical
# to a normal table entry (classic's shared surface pill still applies, same
# as stock p10k's own segments that don't set a background of their own).
typeset -g POWERLEVEL9K_RULER_FOREGROUND=$c_muted
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=$c_muted
typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=$c_muted
typeset -g POWERLEVEL9K_TIME_FOREGROUND=$c_subtext
typeset -g POWERLEVEL9K_ASDF_FOREGROUND=$c_subtext
typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND=$c_subtext
if [[ $_DF_P10K_STYLE == rainbow ]]; then
  # Rainbow is different: it would otherwise paint each of these its own
  # background pill from the table below, and a muted/subtext tone is by
  # construction close in luminance to both c_base and c_text, so it often
  # can't reach 4.5:1 as a background against either on-color. Keeping them
  # transparent instead matches stock p10k's own MULTILINE_FIRST_PROMPT_GAP
  # (transparent even in ITS rainbow preset), and clears any pill a preset
  # already painted (stock rainbow does, for VCS_LOADING).
  typeset -g POWERLEVEL9K_RULER_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
  typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=
  typeset -g POWERLEVEL9K_ASDF_BACKGROUND=
  typeset -g POWERLEVEL9K_PUBLIC_IP_BACKGROUND=
fi

#--- accent override --------------------------------------------------------
set_accent() {
  local name="$1"
  local c=${THEME_PALETTE[$name]:-}
  [[ -z "$c" ]] && return 1
  if [[ $_DF_P10K_STYLE == rainbow ]]; then
    typeset -g POWERLEVEL9K_DIR_BACKGROUND=$c
    _df_p10k_on_color $c
    typeset -g POWERLEVEL9K_DIR_FOREGROUND=$REPLY
    typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$REPLY
    typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$REPLY
  else
    typeset -g POWERLEVEL9K_DIR_FOREGROUND=$c
    typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$c
    typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=$c
  fi
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$c
}

#--- vcs branch palette (consumed by my_git_formatter below) -----------------
# Branch icon, name, and each indicator get their own slot so the line reads
# as a small palette rather than two-color noise. In rainbow the "found"
# set renders on whichever VCS state pill p10k paints — VCS_CLEAN, VCS_MODIFIED
# or VCS_UNTRACKED, each its own hue from the table above — so it becomes one
# on-color that clears every one of those backgrounds instead of a brand hue.
# VCS_MUTED renders during the "still loading" state, which — like RULER and
# MULTILINE_FIRST_PROMPT_GAP above — never gets a background pill in any
# style, so it stays plain c_muted rather than an on-color of a background
# that was never actually painted.
if [[ $_DF_P10K_STYLE == rainbow ]]; then
  _df_p10k_on_color $POWERLEVEL9K_VCS_CLEAN_BACKGROUND \
    $POWERLEVEL9K_VCS_MODIFIED_BACKGROUND $POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND
  local _df_p10k_vcs_found=$REPLY
  typeset -g _DF_P10K_VCS_BRANCH_ICON=$_df_p10k_vcs_found
  typeset -g _DF_P10K_VCS_NAME=$_df_p10k_vcs_found
  typeset -g _DF_P10K_VCS_STAGED=$_df_p10k_vcs_found
  typeset -g _DF_P10K_VCS_UNSTAGED=$_df_p10k_vcs_found
  typeset -g _DF_P10K_VCS_UNTRACKED=$_df_p10k_vcs_found
  typeset -g _DF_P10K_VCS_CONFLICTED=$_df_p10k_vcs_found
  typeset -g _DF_P10K_VCS_AHEAD_BEHIND=$_df_p10k_vcs_found
  typeset -g _DF_P10K_VCS_STASH=$_df_p10k_vcs_found
  unset _df_p10k_vcs_found
else
  typeset -g _DF_P10K_VCS_BRANCH_ICON=$c_sapphire
  typeset -g _DF_P10K_VCS_NAME=$c_ok
  typeset -g _DF_P10K_VCS_STAGED=$c_ok
  typeset -g _DF_P10K_VCS_UNSTAGED=$c_warn
  typeset -g _DF_P10K_VCS_UNTRACKED=$c_sky
  typeset -g _DF_P10K_VCS_CONFLICTED=$c_error
  typeset -g _DF_P10K_VCS_AHEAD_BEHIND=$c_teal
  typeset -g _DF_P10K_VCS_STASH=$c_mauve
fi
typeset -g _DF_P10K_VCS_MUTED=$c_muted

#--- git formatter ----------------------------------------------------------
function my_git_formatter() {
  emulate -L zsh

  if [[ -n $P9K_CONTENT ]]; then
    typeset -g my_git_format=$P9K_CONTENT
    return
  fi

  # Stock p10k-rainbow.zsh calls my_git_formatter() with no argument (only
  # lean/classic pass 1/0), so a missing argument means "found", not "loading".
  if (( ${1:-1} )); then
    local       meta='%f'
    local       icon="%F{$_DF_P10K_VCS_BRANCH_ICON}"
    local       name="%F{$_DF_P10K_VCS_NAME}"
    local     staged="%F{$_DF_P10K_VCS_STAGED}"
    local   unstaged="%F{$_DF_P10K_VCS_UNSTAGED}"
    local  untracked="%F{$_DF_P10K_VCS_UNTRACKED}"
    local conflicted="%F{$_DF_P10K_VCS_CONFLICTED}"
    local      stash="%F{$_DF_P10K_VCS_STASH}"
    local      track="%F{$_DF_P10K_VCS_AHEAD_BEHIND}"
  else
    local       meta="%F{$_DF_P10K_VCS_MUTED}"
    local       icon="%F{$_DF_P10K_VCS_MUTED}"
    local       name="%F{$_DF_P10K_VCS_MUTED}"
    local     staged="%F{$_DF_P10K_VCS_MUTED}"
    local   unstaged="%F{$_DF_P10K_VCS_MUTED}"
    local  untracked="%F{$_DF_P10K_VCS_MUTED}"
    local conflicted="%F{$_DF_P10K_VCS_MUTED}"
    local      stash="%F{$_DF_P10K_VCS_MUTED}"
    local      track="%F{$_DF_P10K_VCS_MUTED}"
  fi

  local res
  if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
    local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
    (( $#branch > 32 )) && branch[13,-13]="…"
    res+="${icon}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${name}${branch//\%/%%}"
  fi
  if [[ -n $VCS_STATUS_TAG && -z $VCS_STATUS_LOCAL_BRANCH ]]; then
    local tag=${(V)VCS_STATUS_TAG}
    (( $#tag > 32 )) && tag[13,-13]="…"
    res+="${meta}#${name}${tag//\%/%%}"
  fi
  [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] && \
    res+="${meta}@${name}${VCS_STATUS_COMMIT[1,8]}"
  if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
    res+="${meta}:${name}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
  fi
  if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
    res+=" ${unstaged}wip"
  fi
  if (( VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND )); then
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${track}⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${track}⇡${VCS_STATUS_COMMITS_AHEAD}"
  fi
  (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${track}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
  (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
  (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${track}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
  (( VCS_STATUS_STASHES        )) && res+=" ${stash}*${VCS_STATUS_STASHES}"
  [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
  (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
  (( VCS_STATUS_NUM_STAGED     )) && res+=" ${staged}+${VCS_STATUS_NUM_STAGED}"
  (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${unstaged}!${VCS_STATUS_NUM_UNSTAGED}"
  (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}?${VCS_STATUS_NUM_UNTRACKED}"

  typeset -g my_git_format=$res
}

#--- repaint ----------------------------------------------------------------
(( $+functions[p10k] )) && p10k reload &>/dev/null || true
