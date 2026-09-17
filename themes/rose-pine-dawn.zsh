#
# Rosé Pine Dawn (light) for df-p10k-themes
# https://rosepinetheme.com
#
# Dawn is LIGHT — subtle and muted sit between text and the background, so
# dimmed prompt segments fade toward base instead of away from it.
#

typeset -gA THEME_PALETTE=(
  love    '#b4637a'
  pine    '#286983'  foam    '#56949f'  iris    '#907aa9'
  text    '#575279'  subtle  '#797593'
  overlay '#f2e9e1'  surface '#fffaf3'  base    '#faf4ed'
  gold    '#c87c15' # adjusted from #ea9d34 (2.05:1 on base) → 3.0:1 (backs c_warn/c_yellow)
  rose    '#d2716d' # adjusted from #d7827e (2.60:1 on base) → 3.0:1 (backs c_ruby/c_pink)
  muted   '#908a9e' # adjusted from #9893a5 (2.73:1 on base) → 3.0:1
)

THEME_ACCENTS=(iris pine foam rose gold love)
THEME_ACCENT_DEFAULT=iris

typeset -g c_accent=${THEME_PALETTE[iris]}
typeset -g c_ok=${THEME_PALETTE[pine]}
typeset -g c_warn=${THEME_PALETTE[gold]}
typeset -g c_error=${THEME_PALETTE[love]}
typeset -g c_info=${THEME_PALETTE[foam]}
typeset -g c_muted=${THEME_PALETTE[muted]}
typeset -g c_subtext=${THEME_PALETTE[subtle]}

# Surface roles: Rosé Pine Dawn's own "surface" step is lighter than base,
# consistent with a light theme's surface — reuse it directly.
typeset -g c_base=${THEME_PALETTE[base]}
typeset -g c_surface=${THEME_PALETTE[surface]}
typeset -g c_text=${THEME_PALETTE[text]}

typeset -g c_red=${THEME_PALETTE[love]}
typeset -g c_ruby=${THEME_PALETTE[rose]}
typeset -g c_peach=${THEME_PALETTE[gold]}
typeset -g c_yellow=${THEME_PALETTE[gold]}
typeset -g c_green=${THEME_PALETTE[pine]}
typeset -g c_teal=${THEME_PALETTE[foam]}
typeset -g c_cyan=${THEME_PALETTE[foam]}
typeset -g c_sky=${THEME_PALETTE[foam]}
typeset -g c_sapphire=${THEME_PALETTE[pine]}
typeset -g c_blue=${THEME_PALETTE[pine]}
typeset -g c_lavender=${THEME_PALETTE[iris]}
typeset -g c_mauve=${THEME_PALETTE[iris]}
typeset -g c_purple=${THEME_PALETTE[iris]}
typeset -g c_pink=${THEME_PALETTE[rose]}
