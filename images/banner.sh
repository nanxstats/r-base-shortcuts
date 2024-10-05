# brew install imagemagick
# brew install --cask font-cascadia-code
magick -size 2048x734 \
  -define gradient:angle=330 \gradient:#03448c-#17ffc6 \
  -gravity center \
  -pointsize 105 \
  -font 'Cascadia-Code-SemiBold' \
  -fill white \
  -annotate +0-100 'r-base-shortcuts' \
  -pointsize 28 \
  -font 'Cascadia-Code-SemiBold' \
  -annotate +0+50 'Object Generation · Object Transformation · Vectorization' \
  -annotate +0+100 'List Operations · Conditional Logic · Argument Handling' \
  -annotate +0+150 'Side-Effect Management · Numerical Computations' \
  png:- | pngquant - --force --output images/banner.png
