#
# Shared bindings consumed by every df-p10k-themes theme file.
#
# A theme file declares its palette + semantic roles (see _template.zsh) and
# then sources this file. The CLI concatenates theme + bindings into a single
# active.zsh so the dropin is self-contained at runtime.
#
# Expected role variables (set by the theme file BEFORE sourcing this):
#   semantic — $c_accent  $c_ok  $c_warn  $c_error  $c_info  $c_muted  $c_subtext
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
# like "#cba6f7" — p10k accepts both.
#
# Segments are mapped to colors based on tool brand identity (e.g. Node→green,
# Rust→peach, K8s→sapphire) so the prompt reads as a harmonious palette rather
# than a few colors repeated everywhere.
#

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
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=${_DF_P10K_OS_COLOR[$id]:-${_DF_P10K_OS_COLOR[${id%%-*}]:-$c_accent}}
}

#--- prompt char ------------------------------------------------------------
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$c_ok
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$c_error

#--- directory --------------------------------------------------------------
typeset -g POWERLEVEL9K_DIR_FOREGROUND=$c_accent
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$c_subtext
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$c_sapphire

#--- vcs (segment-level) ----------------------------------------------------
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$c_ok
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$c_warn
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$c_sapphire
typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=$c_muted
# Stock p10k configs often hardcode this — override so the leading git icon
# picks up the theme accent rather than a baked-in integer.
typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=$c_accent
typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=$c_muted

#--- status -----------------------------------------------------------------
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=$c_ok
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=$c_teal
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$c_error
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=$c_ruby
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=$c_mauve

#--- time / context / cmd-time ----------------------------------------------
typeset -g POWERLEVEL9K_TIME_FOREGROUND=$c_subtext
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=$c_yellow
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=$c_error
typeset -g POWERLEVEL9K_RULER_FOREGROUND=$c_muted
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=$c_muted

#--- background jobs / battery / load / disk / memory -----------------------
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$c_lavender
typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND=$c_error
typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=$c_error
typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=$c_green
typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND=$c_error
typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_DISK_USAGE_NORMAL_FOREGROUND=$c_green
typeset -g POWERLEVEL9K_RAM_FOREGROUND=$c_pink
typeset -g POWERLEVEL9K_SWAP_FOREGROUND=$c_mauve

#--- runtime / language version segments (by brand identity) ----------------
typeset -g POWERLEVEL9K_ASDF_FOREGROUND=$c_subtext
typeset -g POWERLEVEL9K_ASDF_NODEJS_FOREGROUND=$c_green
typeset -g POWERLEVEL9K_ASDF_GOLANG_FOREGROUND=$c_sky
typeset -g POWERLEVEL9K_ASDF_PYTHON_FOREGROUND=$c_yellow
typeset -g POWERLEVEL9K_ASDF_RUST_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_ASDF_RUBY_FOREGROUND=$c_ruby
typeset -g POWERLEVEL9K_ASDF_JAVA_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_ASDF_LUA_FOREGROUND=$c_blue
typeset -g POWERLEVEL9K_ASDF_PERL_FOREGROUND=$c_pink
typeset -g POWERLEVEL9K_ASDF_PHP_FOREGROUND=$c_mauve
typeset -g POWERLEVEL9K_ASDF_HASKELL_FOREGROUND=$c_lavender
typeset -g POWERLEVEL9K_ASDF_ELIXIR_FOREGROUND=$c_purple
typeset -g POWERLEVEL9K_ASDF_ERLANG_FOREGROUND=$c_ruby
typeset -g POWERLEVEL9K_ASDF_FLUTTER_FOREGROUND=$c_sapphire
typeset -g POWERLEVEL9K_ASDF_DOTNET_CORE_FOREGROUND=$c_mauve
typeset -g POWERLEVEL9K_ASDF_JULIA_FOREGROUND=$c_pink
typeset -g POWERLEVEL9K_ASDF_POSTGRES_FOREGROUND=$c_sapphire
typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=$c_green
typeset -g POWERLEVEL9K_NODENV_FOREGROUND=$c_green
typeset -g POWERLEVEL9K_NODEENV_FOREGROUND=$c_green
typeset -g POWERLEVEL9K_NVM_FOREGROUND=$c_green
typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=$c_sky
typeset -g POWERLEVEL9K_GOENV_FOREGROUND=$c_sky
typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_RBENV_FOREGROUND=$c_ruby
typeset -g POWERLEVEL9K_RVM_FOREGROUND=$c_ruby
typeset -g POWERLEVEL9K_PYENV_FOREGROUND=$c_yellow
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$c_green
typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=$c_teal
typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_JENV_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_LUAENV_FOREGROUND=$c_blue
typeset -g POWERLEVEL9K_PERLBREW_FOREGROUND=$c_pink
typeset -g POWERLEVEL9K_PLENV_FOREGROUND=$c_pink
typeset -g POWERLEVEL9K_PHPENV_FOREGROUND=$c_mauve
typeset -g POWERLEVEL9K_PHP_VERSION_FOREGROUND=$c_mauve
typeset -g POWERLEVEL9K_DOTNET_VERSION_FOREGROUND=$c_mauve
typeset -g POWERLEVEL9K_HASKELL_STACK_FOREGROUND=$c_lavender
typeset -g POWERLEVEL9K_LARAVEL_VERSION_FOREGROUND=$c_red
typeset -g POWERLEVEL9K_FVM_FOREGROUND=$c_sapphire
typeset -g POWERLEVEL9K_SCALAENV_FOREGROUND=$c_red
typeset -g POWERLEVEL9K_CPU_ARCH_FOREGROUND=$c_yellow
typeset -g POWERLEVEL9K_TERRAFORM_VERSION_FOREGROUND=$c_mauve
typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND=$c_mauve
typeset -g POWERLEVEL9K_PACKAGE_FOREGROUND=$c_red

