#
# Catppuccin Latte (light) for df-p10k-themes
# https://github.com/catppuccin/catppuccin
#

typeset -gA THEME_PALETTE=(
  rosewater '#dc8a78'  flamingo '#dd7878'  pink     '#ea76cb'
  mauve     '#8839ef'  red      '#d20f39'  maroon   '#e64553'
  peach     '#fe640b'  yellow   '#df8e1d'  green    '#40a02b'
  teal      '#179299'  sky      '#04a5e5'  sapphire '#209fb5'
  blue      '#1e66f5'  lavender '#7287fd'
  text      '#4c4f69'  subtext1 '#5c5f77'  subtext0 '#6c6f85'
  overlay2  '#7c7f93'  overlay1 '#8c8fa1'  overlay0 '#9ca0b0'
  surface2  '#acb0be'  surface1 '#bcc0cc'  surface0 '#ccd0da'
)

# Latte is LIGHT — muted/subtext are inverted so they stay visible on light bg.
THEME_ACCENTS=(blue mauve green peach red yellow teal sky sapphire lavender pink)
THEME_ACCENT_DEFAULT=blue

typeset -g c_accent=${THEME_PALETTE[blue]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[peach]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[sapphire]}
typeset -g c_muted=${THEME_PALETTE[overlay1]}
typeset -g c_subtext=${THEME_PALETTE[subtext1]}

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
