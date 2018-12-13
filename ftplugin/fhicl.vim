" FHICL Default Bindings

if !hasmapto('<Plug>vim-fhiclFindFhiclFile')
    nmap <silent><buffer> <leader>f <Plug>vim-fhiclFindFhiclFile
endif
nnoremap <silent><buffer> <Plug>vim-fhiclFindFhiclFile :
            \<C-U>call fhicl#base#Find_FHICL_File()<CR>

if !hasmapto('<Plug>vim-fhiclSwapToPrevious')
    nmap <silent><buffer> <BS> <Plug>vim-fhiclSwapToPrevious
endif
nnoremap <silent><buffer> <Plug>vim-fhiclSwapToPrevious :
            \<C-U>call fhicl#base#Swap_To_Previous()<CR>

" Set the comment string so comment toggling plugins work properly.
setlocal commentstring=#\ %s

" If the global variable storing the previous link does not exist, make
" it. Initialise it to the current file so that we can always get back to
" that no matter what.
let s:current_file = expand('%:p')

if !exists('g:vim_fhicl_prev_link')
    let s:start_file = {}
    let s:start_file.base_path = s:current_file

    let g:vim_fhicl_prev_link = s:start_file
endif
