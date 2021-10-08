#!/bin/bash

input="input-video.mp4"
output="app.gif"
name="palette.png"

filters="fps=15,scale=300:-1:flags=lanczos"
ffmpeg -v verbose -i $input -vf palettegen $name
ffmpeg -v verbose -i $input -vf "$filters,palettegen" -y $name
ffmpeg -v verbose -i $input -i $name -lavfi "$filters [x]; [x][1:v] paletteuse" -y $output

rm $name
