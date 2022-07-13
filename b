#!/bin/sh
sudo dnf --refresh --nogpgcheck builddep -D "_sourcedir $(pwd)" *.spec
exec abb build "$@"
