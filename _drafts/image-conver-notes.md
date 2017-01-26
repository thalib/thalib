ffmpeg -ss [start] -i in.mp4 -t [duration] -c copy out.mp4

ffmpeg  -i gear_pump.mp4 -r 5 ext_gear_pump.gif
ffmpeg  -i int_gear_pump.mp4 -r 5 int_gear_pump.gif
ffmpeg  -i van_pump.mp4 -r 3 van_pump.gif
ffmpeg  -i swash_plate_piston_pump.mp4 -r 1 swash_plate_piston_pump.gif


magick -delay 20 -loop 0 *.jpg gear_pump.gif
magick -layers Optimize gear_pump.gif gear_pump_small.gif


convert '*.jpeg[640x>]'  out/thumb-300-%03d.png
convert '*.jpeg[640x>]' -quality 75 -set filename:base "%[base]" out/"%[filename:base].png"
convert -border 15x15 -bordercolor "#FFffff" test.jpeg out/new.jpg

## This command scales image and addes water mark order + border
### Singe file
convert test.jpeg \
-resize "640x>"  \
-border 15x15 -bordercolor "#FFFFFF" \
-pointsize 18 \
-fill white  -undercolor '#00000080'  -gravity South \
-annotate +0+5 ' CraftJewels.in ' \
-quality 75 \
-set filename:base "%[base]" out/"%[filename:base].png"

### Multiple file
convert \
'*.jpeg[640x>]'  \
-border 15x15 -bordercolor "#FFFFFF" \
-pointsize 18 \
-fill white  -undercolor '#00000080'  -gravity South \
-annotate +0+5 '. CraftJewels.in ' \
-quality 75 \
-set filename:base "%[base]" ../"%[filename:base].png"