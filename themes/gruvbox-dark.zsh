#
# Gruvbox Dark for df-p10k-themes
# https://github.com/morhetz/gruvbox
#

typeset -gA THEME_PALETTE=(
  red     '#fb4934'  ruby    '#cc241d'  orange  '#fe8019'
  yellow  '#fabd2f'  green   '#b8bb26'  aqua    '#8ec07c'
  blue    '#83a598'  purple  '#d3869b'  pink    '#d65d0e'
  fg      '#ebdbb2'  fg_dim  '#bdae93'  gray    '#928374'
  bg      '#282828'  bg_hard '#1d2021'
)

THEME_ACCENTS=(orange yellow green aqua blue purple red pink)
THEME_ACCENT_DEFAULT=orange

typeset -g c_accent=${THEME_PALETTE[orange]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[yellow]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[blue]}
typeset -g c_muted=${THEME_PALETTE[gray]}
typeset -g c_subtext=${THEME_PALETTE[fg]}

# Surface roles: bg_hard is Gruvbox's own "hard contrast" background variant,
# darker than the normal bg — the natural pick for a classic-mode surface.
typeset -g c_base=${THEME_PALETTE[bg]}
typeset -g c_surface=${THEME_PALETTE[bg_hard]}
typeset -g c_text=${THEME_PALETTE[fg]}

typeset -g c_red=${THEME_PALETTE[red]}
typeset -g c_ruby=${THEME_PALETTE[red]} # ruby (neutral red) only reached 2.69:1/3.00:1;
                                         # red (bright) is Gruvbox's only better-contrast red.
typeset -g c_peach=${THEME_PALETTE[orange]}
typeset -g c_yellow=${THEME_PALETTE[yellow]}
typeset -g c_green=${THEME_PALETTE[green]}
typeset -g c_teal=${THEME_PALETTE[aqua]}
typeset -g c_cyan=${THEME_PALETTE[aqua]}
typeset -g c_sky=${THEME_PALETTE[aqua]}
typeset -g c_sapphire=${THEME_PALETTE[blue]}
typeset -g c_blue=${THEME_PALETTE[blue]}
typeset -g c_lavender=${THEME_PALETTE[fg_dim]}
typeset -g c_mauve=${THEME_PALETTE[purple]}
typeset -g c_purple=${THEME_PALETTE[purple]}
typeset -g c_pink=${THEME_PALETTE[purple]} # pink (#d65d0e, actually a burnt orange) only
                                            # reached 3.81:1/4.24:1; purple is Gruvbox's true
                                            # magenta-pink accent and clears 4.5:1.
