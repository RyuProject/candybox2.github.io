#!/usr/bin/env bash
set -euo pipefail

mkdir -p code/gen

(
  cd pythonScripts
  python3 genAscii.py
  python3 genText.py
)

npx --yes --package typescript@1.7.5 -- \
  tsc ./libs/*.ts ./code/main/*.ts ./code/gen/*.ts ./code/arena/*/*.ts \
  --out ./candybox2_compiled.js \
  --target ES5

npx --yes terser ./candybox2_compiled.js \
  -o ./candybox2_minified.js \
  --compress \
  --mangle

rm -rf _site
mkdir _site

find . -mindepth 1 -maxdepth 1 \
  ! -name '.git' \
  ! -name '.github' \
  ! -name '_site' \
  ! -name 'candybox2_compiled.js' \
  ! -name 'candybox2_minified.js' \
  -exec cp -R -- {} _site/ \;

cat candybox2_sourceCodeLicense.txt candybox2_minified.js \
  > _site/candybox2.js

cat candybox2_sourceCodeLicense.txt candybox2_compiled.js \
  > _site/candybox2_uncompressed.js
