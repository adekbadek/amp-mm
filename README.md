# Middleman AMP Boilerplate

Using [Middleman](https://middlemanapp.com/) and [AMP Project](https://www.ampproject.org/).


## Accelerated Mobile Pages project in short

- Targeted towards online publishing, but is suitable for any web content
  - instant loading with pre-loading (actually pre-loading only the ATF content)
  - AMP pages are cached by Google
- An AMP page contains a script that handles the page load
- `<img>` tags become `<amp-img>` tags, so AMP can handle what loads when - above-the-fold content is prioritized
  - `layout="responsive"`
  - resize is allowed if element is not in the viewport
- self-validates and outputs to console (append `#development=1` to URL for debugging)
- Carousels, a lightbox, YT videos, tweets, etc. - are all AMP components (e.g. `<amp-youtube>`), special script has to be included for each
  - AMP creates a box that is filled with content when the extension loads


## Quirks

### Stylesheets

- have to be inlined in `<style amp-custom>` tag, this is done `after_build` (look in `config.rb`)
- external webfonts - `@import` is disallowed, use `<link>` tag

### Scripts

- Non-amp JS is not allowed at all. Either [find](https://www.ampproject.org/docs/reference/extended.html) (or create) an AMP component or don't use AMP.
