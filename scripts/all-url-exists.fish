#!/usr/bin/env nix-shell
#! nix-shell -i fish -p lychee poppler_utils

pdftotext main.pdf - | lychee -

lychee - <references.yaml
