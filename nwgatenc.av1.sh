#!/bin/bash
# http://nwgat.ninja
#
clear

git=`git log --pretty=format:'%h' -n 1`

echo ""
echo "### nwgat.ninja simple aomedia av1 encoder ###"
echo ""
echo "File to encode (use tab to select)"

read -e file

echo "Number of Frames to skip (blank blank if none)"
read skip

echo "Number of frames to encode (leave blank if none)"
read limit

echo "Video bitrate (6000 = 6mbps)"
read vb

read -p "Do you want a uncompressed video, png frame, a png frame of source video file? (y/n)? " dump
if [ "$dump" = "y" ]; then
echo ""
./aomenc --skip=$skip --limit=$limit --best --target-bitrate=$vb -o $file.$vb.$git.webm $file
./aomdec $file.$vb.$git.webm -o $file.$vb.$git.y4m
ffmpeg -i $file.$vb.$git.y4m -f image2 -t 0.001 -vframes 1 $file.$vb.$git.webm.y4m.png
ffmpeg -i $file -f image2 -vf select="gte(n\, $skip)" -vframes 1 $file.src.png
else
echo ""
./aomenc --skip=$skip --limit=$limit --best --target-bitrate=$vb -o $file.$vb.$git.webm $file

fi
echo ""
