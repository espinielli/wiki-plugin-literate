# Federated Wiki - Literate Plugin

The Literate plugin provides the possibility to specify code chunks ala Literate Programming in a Federated wiki page.

The Tangle plugin will allow to extract the code from Literate wiki pages.

See [About Literate Plugin](http://fed.wiki.org/about-literate-plugin.html) for how-to documentation about this plugin.

See [About Plugins](http://plugins.fed.wiki.org/about-plugins.html) for general information about plugins.

### Development

When tests will be written, most of the plugin machinery can be tested in node.js at build time.

```
grunt build
```
to compile coffeescript and run non-ui tests.
```
grunt watch
````
to build on updates to plugin or tests.

### To Do's
- [ ] parse NAME and LANG as in reduce plugin instead of requiring them in JSON format in first line of chunk
- [ ] experiment with using [Prism.js](http://prismjs.com/), or [SyntaxHighlighter](http://alexgorbatchev.com/SyntaxHighlighter/)
- [ ] keep styling in separate ```.css```
- [ ] augment chunk title/name with a list of urls to the different parts, i.e. if current chunk is 3, then 1, 2 and 4 are links [1](1), [2](2), **3**, [4](4)
