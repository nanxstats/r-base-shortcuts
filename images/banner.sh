# brew install imagemagick
# brew install --cask font-jetbrains-mono
magick -size 2048x734 \
  -define gradient:angle=330 \gradient:#0d0551-#ff3779 \
  -gravity center \
  -pointsize 105 \
  -font 'Jetbrains-Mono-Bold' \
  -fill white \
  -annotate +0-100 'r-base-shortcuts' \
  -pointsize 28 \
  -font 'Jetbrains-Mono-SemiBold' \
  -annotate +0+50 'Object Generation · Object Transformation · Vectorization' \
  -annotate +0+100 'List Operations · Conditional Logic · Argument Handling' \
  -annotate +0+150 'Side-Effect Management · Numerical Computations' \
  png:- | pngquant - --force --output banner.png