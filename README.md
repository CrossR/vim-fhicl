# vim-fhicl

Helpers for [FHICL](https://cdcvs.fnal.gov/redmine/projects/fhicl/wiki) Files in Vim + Neovim.

 * Adds basic syntax highlighting to `.fcl` files.
    * Highlight keywords like `physics`, `analyzers` to flag up typos.
    * Properly colour `#include` statements, comments and numbers.
 * Helper for moving around included `fcl` files.
     * Defaults to `<Leader>-f` to follow an include, and `Backspace` to return to the previous file.
     * Multiple results are sent to the Location List, where they can be selected with `Enter` to open them.
 * Update the `commentstring` variable for `.fcl` files, so commenting plugins work.
 * Sets the `JSON` indentation rules for the `.fcl` files, to give more intellingent auto indentation.
    * **TODO:** Check and update this logic to make sure it works nicely for all files, and all styles of line.

### Usage

Once installed, syntax highlighting should be applied automatically for all
`.fcl` files.

Pressing `<leader>-f` on any `#include` statement (`leader`
defaults to `\`, such that `\` then `f` calls the function) will search for and
then open the corresponding `fcl` file. If multiple results are found, the
Location List will be populated, which can be navigated like normal and a selected
file opened with `Enter`.

Once finished with a file, pressing `Backspace` will
navigate back to the parent file.

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
" the first file will be opened as well.
" Defaults to 0, set to 1 to open it every time.
let g:vim_fhicl#always_open_first = 0

" Controls if the given file should be opened.
" If set to 1, when invoking the plugin on an include line,
" the results will always be sent to the location list, and
" never opened.
" Defaults to 0, set to 1 to never open a file and only populate
" the location list.
let g:vim_fhicl#dont_open_file = 0
```

### Custom Binds

```vim
" Remap the follow function with the following.
" Replace <leader>-f with the correct bind.
nmap <leader>-f <Plug>vim-fhiclFindFhiclFile

" Remap the swap back function with the following.
" Replace <BS> with the correct bind.
nmap <BS> <Plug>vim-fhiclSwapToPrevious

```
