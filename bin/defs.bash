#!/bin/bash

function run {
    "$1"
}

function clean {
    rm -rf lib/ browser/;
    echo "rm -rf lib/ browser/"
    mkdir -p lib/ browser/;
    echo "mkdir -p lib/ browser/"
}

function build_js {
    coffee -c -o lib/ src/sortable_table.coffee;
    echo "coffee -c -o lib/ src/sortable_table.coffee"
}

function build_browser {
    browserify lib/sortable_table.js > browser/sortable_table.js;
    echo "browserify lib/sortable_table.js > browser/sortable_table.js"
}

function build_index {
    coffee -c -o . src/index.coffee;
    echo "coffee -c -o . src/index.coffee"
}
    
function build {
    clean;
    build_js;
    build_browser;
    build_index;
}
