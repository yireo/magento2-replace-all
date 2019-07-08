#!/bin/bash

magentoVersion=$1
if [ -z "$magentoVersion" ]; then
    magentoVersion=@dev
fi

core=yireo/magento2-replace-core
bundled=yireo/magento2-replace-bundled
graphql=yireo/magento2-replace-graphql
inventory=yireo/magento2-replace-inventory

function reconfigureMagento() {
    composer clear-cache
    redis-cli flushall
    rm -rf generated/
    bin/magento setup:di:compile || exit
    bin/magento deploy:mode:set developer
}

function addPackages() {
    echo "Adding packages $*"
    packages=$@
    for package in $packages; do
        composer require --no-update $package:$magentoVersion || exit
    done
    composer install || exit
}

function removePackages() {
    echo "Removing packages $*"
    packages=$*
    composer remove --no-update $packages
}

#addPackages $core; reconfigureMagento(); removePackages $core
#addPackages $bundled; reconfigureMagento(); removePackages $bundled
#addPackages $graphql; reconfigureMagento(); removePackages $graphql
#addPackages $inventory; reconfigureMagento(); removePackages $inventory

addPackages $core $bundled; reconfigureMagento; removePackages $core $bundled
addPackages $core $graphql; reconfigureMagento; removePackages $core $graphql
addPackages $core $inventory; reconfigureMagento; removePackages $core $inventory
addPackages $bundled $inventory; reconfigureMagento; removePackages $bundled $inventory
addPackages $bundled $graphql; reconfigureMagento; removePackages $bundled $graphql
addPackages $inventory $graphql; reconfigureMagento; removePackages $inventory $graphql

addPackages $core $bundled $graphql; reconfigureMagento; removePackages $core $bundled $graphql
addPackages $core $bundled $inventory; reconfigureMagento; removePackages $core $bundled $inventory
addPackages $core $graphql $inventory; reconfigureMagento; removePackages $core $graphql $inventory
addPackages $bundled $graphql $inventory; reconfigureMagento; removePackages $bundled $graphql $inventory

addPackages $core $bundled $graphql $inventory; reconfigureMagento; removePackages $core $bundled $graphql $inventory

