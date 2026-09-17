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
  orange  '#cb4b16'  red     '#dc322f'
  magenta '#d33682'  violet  '#6c71c4'  blue    '#268bd2'
  base03  '#002b36'  base02  '#073642'  base01  '#586e75'
  base00  '#657b83'  base0   '#839496'  base1   '#93a1a1'
  base2   '#eee8d5'  base3   '#fdf6e3'
  yellow  '#a77e00' # adjusted from #b58900 (2.98:1 on base) → 3.0:1
  green   '#7b8d00' # adjusted from #859900 (2.97:1 on base) → 3.0:1 (backs c_ok)
  cyan    '#26938b' # adjusted from #2aa198 (2.93:1 on base) → 3.0:1 (backs c_info/c_teal/c_sky)
)

THEME_ACCENTS=(blue cyan green yellow orange red magenta violet)
THEME_ACCENT_DEFAULT=blue

typeset -g c_accent=${THEME_PALETTE[blue]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[orange]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[cyan]}
typeset -g c_muted=${THEME_PALETTE[base01]} # base1 vs c_base only reached 2.48:1 — it's a
                                             # "light content" step, the wrong half of the
                                             # scale for light mode; base01 clears 3.0:1.
typeset -g c_subtext=${THEME_PALETTE[base00]}

# Surface roles: Solarized's own spec names base3 the background and base2
# its "background highlights" tone — exactly the classic-mode surface role,
# mirroring the dark variant's base03/base02 pairing.
typeset -g c_base=${THEME_PALETTE[base3]}
typeset -g c_surface=${THEME_PALETTE[base2]}
# base03 (dark mode's own background) doubles as light mode's highest-
# contrast text tone; kept distinct from c_subtext/c_muted (base00/base01)
# so the roles never collide under the same threshold.
typeset -g c_text=${THEME_PALETTE[base03]}

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
