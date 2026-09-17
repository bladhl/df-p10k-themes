#
# df-p10k-themes — theme template
#
# Copy to themes/<name>.zsh and replace the palette + role bindings.
# The CLI concatenates this file with themes/_bindings.zsh into the active
# dropin, so this file only declares palette, roles, and accent metadata —
# not the POWERLEVEL9K_* assignments or my_git_formatter.
#
# Contract every theme dropin must satisfy:
#   1. THEME_PALETTE — associative array of palette-name → color value.
#      Colors may be xterm-256 integers ("141") OR truecolor hex strings
#      ("#cba6f7"). Use hex for accurate palettes on modern terminals — and
#      hex is REQUIRED for c_base/c_surface/c_text (see #4b) since the WCAG
#      contrast math in _bindings.zsh only understands "#rrggbb".
#   2. THEME_ACCENTS — names usable as accent overrides (subset of palette keys).
#   3. THEME_ACCENT_DEFAULT — the primary accent if none given.
#   4. Semantic role globals:
#        c_accent  c_ok  c_warn  c_error  c_info  c_muted  c_subtext
#   4b. Surface role globals (used by classic/rainbow prompt styles):
#        c_base    — the palette's own page/terminal background.
#        c_surface — the shared segment background used in classic style.
#                    Pick whichever step gives text the BEST contrast: the
#                    darkest neutral on a dark theme, the lightest on a light
#                    one. It should differ from c_base where the palette has
#                    such a step (many palettes name this "crust"/"mantle"
#                    for dark, or a step lighter than the near-white
#                    background for light); reuse c_base only when the
#                    upstream palette genuinely has nothing else to offer.
#        c_text    — primary on-surface text color.
#   5. Palette hue globals (one per major hue family):
#        c_red  c_ruby  c_peach  c_yellow  c_green  c_teal  c_cyan
#        c_sky  c_sapphire  c_blue  c_lavender  c_mauve  c_purple  c_pink
#
# Themes with limited palettes can map several hue roles to the same
# underlying color; richer palettes assign distinct values to each.
#
# Filename = theme name shown by `df-p10k-themes list`. Files starting with
# `_` are skipped by `list` and treated as internal helpers.
#

#--- palette ----------------------------------------------------------------
typeset -gA THEME_PALETTE=(
  rosewater '#f5e0dc'  flamingo '#f2cdcd'  pink     '#f5c2e7'
  mauve     '#cba6f7'  red      '#f38ba8'  maroon   '#eba0ac'
  peach     '#fab387'  yellow   '#f9e2af'  green    '#a6e3a1'
  teal      '#94e2d5'  sky      '#89dceb'  sapphire '#74c7ec'
  blue      '#89b4fa'  lavender '#b4befe'
  text      '#cdd6f4'  subtext1 '#bac2de'  subtext0 '#a6adc8'
  overlay2  '#9399b2'  overlay1 '#7f849c'  overlay0 '#6c7086'
  base      '#1e1e2e'  mantle   '#181825'  crust    '#11111b'
)

#--- metadata ---------------------------------------------------------------
THEME_ACCENTS=(mauve blue green peach red yellow teal sky sapphire lavender pink rosewater)
THEME_ACCENT_DEFAULT=mauve

#--- semantic roles ---------------------------------------------------------
typeset -g c_accent=${THEME_PALETTE[mauve]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[peach]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[sapphire]}
typeset -g c_muted=${THEME_PALETTE[overlay0]}
typeset -g c_subtext=${THEME_PALETTE[subtext0]}

#--- surface roles -----------------------------------------------------------
typeset -g c_base=${THEME_PALETTE[base]}
typeset -g c_surface=${THEME_PALETTE[crust]}
typeset -g c_text=${THEME_PALETTE[text]}

#--- palette hue roles ------------------------------------------------------
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
