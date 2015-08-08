#!/bin/bash

#Foundation
wget http://foundation.zurb.com/cdn/releases/foundation-5.1.1.zip
unzip -d public/ foundation-5.1.1.zip
rm -f foundation-5.1.1.zip public/index.html

#Programming lab 1 repo
git clone https://github.com/afl-eafit/2015-2-lab1.git

#Build
cabal sandbox init
cabal install --dependencies-only
cabal install quickcheck
cabal build
