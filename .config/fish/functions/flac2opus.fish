function flac2opus
    function _convert
        find . -type f -iname '*.flac' | while read -l f
            set out (string replace -ri '\.flac$' '.opus' -- "$f")
            echo "Encoding: $f"
            opusenc --bitrate 160 "$f" "$out"
        end
    end

    function _verify
        set failures 0

        find . -type f -iname '*.flac' | while read -l f
            set out (string replace -ri '\.flac$' '.opus' -- "$f")

            if not test -f "$out"
                echo "Missing: $out"
                set failures (math $failures + 1)
                continue
            end

            if not opusinfo "$out" >/dev/null 2>&1
                echo "Invalid Opus: $out"
                set failures (math $failures + 1)
                continue
            end
        end

        if test $failures -eq 0
            echo "Verification passed."
            return 0
        else
            echo "$failures verification failure(s)."
            return 1
        end
    end

    function _delete
        _verify
        or return 1

        find . -type f -iname '*.flac' -delete
    end

    switch "$argv[1]"
        case convert
            _convert
        case verify
            _verify
        case delete
            _delete
        case '*'
            echo "Usage: flac2opus {convert|verify|delete}"
            return 1
    end

    functions -e _convert _verify _delete
end
