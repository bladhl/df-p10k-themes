#
# One Dark Pro for df-p10k-themes
# https://github.com/Binaryify/OneDark-Pro
#

typeset -gA THEME_PALETTE=(
  red     '#e06c75'  ruby    '#be5046'  orange '#d19a66'
  yellow  '#e5c07b'  green   '#98c379'  cyan   '#56b6c2'
  blue    '#61afef'  purple  '#c678dd'  pink   '#d19a9a'
  fg      '#abb2bf'  muted   '#5c6370'  bg     '#282c34'
)

THEME_ACCENTS=(blue purple cyan green orange yellow red pink)
THEME_ACCENT_DEFAULT=blue

typeset -g c_accent=${THEME_PALETTE[blue]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[orange]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[cyan]}
typeset -g c_muted=${THEME_PALETTE[muted]}
typeset -g c_subtext=${THEME_PALETTE[fg]}

typeset -g c_red=${THEME_PALETTE[red]}
typeset -g c_ruby=${THEME_PALETTE[ruby]}
typeset -g c_peach=${THEME_PALETTE[orange]}
typeset -g c_yellow=${THEME_PALETTE[yellow]}
typeset -g c_green=${THEME_PALETTE[green]}
typeset -g c_teal=${THEME_PALETTE[cyan]}
typeset -g c_cyan=${THEME_PALETTE[cyan]}
typeset -g c_sky=${THEME_PALETTE[cyan]}
typeset -g c_sapphire=${THEME_PALETTE[blue]}
typeset -g c_blue=${THEME_PALETTE[blue]}
typeset -g c_lavender=${THEME_PALETTE[fg]}
typeset -g c_mauve=${THEME_PALETTE[purple]}
typeset -g c_purple=${THEME_PALETTE[purple]}
typeset -g c_pink=${THEME_PALETTE[pink]}
