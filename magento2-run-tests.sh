#!/bin/bash

magentoVersion=$1
magentoTestDir=$2

DB_HOST=172.20.0.102
DB_NAME=magento2
DB_USER=root
DB_PASSWORD=root

if [ -z "$magentoVersion" ]; then
    magentoVersion="@dev"
fi

if [ ! -d "$magentoTestDir" ]; then
    magentoTestDir="/tmp/magento$$"
fi


echo "Working with Magento version $magentoVersion"

echo "Using directory $magentoTestDir"
mkdir -p $magentoTestDir
cd $magentoTestDir

all=yireo/magento2-replace-all
core=yireo/magento2-replace-core
bundled=yireo/magento2-replace-bundled
graphql=yireo/magento2-replace-graphql
inventory=yireo/magento2-replace-inventory

function installMagento() {
    echo "Installing Magento"
    composer create-project --no-install --stability dev --prefer-source --repository-url=https://repo.magento.com/ magento/project-community-edition:$magentoVersion . || exit
    mkdir -p var/composer_home
    test -f ~/.composer/auth.json && cp ~/.composer/auth.json var/composer_home/auth.json
    composer config minimum-stability dev
    composer config prefer-stable true
    composer config repositories.0 --unset
    composer config repositories.magento-marketplace composer https://repo.magento.com/
    composer install --prefer-dist || exit
}

function setupMagento() {
    echo "Run Magento setup"
    bin/magento setup:install --base-url=http://example.com/ \
    --db-host=${DB_HOST} --db-name=${DB_NAME} \
    --db-user=${DB_USER} --db-password=${DB_PASSWORD} \
    --admin-firstname=John --admin-lastname=Doe \
    --admin-email=johndoe@example.com \
    --admin-user=johndoe --admin-password=johndoe434S822 \
    --backend-frontname=admin --language=en_US \
    --currency=USD --timezone=Europe/Amsterdam --cleanup-database \
    --sales-order-increment-prefix="ORD$" --session-save=db \
    --use-rewrites=1 || exit
}

function reconfigureMagento() {
    bin/magento deploy:mode:set developer || exit
    composer clear-cache
    redis-cli flushall
    rm -rf generated/
    bin/magento module:enable --all || exit
    bin/magento setup:di:compile || exit
}

function addPackages() {
    echo -e "\e[34mAdding packages $*"
    echo -e "\e[0m"
    packages=$@
    for package in $packages; do
        echo "composer require --no-update $package:$magentoVersion"
        composer require --no-update $package:$magentoVersion || exit
    done
    rm -rf composer.lock vendor/
    composer install --prefer-dist || exit
}

function removePackages() {
    echo "Removing packages $*"
    packages=$*
    composer remove --no-update $core $bundled $graphql $inventory $all
}

test -d vendor/ || installMagento
test -f app/etc/env.php || setupMagento

addPackages $core; reconfigureMagento; removePackages $core
addPackages $bundled; reconfigureMagento; removePackages $bundled
addPackages $graphql; reconfigureMagento; removePackages $graphql
addPackages $inventory; reconfigureMagento; removePackages $inventory

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

addPackages $all; reconfigureMagento; removePackages $all

