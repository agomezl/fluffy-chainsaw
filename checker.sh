#!/bin/bash

#Variables
BASE_LIB=2015-2-lab1/src/
DIR=data/${1}
GHC_VERSION=$(ls .cabal-sandbox/ | grep x86_64)
DB=.cabal-sandbox/${GHC_VERSION}/

#Redirect STDIN to a file (Script wide)
exec > data/${1}/check.html

#HTML header
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

#The submitted file
echo "<pre>"
cat ${DIR}/SimAFA.hs
echo "</pre>"

cat <<EOF
      </div>
    </div>
    <div class="large-12 columns">
EOF

#Check for compilation errors
if ! (ghc ${DIR}/SimAFA.hs -i${BASE_LIB} > ${DIR}/ghc.log 2>&1)
then

#If errors were found, print them

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
#If no error were found run tests

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

#Interpret SimAFA.hs + AFA.hs + quick check tests + test main
runhaskell -i${BASE_LIB} \
           -i${DIR} \
           -package-db --ghc-arg=${DB} \
           test/Main.hs 2> ${DIR}/run.log

#Check if test fail for some weird reason
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

#Start clean code checks
cat <<EOF
    <div class="large-12 columns">
      <h3>Clean code</h3>
    </div>
    <div class="large-12 columns">
    <lu>
EOF

#80 columns check
if $(grep -q '.\{81,\}' ${DIR}/SimAFA.hs)
then
    echo "<li><p>Your file has more than 80 columns in some lines</p>"
     echo "<div class=\"panel\"><pre>"
    grep -n '.\{81,\}' ${DIR}/SimAFA.hs
    echo "</pre></div></li>"
fi

#Trailing white spaces check
if $(grep -q ' $' ${DIR}/SimAFA.hs)
then
    echo "<li> <p>Your file has trailing whitespace</p>"
    echo "<div class=\"panel\"><pre>"
    grep -n ' $' ${DIR}/SimAFA.hs
    echo "</pre></div></li>"

fi

#No tabs check
if $(grep -P -q '\t' ${DIR}/SimAFA.hs)
then
    echo "<li> <p>Your file has tabs</p>"
    echo "<div class=\"panel\"><pre>"
    grep -P -n '\t' ${DIR}/SimAFA.hs
    echo "</pre></div></li>"
fi

if ! $(grep -q 'accepts \+\(∷\|::\)' ${DIR}/SimAFA.hs)
then
    echo "<li> <p><tt>accepts</tt> lacks of a type signature.</p>"
fi

fi

cat <<EOF
      </lu>
      </div>
    </div>
  </body>
</html>
EOF
