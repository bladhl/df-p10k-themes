#
# Solarized Light for df-p10k-themes
# https://ethanschoonover.com/solarized
#
# Same eight accents as Solarized Dark; only the base tones invert. Light
# variant, so muted sits closest to the pale background and subtext steps
# further toward the dark end for contrast — the dark theme's pairing,
# mirrored.
#

typeset -gA THEME_PALETTE=(
  yellow  '#b58900'  orange  '#cb4b16'  red     '#dc322f'
  magenta '#d33682'  violet  '#6c71c4'  blue    '#268bd2'
  cyan    '#2aa198'  green   '#859900'
  base03  '#002b36'  base02  '#073642'  base01  '#586e75'
  base00  '#657b83'  base0   '#839496'  base1   '#93a1a1'
  base2   '#eee8d5'  base3   '#fdf6e3'
)

THEME_ACCENTS=(blue cyan green yellow orange red magenta violet)
THEME_ACCENT_DEFAULT=blue

typeset -g c_accent=${THEME_PALETTE[blue]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[orange]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[cyan]}
typeset -g c_muted=${THEME_PALETTE[base1]}
typeset -g c_subtext=${THEME_PALETTE[base00]}

typeset -g c_red=${THEME_PALETTE[red]}
typeset -g c_ruby=${THEME_PALETTE[orange]}
typeset -g c_peach=${THEME_PALETTE[orange]}
typeset -g c_yellow=${THEME_PALETTE[yellow]}
typeset -g c_green=${THEME_PALETTE[green]}
typeset -g c_teal=${THEME_PALETTE[cyan]}
typeset -g c_cyan=${THEME_PALETTE[cyan]}
typeset -g c_sky=${THEME_PALETTE[cyan]}
typeset -g c_sapphire=${THEME_PALETTE[blue]}
typeset -g c_blue=${THEME_PALETTE[blue]}
typeset -g c_lavender=${THEME_PALETTE[violet]}
typeset -g c_mauve=${THEME_PALETTE[violet]}
typeset -g c_purple=${THEME_PALETTE[violet]}
typeset -g c_pink=${THEME_PALETTE[magenta]}
