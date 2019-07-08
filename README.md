# Magento 2 removal of all optional modules
This repository contains a composer meta-package that removes numerous Magento 2 modules, making your environment lighter. To install, use the following:

    composer require yireo/magento2-replace-all:2.3.*

_Replace `*` with your magento version_

## Requiments
This package support Magento 2.3 or higher.

## Notes
This package makes use of the following sub-packages:

- `yireo/magento2-replace-bundled` removes third party bundled extensions
- `yireo/magento2-replace-core` removes optional core modules
- `yireo/magento2-replace-graphql` removes optional GraphQL modules
- `yireo/magento2-replace-inventory` removes optional MSI modules

## Troubleshooting
The following things might fail with these replacements:

- A certain extension might have a dependency on Magento module X, documented via its `composer.json` or not. If so, skip
  our main package but copy the `replace` lines to your own project composer.
- After installing certain extensions, everything works fine on a composer level, but things fail when compiling DI
  (`setup:di:compile`). If this concerns a setup with only core packages, make sure to open an **Issue**. 

## Testing
To test if all packages are valid, I have used the script `magento2-run-tests.sh` included in this repo. To test this
yourself, make sure to start with a completely clean Magento 2 setup. Next, once Magento is setup and confirmed to be
working, copy this script to its root and run it. The scripts argument defaults to using the `@dev` versions of these
replace packages:

    ./magento2-run-tests.sh 2.3.2
