#!/usr/bin/env -S fish --no-config

rg --pcre2-unicode --glob '*.typ' '^#todo'
