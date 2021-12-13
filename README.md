# kakoune-macro-store
Store your macros to replay them later.
Dont lie to me, your machine has lua in it.

## Use
This plugin depends on luar, so make sure you have already required that module and then
require this one like this:

```kak
require-module kakoune-macro-store
```

then you would like to map the two main commands so
the plugin is easy to use, I personally use it like this:

```kak
map global normal <a-Q> ": store-macro-at-interactive<ret>"
map global normal <a-q> ": play-macro-from-interactive<ret>"

```
