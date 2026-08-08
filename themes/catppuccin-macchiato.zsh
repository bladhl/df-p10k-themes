#
# Catppuccin Macchiato for df-p10k-themes
# https://github.com/catppuccin/catppuccin
#

typeset -gA THEME_PALETTE=(
  rosewater '#f4dbd6'  flamingo '#f0c6c6'  pink     '#f5bde6'
  mauve     '#c6a0f6'  red      '#ed8796'  maroon   '#ee99a0'
  peach     '#f5a97f'  yellow   '#eed49f'  green    '#a6da95'
  teal      '#8bd5ca'  sky      '#91d7e3'  sapphire '#7dc4e4'
  blue      '#8aadf4'  lavender '#b7bdf8'
  text      '#cad3f5'  subtext1 '#b8c0e0'  subtext0 '#a5adcb'
  overlay2  '#939ab7'  overlay1 '#8087a2'  overlay0 '#6e738d'
  surface2  '#5b6078'  surface1 '#494d64'  surface0 '#363a4f'
)

THEME_ACCENTS=(mauve blue green peach red yellow teal sky sapphire lavender pink rosewater)
THEME_ACCENT_DEFAULT=mauve

typeset -g c_accent=${THEME_PALETTE[mauve]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[peach]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[sapphire]}
typeset -g c_muted=${THEME_PALETTE[overlay0]}
typeset -g c_subtext=${THEME_PALETTE[subtext0]}

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
