#
# Catppuccin Latte (light) for df-p10k-themes
# https://github.com/catppuccin/catppuccin
#

typeset -gA THEME_PALETTE=(
  rosewater '#dc8a78'  flamingo '#dd7878'
  mauve     '#8839ef'  red      '#d20f39'  maroon   '#e64553'
  teal      '#179299'  blue     '#1e66f5'
  pink      '#e242b7' # adjusted from #ea76cb (2.34:1 on base) → 3.0:1
  peach     '#e75501' # adjusted from #fe640b (2.64:1 on base) → 3.0:1 (backs c_warn/c_peach)
  yellow    '#ba7618' # adjusted from #df8e1d (2.31:1 on base) → 3.0:1
  green     '#3d9729' # adjusted from #40a02b (2.96:1 on base) → 3.0:1 (backs c_ok/c_green)
  sky       '#038ec6' # adjusted from #04a5e5 (2.47:1 on base) → 3.0:1
  sapphire  '#1d92a6' # adjusted from #209fb5 (2.78:1 on base) → 3.0:1 (backs c_info/c_sapphire)
  lavender  '#6279fd' # adjusted from #7287fd (2.81:1 on base) → 3.0:1
  text      '#4c4f69'  subtext1 '#5c5f77'  subtext0 '#6c6f85'
  overlay2  '#7c7f93'  overlay1 '#8c8fa1'  overlay0 '#9ca0b0'
  surface2  '#acb0be'  surface1 '#bcc0cc'  surface0 '#ccd0da'
  base      '#eff1f5'  mantle   '#e6e9ef'  crust    '#dce0e8'
)

# Latte is LIGHT — muted/subtext are inverted so they stay visible on light bg.
THEME_ACCENTS=(blue mauve green peach red yellow teal sky sapphire lavender pink)
THEME_ACCENT_DEFAULT=blue

typeset -g c_accent=${THEME_PALETTE[blue]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[peach]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[sapphire]}
typeset -g c_muted=${THEME_PALETTE[overlay2]} # overlay1 vs c_surface only reached 2.63:1
typeset -g c_subtext=${THEME_PALETTE[subtext1]}

# Surface roles: Latte is LIGHT, so base is already the lightest step —
# mantle is the next lightest, distinct from base, giving classic-mode
# segments a surface that still reads as "this palette" rather than base
# itself with no visible separation from the terminal background.
typeset -g c_base=${THEME_PALETTE[base]}
typeset -g c_surface=${THEME_PALETTE[mantle]}
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
