# Middleman AMP Boilerplate

Using [Middleman](https://middlemanapp.com/) and [AMP Project](https://www.ampproject.org/).


## Accelerated Mobile Pages project in short

- Targeted towards online publishing, but is suitable for any web content
  - instant loading with pre-loading (actually pre-loading only the [ATF](https://en.wikipedia.org/wiki/Above_the_fold) content)
  - AMP pages are cached by Google
- An AMP page contains a script that handles the page load
- self-validates and outputs to console (append `#development=1` to URL for debugging)
- Carousels, lightboxes, YT videos, tweets, etc. - are all [AMP extensions](https://ampbyexample.com/) (e.g. `<amp-youtube>`), a special script has to be included for each
  - AMP creates a box that is filled with content when the extension loads
  - e.g. `<img>` element has to become `<amp-img>`, so AMP can decide what loads when - ATF content is prioritized
    - it has to have `width` and `height` inlined
    - can take a `srcset` instead of `src` (for responsive images)
    - add `layout="responsive"` to adapt size to viewport (while keeping the ratio based on the inlined dimensions)
    - resize is allowed if element is not in the viewport

## Notable AMP quirks

### Stylesheets

- have to be inlined in `<style amp-custom>` tag, this is done `after_build` (look in `config.rb`)
- external webfonts - `@import` is disallowed, use `<link>` tag

### Scripts

- Non-AMP JS is not allowed at all. Either [find](https://www.ampproject.org/docs/reference/extended.html) (or create) an AMP component or don't use AMP.


## How to use this project

- Declare if a page should be also built as AMP page in the [frontmatter](https://middlemanapp.com/basics/frontmatter/) (by default, it's not)
- Custom helpers:
  - `amp_img()` - in the non-AMP version, it will output a regular image tag
  - `is_amp()`
