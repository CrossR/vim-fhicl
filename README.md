# vim-fhicl

Helpers for [FHICL](https://cdcvs.fnal.gov/redmine/projects/fhicl/wiki) Files in Vim + Neovim.

 * Adds basic syntax highlighting to `.fcl` files.
    * Highlight keywords like `physics`, `analyzers` to flag up typos.
    * Properly colour `#include` statements, comments and numbers.
 * Helper for moving around included `fcl` files.
     * Defaults to `<Leader>-ff` to follow an include, and `Backspace` to return to the previous file.
     * Multiple results are sent to the Location List, where they can be selected with `Enter` to open them.
 * Helper for finding all `fcl` files that `#include ""` the current one.
     * Populates the Vim Location List with all the results.
     * Default to `<Leader>-fi`. Then `Enter` to select a file in the Location
     * List, and `Backspace` to return to the previous file.
     * Uses `grep` by default, but can be changed to any other command.
 * Helper for finding all `fcl` files in the current path.
     * Defaults to `<Leader>-fs`.
     * Results are pasted into the location list, or piped into `FZF` if available.
        * `fzf`: https://github.com/junegunn/fzf.vim
 * Update the `commentstring` variable for `.fcl` files, so commenting plugins work.
 * Sets the `JSON` indentation rules for the `.fcl` files, to give more intelligent auto indentation.
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

" The command used to search for files that include the current one.
" If replaced, the command should be passed with any flags needed for
" recursive running, as well as only returning files.
" Defaults to using "grep -lr", where "l" returns just files and "r" makes
" grep recursive.
" To use ripgrep, instead use "rg --files".
let g:vim_fhicl#search_command = "grep -lr"

" The command used to find files.
" If replaced, the command should be passed with any flags needed for
" recursive running, as well as only returning files.
" Defaults to using "find", and due to the command setup, only find
" replacements will work easily. Code could be updated to instead take a full
" command, not just an executable.
let g:vim_fhicl#find_command = "find"
```

### Custom Binds

```vim
" Remap the follow function with the following.
" Replace <leader>-ff with the correct bind.
nmap <leader>-ff <Plug>vim-fhiclFindFhiclFile

" Remap the swap back function with the following.
" Replace <BS> with the correct bind.
nmap <BS> <Plug>vim-fhiclSwapToPrevious

" Remap the search include function with the following.
" Replace <leader>-fi with the correct bind.
nmap <leader>-fi <Plug>vim-fhiclFindIncludes

" Remap the search through all file names with the following.
" Replace <leader>-fi with the correct bind.
nmap <leader>-fi <Plug>vim-fhiclFindAll

```
