# Magento 2 removal of all optional modules
This repository contains a composer meta-package that removes numerous Magento 2 modules, making your environment lighter. To install, use the following:

    composer require yireo/magento2-replace-all:2.3.1
    
This package makes use of the following sub-packages:

- `yireo/magento2-replace-bundled` removes third party bundled extensions
- `yireo/magento2-replace-core` removes optional core modules
- `yireo/magento2-replace-graphql` removes optional GraphQL modules
- `yireo/magento2-replace-inventory` removes optional MSI modules
