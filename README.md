# Magento 2 removal of all optional modules
This repository contains a composer meta-package that removes numerous Magento 2 modules, making your environment lighter. To install, use the following:

    composer require yireo/magento2-replace-all:2.3.*

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

## FAQ
#### Installing this package leads to many errors
Intruiging, isn't it? Yes, this could happen. Perhaps some modules that you are replacing are in use with your own custom code. Or perhaps you are relying on other third party extensions that have yet an undocumented dependency that conflicts with this `replace` trick. If you are not willing to troubleshoot this, simply skip this trick and move on. If you are willing to troubleshoot this, copy the `replace` lines to your own `composer.json` and remove lines one-by-one until you have found the culprit.

#### Is this package compatible with Magento 2.x.y?
Theoretically, yes. Make sure this package is not a module, not a library, not a Magento extension. It is a gathering of hacks. So, if you understand the benefit of the `replace` trick in composer, you can use this repository to ease the pain of upgrading.

One conceptual idea in this repository is to try to keep track of the main Magento version by creating a branch `2.x.y` with a corresponding release `2.x.y`. Sometimes the actual work falls behind, which by no means indicates that the current bundling of tricks no longer works. Simply, install this package using `composer` and see if this works for you (see below).

#### How to test if this is working?
Take your test environment. Install this package. If this works, run `bin/magento setup:di:compile` (in both Developer Mode and Production Mode) to see if there are any errors. If this fails, feel free to report an issue here. If this works, you could assume that this works ok.

Remember this repository offers a smart hack, not a supported solution. You can also live with a slower Magento installation that fully complies with the Magento standards (and ships with modules you don't use and/or like).

## Testing
To test if all packages are valid, I have used the script `magento2-run-tests.sh` included in this repo. To test this
yourself, make sure to start with a completely clean Magento 2 setup. Next, once Magento is setup and confirmed to be
working, copy this script to its root and run it. The scripts argument defaults to using the `@dev` versions of these
replace packages:

    ./magento2-run-tests.sh 2.3.2

In a generic environment, all tests (and therefore, all possible combinations of the replace packages) should work.
