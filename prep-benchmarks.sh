#!/bin/sh

set -e

elm make --optimize --output bench.js src/Console.elm
elm make --optimize --output index.html src/Browser.elm
