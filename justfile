set shell := ["fish", "--no-config", "-c"]
# theme := "latte"
# theme := "frappe"
theme := "macchiato"
# theme := "mocha"

default:
    @just --list

alias b := build
build:
    typst compile --input release=true --input catppuccin={{theme}} main.typ

alias w := dev
dev:
    test -f main.pdf; and xdg-open main.pdf >&2 >/dev/null &; disown
    typst watch --input catppuccin={{theme}} main.typ

alias p := pdf
pdf:
    sumatraPDF.exe main.pdf > /dev/null 2>&1 & disown

alias c := check
check:
    ./pdfstat.fish main.pdf
    @echo ""
    ./all-typ-files-included.fish
