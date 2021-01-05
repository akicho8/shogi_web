#!/bin/sh
# mogrify -resize 1200x630! *.png
pngquant --skip-if-larger --speed 1 --ext .png --force *.png
