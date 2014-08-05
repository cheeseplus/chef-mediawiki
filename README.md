Description
===========

Installs and configures a MediaWiki instance and its dependencies

Requirements
------------
Chef 11.14.2+


## Platforms:

The following platforms and versions are tested and supported using
[test-kitchen](http://kitchen.ci/)

* Ubuntu 14.04

Attributes
----------

Usage
-----
Include the mediawiki recipe in your run list:

```sh
knife node run_list add NODE "recipe[mediawiki::default]"
```

or add the mediawiki recipe as a dependency and include it from inside
another cookbook:

```ruby
include_recipe 'mediawiki::default'
```

License & Authors
-----------------
- Author: ccat
- Author: millisami (<millisami@gmail.com>)
- Author: Seth Thomas (<cheeseplus@polycount.com>)


```text

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```