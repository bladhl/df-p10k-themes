#
# Solarized Dark for df-p10k-themes
# https://ethanschoonover.com/solarized
#
# Solarized's eight accents are fixed and shared with the light variant;
# only the base tones flip. See themes/solarized-light.zsh.
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
typeset -g c_warn=${THEME_PALETTE[yellow]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[cyan]}
typeset -g c_muted=${THEME_PALETTE[base0]} # base01 vs c_surface only reached 2.42:1;
                                            # base0 (Solarized's dark-mode body text step,
                                            # already c_subtext's value) clears 3.0:1.
typeset -g c_subtext=${THEME_PALETTE[base0]}

# Surface roles: Solarized's own spec names base02 the "background
# highlights" tone, but it only reached 2.81:1-2.97:1 for several accents in
# classic — base02 is lighter than base03, and Solarized has nothing darker
# to move to, so c_surface reuses c_base outright.
typeset -g c_base=${THEME_PALETTE[base03]}
typeset -g c_surface=${THEME_PALETTE[base03]}
# base3 (light mode's own background) doubles as dark mode's highest-
# contrast text tone; kept distinct from c_muted/c_subtext (both base0) so
# the two roles never collide under the same threshold.
typeset -g c_text=${THEME_PALETTE[base3]}

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
