#!/bin/bash

function run {
    "$1"
}

function clean {
    rm -rf lib/ browser/;
<<<<<<< HEAD
    mkdir -p lib/ browser/;
=======
    echo "rm -rf lib/ browser/"
    mkdir -p lib/ browser/;
    echo "mkdir -p lib/ browser/"
>>>>>>> develop
}

function build_js {
    coffee -c -o lib/ src/sortable_table.coffee;
<<<<<<< HEAD
=======
    echo "coffee -c -o lib/ src/sortable_table.coffee"
>>>>>>> develop
}

function build_browser {
    browserify lib/sortable_table.js > browser/sortable_table.js;
<<<<<<< HEAD
=======
    echo "browserify lib/sortable_table.js > browser/sortable_table.js"
>>>>>>> develop
}

function build_index {
    coffee -c -o . src/index.coffee;
<<<<<<< HEAD
=======
    echo "coffee -c -o . src/index.coffee"
>>>>>>> develop
}
    
function build {
    clean;
    build_js;
    build_browser;
    build_index;
}
