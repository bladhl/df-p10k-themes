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
  sumiInk3     '#1f1f28'
)

THEME_ACCENTS=(crystalBlue oniViolet springGreen carpYellow sakuraPink waveAqua2 surimiOrange waveRed springBlue)
THEME_ACCENT_DEFAULT=crystalBlue

typeset -g c_accent=${THEME_PALETTE[crystalBlue]}
typeset -g c_ok=${THEME_PALETTE[springGreen]}
typeset -g c_warn=${THEME_PALETTE[roninYellow]}
typeset -g c_error=${THEME_PALETTE[samuraiRed]}
typeset -g c_info=${THEME_PALETTE[springBlue]}
typeset -g c_muted=${THEME_PALETTE[fujiGray]}
typeset -g c_subtext=${THEME_PALETTE[oldWhite]}

typeset -g c_red=${THEME_PALETTE[peachRed]}
typeset -g c_ruby=${THEME_PALETTE[autumnRed]}
typeset -g c_peach=${THEME_PALETTE[surimiOrange]}
typeset -g c_yellow=${THEME_PALETTE[carpYellow]}
typeset -g c_green=${THEME_PALETTE[springGreen]}
typeset -g c_teal=${THEME_PALETTE[waveAqua2]}
typeset -g c_cyan=${THEME_PALETTE[waveAqua1]}
typeset -g c_sky=${THEME_PALETTE[springBlue]}
typeset -g c_sapphire=${THEME_PALETTE[dragonBlue]}
typeset -g c_blue=${THEME_PALETTE[crystalBlue]}
typeset -g c_lavender=${THEME_PALETTE[oniViolet]}
typeset -g c_mauve=${THEME_PALETTE[oniViolet]}
typeset -g c_purple=${THEME_PALETTE[oniViolet]}
typeset -g c_pink=${THEME_PALETTE[sakuraPink]}
