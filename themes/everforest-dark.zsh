#
# Everforest Dark (medium) for df-p10k-themes
# https://github.com/sainnhe/everforest
#

typeset -gA THEME_PALETTE=(
  red     '#e67e80'  orange  '#e69875'  yellow  '#dbbc7f'
  green   '#a7c080'  aqua    '#83c092'  blue    '#7fbbb3'
  purple  '#d699b6'
  fg      '#d3c6aa'  grey2   '#9da9a0'  grey1   '#859289'
  grey0   '#7a8478'  bg0     '#2d353b'
)

THEME_ACCENTS=(green aqua blue yellow orange purple red)
THEME_ACCENT_DEFAULT=green

typeset -g c_accent=${THEME_PALETTE[green]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[yellow]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[blue]}
typeset -g c_muted=${THEME_PALETTE[grey0]}
typeset -g c_subtext=${THEME_PALETTE[grey2]}

typeset -g c_red=${THEME_PALETTE[red]}
typeset -g c_ruby=${THEME_PALETTE[orange]}
typeset -g c_peach=${THEME_PALETTE[orange]}
typeset -g c_yellow=${THEME_PALETTE[yellow]}
typeset -g c_green=${THEME_PALETTE[green]}
typeset -g c_teal=${THEME_PALETTE[aqua]}
typeset -g c_cyan=${THEME_PALETTE[aqua]}
typeset -g c_sky=${THEME_PALETTE[blue]}
typeset -g c_sapphire=${THEME_PALETTE[blue]}
typeset -g c_blue=${THEME_PALETTE[blue]}
typeset -g c_lavender=${THEME_PALETTE[purple]}
typeset -g c_mauve=${THEME_PALETTE[purple]}
typeset -g c_purple=${THEME_PALETTE[purple]}
typeset -g c_pink=${THEME_PALETTE[purple]}
