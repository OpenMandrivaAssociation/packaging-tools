#!/bin/sh
sudo dnf --refresh --nogpgcheck builddep *.spec
exec abb build "$@"