#--- cloud / cluster contexts -----------------------------------------------
typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_AWS_EB_ENV_FOREGROUND=$c_green
typeset -g POWERLEVEL9K_AZURE_OTHER_FOREGROUND=$c_sky
typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND=$c_sapphire
typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_FOREGROUND=$c_sapphire
typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=$c_sapphire
typeset -g POWERLEVEL9K_CHEZMOI_SHELL_FOREGROUND=$c_teal

#--- network / vpn / ip -----------------------------------------------------
typeset -g POWERLEVEL9K_IP_FOREGROUND=$c_sapphire
typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND=$c_subtext
typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND=$c_teal
typeset -g POWERLEVEL9K_NORDVPN_FOREGROUND=$c_sapphire
typeset -g POWERLEVEL9K_PROXY_FOREGROUND=$c_lavender
typeset -g POWERLEVEL9K_WIFI_FOREGROUND=$c_sky

#--- shells / file managers -------------------------------------------------
typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND=$c_sapphire
typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND=$c_green
typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_FOREGROUND=$c_yellow
typeset -g POWERLEVEL9K_RANGER_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_NNN_FOREGROUND=$c_teal
typeset -g POWERLEVEL9K_LF_FOREGROUND=$c_sky
typeset -g POWERLEVEL9K_XPLR_FOREGROUND=$c_sapphire
typeset -g POWERLEVEL9K_YAZI_FOREGROUND=$c_pink
typeset -g POWERLEVEL9K_TOOLBOX_FOREGROUND=$c_mauve

#--- task / time tracking / history -----------------------------------------
typeset -g POWERLEVEL9K_TASKWARRIOR_FOREGROUND=$c_blue
typeset -g POWERLEVEL9K_TIMEWARRIOR_FOREGROUND=$c_lavender
typeset -g POWERLEVEL9K_TODO_FOREGROUND=$c_yellow
typeset -g POWERLEVEL9K_DIRENV_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_GLOBAL_FOREGROUND=$c_peach
typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_LOCAL_FOREGROUND=$c_mauve

#--- vcs branch palette (consumed by my_git_formatter below) -----------------
# Branch icon, name, and each indicator get their own slot so the line reads
# as a small palette rather than two-color noise.
typeset -g _DF_P10K_VCS_BRANCH_ICON=$c_sapphire
typeset -g _DF_P10K_VCS_NAME=$c_ok
typeset -g _DF_P10K_VCS_STAGED=$c_ok
typeset -g _DF_P10K_VCS_UNSTAGED=$c_warn
typeset -g _DF_P10K_VCS_UNTRACKED=$c_sky
typeset -g _DF_P10K_VCS_CONFLICTED=$c_error
typeset -g _DF_P10K_VCS_AHEAD_BEHIND=$c_teal
typeset -g _DF_P10K_VCS_STASH=$c_mauve
typeset -g _DF_P10K_VCS_MUTED=$c_muted

#--- accent override --------------------------------------------------------
set_accent() {
  local name="$1"
  local c=${THEME_PALETTE[$name]:-}
  [[ -z "$c" ]] && return 1
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$c
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$c
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$c
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=$c
}

#--- git formatter ----------------------------------------------------------
function my_git_formatter() {
  emulate -L zsh

  if [[ -n $P9K_CONTENT ]]; then
    typeset -g my_git_format=$P9K_CONTENT
    return
  fi

  if (( $1 )); then
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
