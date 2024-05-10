set -g reset (set_color normal)
set -g bold (set_color --bold)
set -g italics (set_color --italics)
set -g red (set_color red)
set -g green (set_color green)
set -g yellow (set_color yellow)
set -g blue (set_color blue)
set -g cyan (set_color cyan)
set -g magenta (set_color magenta)

function run
    printf '%sevaluating%s: ' $magenta $reset
    echo $argv | fish_indent --ansi
    eval $argv
end

function compile-tikz-to-svg -a document
    set -l outdir ./figures/out
    set -l output_pdf $outdir/(path change-extension pdf (path basename $document))
    set -l output_svg (path change-extension svg $output_pdf)

    run command tectonic -X compile $document --outdir $outdir
    run command pdf2svg $output_pdf $output_svg
end
