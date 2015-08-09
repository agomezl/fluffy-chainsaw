#!/bin/bash

BASE_LIB=2015-2-lab1/src/
DIR=data/${1}
GHC_VERSION=$(ls .cabal-sandbox/ | grep x86_64)
DB=.cabal-sandbox/${GHC_VERSION}/

exec > data/${1}/check.html
cat <<EOF
<!doctype html>
<!--[if IE 9]><html class="lt-ie10" lang="en" > <![endif]-->
<html class="no-js" lang="en" data-useragent="Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0)">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CM0081 - Programing lab 1 - Checker</title>

    <link rel="stylesheet" href="css/foundation.css" />
    <script src="js/vendor/modernizr.js"></script>
    <script src="js/foundation/foundation.abide.js"></script>
  </head>
  <body>
    <!-- Nav Bar -->

    <div class="row">
      <div class="large-12 columns">
        <h1><a href="/">Programing Lab 1</a> <small>automatic checker</small></h1>
        <hr />
      </div>
    </div>
    <div class="row">
    <div class="large-12 columns">
      <h3> Code </h3>
    </div>
    <div class="large-12 columns">
     <div class="panel">
EOF

echo "<pre>"
cat data/${1}/SimAFA.hs
echo "</pre>"

cat <<EOF
      </div>
    </div>
    <div class="large-12 columns">
EOF

if ! (ghc ${DIR}/SimAFA.hs -i${BASE_LIB} > ${DIR}/ghc.log 2>&1)
then

cat <<EOF
      <h3> Compilation Error </h3>
    </div>
    <div class="large-12 columns">
      <div class="panel">
      <pre>
EOF

cat ${DIR}/ghc.log | sed "s|${DIR}||"
echo "</pre>"
echo "</div>"

else

cat <<EOF
      <h3 style="text-align:left;float:left;"> Tests
      <h5 style="text-align:right;float:right;">
         [<a href="https://github.com/afl-eafit/2015-2-lab1/blob/master/src/Data/Automata/AFA/Examples.hs">
         Source code
         </a>]
      </h5>
      </h3>
      <hr/>
    </div>
EOF

runhaskell -i${BASE_LIB} \
           -i${DIR} \
           -package-db --ghc-arg=${DB} \
           test/Main.hs 2> ${DIR}/run.log

if [ $? -ne 0 ]
then
    echo "<div class=\"large-12 columns\">"
    echo "<div class=\"panel\">"
    echo "<pre>"
    cat ${DIR}/run.log  | sed "s|${DIR}||"
    echo "</pre>"
    echo "</div>"
    echo "</div>"
fi

fi

cat <<EOF
    </div>
  </body>
</html>
EOF
