# Magento 2 removal of all optional modules

**WARNING: This package is primarily meant as an experiment. We recommend using the other meta-packages in production.**

This repository contains a composer meta-package that removes optional modules. To install this package, use the following steps:

Require the composer plugin to manage replacements via a special `composer replace:*` command-line:
```bash
composer require yireo/magento2-replace-tools
```

Use the new command-line to add the meta-package of this specific repository to your root `composer.json`:
```bash
composer replace:bulk:add yireo/magento2-replace-all
```

Verify that your meta-information regarding composer replacements is correct:
```bash
composer replace:validate
```

Rebuild your root `composer.json` its `replace` section:
```bash
composer replace:build
```

Rebuild your composer dependencies:
```bash
composer update
```

See the package [`yireo/magento2-replace-tools`.](https://github.com/yireo/magento2-replace-tools) for more details.
