#
# Nord for df-p10k-themes
# https://www.nordtheme.com
#

typeset -gA THEME_PALETTE=(
  polar    '#2e3440'  polar1   '#3b4252'  polar2  '#434c5e'  polar3 '#4c566a'
  snow     '#d8dee9'  snow1    '#e5e9f0'  snow2   '#eceff4'
  frost1   '#8fbcbb'  frost2   '#88c0d0'  frost3  '#81a1c1'  frost4 '#5e81ac'
  red      '#bf616a'  orange   '#d08770'  yellow  '#ebcb8b'
  green    '#a3be8c'  purple   '#b48ead'
)

THEME_ACCENTS=(frost1 frost2 frost3 frost4 green purple orange yellow red)
THEME_ACCENT_DEFAULT=frost2

typeset -g c_accent=${THEME_PALETTE[frost2]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[orange]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[frost1]}
typeset -g c_muted=${THEME_PALETTE[polar3]}
typeset -g c_subtext=${THEME_PALETTE[snow]}

typeset -g c_red=${THEME_PALETTE[red]}
typeset -g c_ruby=${THEME_PALETTE[red]}
typeset -g c_peach=${THEME_PALETTE[orange]}
typeset -g c_yellow=${THEME_PALETTE[yellow]}
typeset -g c_green=${THEME_PALETTE[green]}
typeset -g c_teal=${THEME_PALETTE[frost1]}
typeset -g c_cyan=${THEME_PALETTE[frost1]}
typeset -g c_sky=${THEME_PALETTE[frost2]}
typeset -g c_sapphire=${THEME_PALETTE[frost3]}
typeset -g c_blue=${THEME_PALETTE[frost4]}
typeset -g c_lavender=${THEME_PALETTE[snow1]}
typeset -g c_mauve=${THEME_PALETTE[purple]}
typeset -g c_purple=${THEME_PALETTE[purple]}
typeset -g c_pink=${THEME_PALETTE[purple]}
