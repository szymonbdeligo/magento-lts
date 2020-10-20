#!/usr/bin/env bash

set -e
trap '>&2 echo Error: Command \`$BASH_COMMAND\` on line $LINENO failed with exit code $?' ERR

echo
echo "Display configuration"
/sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :1 -screen 0 1280x1024x24
export DISPLAY=:1

echo
echo "Run selenium server"
cd ${GITHUB_WORKSPACE}
sh ./dev/tests/functional/vendor/se/selenium-server-standalone/bin/selenium-server-standalone -port 4444 -host 127.0.0.1 -Dwebdriver.firefox.bin=$(which firefox) -trustAllSSLCertificate &> ~/selenium.log &

sleep 10

echo
echo "Prepare PHPunits config file"
cd ${GITHUB_WORKSPACE}/dev/tests/functional/
cp phpunit.xml.dist phpunit.xml

sed -e "s?localhost?127.0.0.1?g" --in-place ./phpunit.xml

php -f utils/generate.php
#cd ./utils
#php -f mtf troubleshooting:check-all
cd ${GITHUB_WORKSPACE}

./dev/tests/functional/vendor/phpunit/phpunit/phpunit -c dev/tests/functional/phpunit.xml --bootstrap dev/tests/functional/bootstrap.php