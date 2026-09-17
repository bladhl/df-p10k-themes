#
# Catppuccin Mocha for df-p10k-themes
# https://github.com/catppuccin/catppuccin
#

typeset -gA THEME_PALETTE=(
  rosewater '#f5e0dc'  flamingo '#f2cdcd'  pink     '#f5c2e7'
  mauve     '#cba6f7'  red      '#f38ba8'  maroon   '#eba0ac'
  peach     '#fab387'  yellow   '#f9e2af'  green    '#a6e3a1'
  teal      '#94e2d5'  sky      '#89dceb'  sapphire '#74c7ec'
  blue      '#89b4fa'  lavender '#b4befe'
  text      '#cdd6f4'  subtext1 '#bac2de'  subtext0 '#a6adc8'
  overlay2  '#9399b2'  overlay1 '#7f849c'  overlay0 '#6c7086'
  surface2  '#585b70'  surface1 '#45475a'  surface0 '#313244'
  base      '#1e1e2e'  mantle   '#181825'  crust    '#11111b'
)

THEME_ACCENTS=(mauve blue green peach red yellow teal sky sapphire lavender pink rosewater)
THEME_ACCENT_DEFAULT=mauve

# Semantic roles
typeset -g c_accent=${THEME_PALETTE[mauve]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[peach]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[sapphire]}
typeset -g c_muted=${THEME_PALETTE[overlay0]}
typeset -g c_subtext=${THEME_PALETTE[subtext0]}

# Surface roles: crust is the darkest neutral Catppuccin ships, giving
# classic-mode segments the most contrast against this dark palette's text.
typeset -g c_base=${THEME_PALETTE[base]}
typeset -g c_surface=${THEME_PALETTE[crust]}
typeset -g c_text=${THEME_PALETTE[text]}

# Palette hues — each maps to a distinct color so segments don't all collapse
# into the same handful of values.
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
