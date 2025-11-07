function png2jpg --description 'Convert PNG files to JPG at 90% quality'
    for f in $argv
        set out (string replace -r '\.png$' '.jpg' $f)
        magick "$f" -quality 90 "$out"
    end
end
