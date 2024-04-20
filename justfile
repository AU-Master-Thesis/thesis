
default:
    @just --list

alias b := build
build:
    typst compile --input release=true main.typ

alias w := dev

dev:
    typst watch main.typ


alias c := check

check:
    ./pdfstat.fish main.pdf
    @echo ""
    ./all-typ-files-included.fish
