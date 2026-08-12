#
# Rosé Pine for df-p10k-themes
# https://rosepinetheme.com
#
# Rosé Pine is a deliberately small six-accent palette with no true green.
# Several hue roles therefore collapse onto foam and pine — that is the
# palette being itself, not a gap in the mapping.
#

typeset -gA THEME_PALETTE=(
  love    '#eb6f92'  gold    '#f6c177'  rose    '#ebbcba'
  pine    '#31748f'  foam    '#9ccfd8'  iris    '#c4a7e7'
  text    '#e0def4'  subtle  '#908caa'  muted   '#6e6a86'
  overlay '#26233a'  surface '#1f1d2e'  base    '#191724'
)

THEME_ACCENTS=(iris foam rose gold pine love)
THEME_ACCENT_DEFAULT=iris

typeset -g c_accent=${THEME_PALETTE[iris]}
typeset -g c_ok=${THEME_PALETTE[foam]}
typeset -g c_warn=${THEME_PALETTE[gold]}
typeset -g c_error=${THEME_PALETTE[love]}
typeset -g c_info=${THEME_PALETTE[foam]}
typeset -g c_muted=${THEME_PALETTE[muted]}
typeset -g c_subtext=${THEME_PALETTE[subtle]}

typeset -g c_red=${THEME_PALETTE[love]}
typeset -g c_ruby=${THEME_PALETTE[rose]}
typeset -g c_peach=${THEME_PALETTE[gold]}
typeset -g c_yellow=${THEME_PALETTE[gold]}
typeset -g c_green=${THEME_PALETTE[foam]}
typeset -g c_teal=${THEME_PALETTE[pine]}
typeset -g c_cyan=${THEME_PALETTE[foam]}
typeset -g c_sky=${THEME_PALETTE[foam]}
typeset -g c_sapphire=${THEME_PALETTE[pine]}
typeset -g c_blue=${THEME_PALETTE[pine]}
typeset -g c_lavender=${THEME_PALETTE[iris]}
typeset -g c_mauve=${THEME_PALETTE[iris]}
typeset -g c_purple=${THEME_PALETTE[iris]}
typeset -g c_pink=${THEME_PALETTE[rose]}
