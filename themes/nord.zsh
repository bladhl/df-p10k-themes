#
# Nord for df-p10k-themes
# https://www.nordtheme.com
#

typeset -gA THEME_PALETTE=(
  polar    '#2e3440'  polar1   '#3b4252'  polar2  '#434c5e'  polar3 '#4c566a'
  snow     '#d8dee9'  snow1    '#e5e9f0'  snow2   '#eceff4'
  frost1   '#8fbcbb'  frost2   '#88c0d0'  frost3  '#81a1c1'  frost4 '#5e81ac'
  red      '#bf616a'  orange   '#d08770'  yellow  '#ebcb8b'
  green    '#a3be8c'  purple   '#b48ead'
)

THEME_ACCENTS=(frost1 frost2 frost3 frost4 green purple orange yellow red)
THEME_ACCENT_DEFAULT=frost2

typeset -g c_accent=${THEME_PALETTE[frost2]}
typeset -g c_ok=${THEME_PALETTE[green]}
typeset -g c_warn=${THEME_PALETTE[orange]}
typeset -g c_error=${THEME_PALETTE[red]}
typeset -g c_info=${THEME_PALETTE[frost1]}
typeset -g c_muted=${THEME_PALETTE[snow]} # polar3 vs c_surface only reached 1.36:1; Nord's
                                           # Polar Night scale has nothing between it and Snow
                                           # Storm, so this reuses c_subtext's step.
typeset -g c_subtext=${THEME_PALETTE[snow]}

# Surface roles: polar1 (nord1, Nord's own "elevated component" background)
# only reached 2.46:1-2.50:1 for error/blue in classic — Nord has nothing
# darker than polar (nord0) to move to instead, so c_surface reuses c_base
# outright rather than a lighter, lower-contrast step.
typeset -g c_base=${THEME_PALETTE[polar]}
typeset -g c_surface=${THEME_PALETTE[polar]}
typeset -g c_text=${THEME_PALETTE[snow2]}

typeset -g c_red=${THEME_PALETTE[red]}
typeset -g c_ruby=${THEME_PALETTE[red]}
typeset -g c_peach=${THEME_PALETTE[orange]}
typeset -g c_yellow=${THEME_PALETTE[yellow]}
typeset -g c_green=${THEME_PALETTE[green]}
typeset -g c_teal=${THEME_PALETTE[frost1]}
typeset -g c_cyan=${THEME_PALETTE[frost1]}
typeset -g c_sky=${THEME_PALETTE[frost3]}     # swapped with sapphire: frost3 clears 3.0:1 but
                                               # not 4.5:1, and sky backs far fewer segments
                                               # than sapphire does.
typeset -g c_sapphire=${THEME_PALETTE[frost2]}
typeset -g c_blue=${THEME_PALETTE[frost4]}    # frost4 (2.50:1/3.10:1 on the old lighter
                                               # c_surface) clears 3.0:1 now that c_surface
                                               # reuses c_base; Nord has no other blue-ish
                                               # step left unclaimed regardless.
typeset -g c_lavender=${THEME_PALETTE[snow1]}
typeset -g c_mauve=${THEME_PALETTE[purple]}
typeset -g c_purple=${THEME_PALETTE[purple]}
typeset -g c_pink=${THEME_PALETTE[purple]}
