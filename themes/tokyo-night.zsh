#
# Tokyo Night for df-p10k-themes
# https://github.com/enkia/tokyo-night-vscode-theme
#

typeset -gA THEME_PALETTE=(
  red     '#f7768e'  orange  '#ff9e64'  yellow  '#e0af68'
  green   '#9ece6a'  teal    '#73dacb'  cyan    '#7dcfff'
  blue    '#7aa2f7'  magenta '#bb9af7'  purple  '#9d7cd8'
  fg      '#c0caf5'  fg_dark '#a9b1d6'  comment '#565f89'
  ice     '#b4f9f8'  turquoise '#2ac3de'
  bg      '#1a1b26'  bg_dark '#16161e'
)

THEME_ACCENTS=(blue magenta purple cyan teal green orange yellow red)
THEME_ACCENT_DEFAULT=blue

typeset -g c_accent=${THEME_PALETTE[blue]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[orange]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[cyan]}
typeset -g c_muted=${THEME_PALETTE[comment]}
typeset -g c_subtext=${THEME_PALETTE[fg_dark]}

typeset -g c_red=${THEME_PALETTE[red]}
typeset -g c_ruby=${THEME_PALETTE[red]}
typeset -g c_peach=${THEME_PALETTE[orange]}
typeset -g c_yellow=${THEME_PALETTE[yellow]}
typeset -g c_green=${THEME_PALETTE[green]}
typeset -g c_teal=${THEME_PALETTE[teal]}
typeset -g c_cyan=${THEME_PALETTE[turquoise]}
typeset -g c_sky=${THEME_PALETTE[cyan]}
typeset -g c_sapphire=${THEME_PALETTE[blue]}
typeset -g c_blue=${THEME_PALETTE[blue]}
typeset -g c_lavender=${THEME_PALETTE[ice]}
typeset -g c_mauve=${THEME_PALETTE[magenta]}
typeset -g c_purple=${THEME_PALETTE[purple]}
typeset -g c_pink=${THEME_PALETTE[magenta]}
