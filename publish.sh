#/bin/bash

set -e

cd typeorm
npm install
npm run compile
npm run package
cd build/package/
npm publish --access public --tag rc
