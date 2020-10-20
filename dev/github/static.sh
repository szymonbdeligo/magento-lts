#!/usr/bin/env bash

cd ${GITHUB_WORKSPACE};
if [ true ]; then ! find . -not \( -path ./.phpstorm.meta.php -prune \) -not \( -path ./lib/PEAR -prune \) -not \( -path ./lib/phpseclib -prune \) -not \( -path ./lib/Zend -prune \) -type f -name "*.php" -exec php -d error_reporting=32767 -l {} \; 2>&1 >&- ; fi
if [ true ]; then ! find app/design -type f -name "*.phtml" -exec php -d error_reporting=32767 -l {} \; 2>&1 >&- ; fi