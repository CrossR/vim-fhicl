# vim-fhicl

Helpers for [FHICL](https://cdcvs.fnal.gov/redmine/projects/fhicl/wiki) Files in Vim + Neovim.

 * Add basic syntax highlighting to `.fcl` files.
 * Helper for moving around included `fcl` files.
     * Defaults to `Enter` to follow an include, and `Backspace` to return to the previous file.
     * Multiple results are sent to the Location List.

TODO:
 * Look into properties to set for the opened buffer.
    * That is, set it to read only etc.
 * Make binds changeable.

### Installation

Can be installed with `vim-plug` or any other similar package manager with:

```vim
Plug 'CrossR/vim-fhicl'
```

### Config Options

```vim
" Controls if the current directory should be searched.
" Defaults to 0, set to 1 to search it.
let g:vim_fhicl#search_current = 0

" Controls when the search stops.
" Defaults to 'all' which means get all results.
" If set to 'first', will break after finding one match.
let g:vim_fhicl#search_setting = "all"

" Controls if the first file should be opened.
" If multiple results are found, the results are
" sent to the location list. If this option is set,
" the first file will be opened, as well.
" Defaults to 0, set to 1 to open it every time.
let g:vim_fhicl#search_current = 0
```
