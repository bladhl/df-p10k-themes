#
# Catppuccin Frappé for df-p10k-themes
# https://github.com/catppuccin/catppuccin
#

typeset -gA THEME_PALETTE=(
  rosewater '#f2d5cf'  flamingo '#eebebe'  pink     '#f4b8e4'
  mauve     '#ca9ee6'  red      '#e78284'  maroon   '#ea999c'
  peach     '#ef9f76'  yellow   '#e5c890'  green    '#a6d189'
  teal      '#81c8be'  sky      '#99d1db'  sapphire '#85c1dc'
  blue      '#8caaee'  lavender '#babbf1'
  text      '#c6d0f5'  subtext1 '#b5bfe2'  subtext0 '#a5adce'
  overlay2  '#949cbb'  overlay1 '#838ba7'  overlay0 '#737994'
  surface2  '#626880'  surface1 '#51576d'  surface0 '#414559'
  base      '#303446'  mantle   '#292c3c'  crust    '#232634'
)

THEME_ACCENTS=(mauve blue green peach red yellow teal sky sapphire lavender pink rosewater)
THEME_ACCENT_DEFAULT=mauve

typeset -g c_accent=${THEME_PALETTE[mauve]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[peach]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[sapphire]}
typeset -g c_muted=${THEME_PALETTE[overlay1]} # overlay0 vs c_base only reached 2.87:1
typeset -g c_subtext=${THEME_PALETTE[subtext0]}

# Surface roles: crust is the darkest neutral Catppuccin ships, giving
# classic-mode segments the most contrast against this dark palette's text.
typeset -g c_base=${THEME_PALETTE[base]}
typeset -g c_surface=${THEME_PALETTE[crust]}
typeset -g c_text=${THEME_PALETTE[text]}

typeset -g c_red=${THEME_PALETTE[red]}
typeset -g c_ruby=${THEME_PALETTE[maroon]}
typeset -g c_peach=${THEME_PALETTE[peach]}
typeset -g c_yellow=${THEME_PALETTE[yellow]}
typeset -g c_green=${THEME_PALETTE[green]}
typeset -g c_teal=${THEME_PALETTE[teal]}
typeset -g c_cyan=${THEME_PALETTE[teal]}
typeset -g c_sky=${THEME_PALETTE[sky]}
typeset -g c_sapphire=${THEME_PALETTE[sapphire]}
typeset -g c_blue=${THEME_PALETTE[blue]}
typeset -g c_lavender=${THEME_PALETTE[lavender]}
typeset -g c_mauve=${THEME_PALETTE[mauve]}
typeset -g c_purple=${THEME_PALETTE[mauve]}
typeset -g c_pink=${THEME_PALETTE[pink]}
