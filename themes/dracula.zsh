#
# Dracula for df-p10k-themes
# https://draculatheme.com
#
# Dracula ships seven accents plus two hues from its official ANSI
# extension. It has no true
# blue — the spec maps ANSI blue onto purple — so the blue-ish hue roles
# resolve to purple and cyan rather than inventing a color.
#

typeset -gA THEME_PALETTE=(
  red       '#ff5555'  ruby     '#ff6e6e'  orange   '#ffb86c'
  yellow    '#f1fa8c'  green    '#50fa7b'  cyan     '#8be9fd'
  purple    '#bd93f9'  violet   '#d6acff'  pink     '#ff79c6'
  fg        '#f8f8f2'  comment  '#6272a4'  selection '#44475a'
  bg        '#282a36'  black    '#21222c'
)

THEME_ACCENTS=(purple pink cyan green orange yellow red violet)
THEME_ACCENT_DEFAULT=purple

typeset -g c_accent=${THEME_PALETTE[purple]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[orange]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[cyan]}
typeset -g c_muted=${THEME_PALETTE[comment]}
typeset -g c_subtext=${THEME_PALETTE[fg]}

# Surface roles: the official 8-color spec has nothing darker than bg, but
# Dracula's own ANSI extension does (its "black") — use that rather than
# reusing bg itself, so classic-mode segments stay visually distinct from
# the terminal background.
typeset -g c_base=${THEME_PALETTE[bg]}
typeset -g c_surface=${THEME_PALETTE[black]}
typeset -g c_text=${THEME_PALETTE[fg]}

typeset -g c_red=${THEME_PALETTE[red]}
typeset -g c_ruby=${THEME_PALETTE[ruby]}
typeset -g c_peach=${THEME_PALETTE[orange]}
typeset -g c_yellow=${THEME_PALETTE[yellow]}
typeset -g c_green=${THEME_PALETTE[green]}
typeset -g c_teal=${THEME_PALETTE[cyan]}
typeset -g c_cyan=${THEME_PALETTE[cyan]}
typeset -g c_sky=${THEME_PALETTE[cyan]}
typeset -g c_sapphire=${THEME_PALETTE[cyan]}
typeset -g c_blue=${THEME_PALETTE[purple]}
typeset -g c_lavender=${THEME_PALETTE[violet]}
typeset -g c_mauve=${THEME_PALETTE[purple]}
typeset -g c_purple=${THEME_PALETTE[violet]}
typeset -g c_pink=${THEME_PALETTE[pink]}
