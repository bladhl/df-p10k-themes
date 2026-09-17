#
# Kanagawa (Wave) for df-p10k-themes
# https://github.com/rebelot/kanagawa.nvim
#

typeset -gA THEME_PALETTE=(
  autumnRed    '#c34043'  samuraiRed  '#e82424'  waveRed      '#e46876'
  peachRed     '#ff5d62'  surimiOrange '#ffa066' roninYellow  '#ff9e3b'
  carpYellow   '#e6c384'  boatYellow  '#c0a36e'  autumnYellow '#dca561'
  springGreen  '#98bb6c'  autumnGreen '#76946a'  waveAqua1    '#6a9589'
  waveAqua2    '#7aa89f'  springBlue  '#7fb4ca'  crystalBlue  '#7e9cd8'
  dragonBlue   '#658594'  oniViolet   '#957fb8'  sakuraPink   '#d27e99'
  fujiWhite    '#dcd7ba'  oldWhite    '#c8c093'  fujiGray     '#727169'
  sumiInk3     '#1f1f28'  sumiInk0    '#16161d'
)

THEME_ACCENTS=(crystalBlue oniViolet springGreen carpYellow sakuraPink waveAqua2 surimiOrange waveRed springBlue)
THEME_ACCENT_DEFAULT=crystalBlue

typeset -g c_accent=${THEME_PALETTE[crystalBlue]}
typeset -g c_ok=${THEME_PALETTE[springGreen]}
typeset -g c_warn=${THEME_PALETTE[roninYellow]}
typeset -g c_error=${THEME_PALETTE[waveRed]} # samuraiRed only reached 3.66:1/4.04:1;
                                              # waveRed is Kanagawa's best-contrast red left.
typeset -g c_info=${THEME_PALETTE[springBlue]}
typeset -g c_muted=${THEME_PALETTE[fujiGray]}
typeset -g c_subtext=${THEME_PALETTE[oldWhite]}

# Surface roles: sumiInk0 is the darkest of Kanagawa's own "sumi ink" steps,
# darker than the Wave editor background (sumiInk3) used as c_base here.
typeset -g c_base=${THEME_PALETTE[sumiInk3]}
typeset -g c_surface=${THEME_PALETTE[sumiInk0]}
typeset -g c_text=${THEME_PALETTE[fujiWhite]}

typeset -g c_red=${THEME_PALETTE[peachRed]}
typeset -g c_ruby=${THEME_PALETTE[samuraiRed]} # autumnRed only reached 3.22:1/3.54:1;
                                                # samuraiRed (freed from c_error above)
                                                # clears 3.0:1 at 3.66:1/4.04:1.
typeset -g c_peach=${THEME_PALETTE[surimiOrange]}
typeset -g c_yellow=${THEME_PALETTE[carpYellow]}
typeset -g c_green=${THEME_PALETTE[springGreen]}
typeset -g c_teal=${THEME_PALETTE[waveAqua2]}
typeset -g c_cyan=${THEME_PALETTE[dragonBlue]} # swapped with sapphire below: dragonBlue
                                                # clears 3.0:1 (4.15:1/4.57:1) but not 4.5:1,
                                                # and cyan backs almost no segments here.
typeset -g c_sky=${THEME_PALETTE[springBlue]}
typeset -g c_sapphire=${THEME_PALETTE[waveAqua1]} # dragonBlue only reached 4.15:1 in lean;
                                                   # waveAqua1 clears 4.5:1 both ways.
typeset -g c_blue=${THEME_PALETTE[crystalBlue]}
typeset -g c_lavender=${THEME_PALETTE[oniViolet]}
typeset -g c_mauve=${THEME_PALETTE[oniViolet]}
typeset -g c_purple=${THEME_PALETTE[oniViolet]}
typeset -g c_pink=${THEME_PALETTE[sakuraPink]}
