#!/bin/bash

for d in */ ; do
    x_min=-1
    x_max=0
    y_min=-1
    y_max=0
    
    if [ -d "$d"3D ]; then
        for img in "$d"3D/*.png ;  do
            output=`convert -trim -verbose "$img" tmp.png 2>&1 >/dev/null | sed -n '2p'`
            rm tmp.png
            echo $output
            x_offset=`echo $output | sed -r 's/.*=>[0-9]*x[0-9]*\s[0-9x]*\+([0-9]*)\+([0-9]*).*/\1/'`
            y_offset=`echo $output | sed -r 's/.*=>[0-9]*x[0-9]*\s[0-9x]*\+([0-9]*)\+([0-9]*).*/\2/'`
            w=`echo $output | sed -r 's/.*=>([0-9]*)x([0-9]*)\s.*/\1/'`
            h=`echo $output | sed -r 's/.*=>([0-9]*)x([0-9]*)\s.*/\2/'`

            x2=$((x_offset + w))
            y2=$((y_offset + h))
            
            if [ $x_min -eq -1 ]; then
                x_min=`identify -format '%w' $img`
                y_min=`identify -format '%h' $img`
            fi
            
            if [ "$x_offset" -lt "$x_min" ]; then
                x_min=$x_offset
            fi
            
            if [ "$y_offset" -lt "$y_min" ]; then
                y_min=$y_offset
            fi
            
            if [ "$x2" -gt "$x_max" ]; then
                x_max=$x2
            fi
            
            if [ "$y2" -gt "$y_max" ]; then
                y_max=$y2
            fi
            echo $d : $x_min $y_min $x_max $y_max
        done
        
        for img in "$d"3D/*.png ;  do
            echo "Converting " $img
            convert $img -crop $((x_max - x_min))x$((y_max - y_min))+$x_min+$y_min  $img
        done
    fi
done
