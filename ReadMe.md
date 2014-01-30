# Federated Wiki - Literate Plugin

The Literate plugin provides the possibility to specify code chunks ala Literate Programming in a Federated wiki page.

The Tangle plugin will allow to extract the code from Literate wiki pages.

See [About Literate Plugin](http://fed.wiki.org/about-literate-plugin.html) for how-to documentation about this plugin.

See [About Plugins](http://plugins.fed.wiki.org/about-plugins.html) for general information about plugins.

### Development

Most of the calculation machinery can be tested in node.js at build time.

```
grunt build
```
to compile coffeescript and run non-ui tests.
```
grunt watch
````
to build on updates to plugin or tests.
