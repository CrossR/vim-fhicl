" FHICL Default Bindings

" <leader>ff -> `F`ind `F`hicl
if !hasmapto('<Plug>vim-fhiclFindFhiclFile')
    nmap <silent><buffer> <leader>ff <Plug>vim-fhiclFindFhiclFile
endif
nnoremap <silent><buffer> <Plug>vim-fhiclFindFhiclFile :
            \<C-U>call fhicl#base#Find_FHICL_File()<CR>

if !hasmapto('<Plug>vim-fhiclSwapToPrevious')
    nmap <silent><buffer> <BS> <Plug>vim-fhiclSwapToPrevious
endif
nnoremap <silent><buffer> <Plug>vim-fhiclSwapToPrevious :
            \<C-U>call fhicl#base#Swap_To_Previous()<CR>

" <leader>fi -> `F`ind `I`nclude
if !hasmapto('<Plug>vim-fhiclFindIncludes')
    nmap <silent><buffer> <leader>fi <Plug>vim-fhiclFindIncludes
endif
nnoremap <silent><buffer> <Plug>vim-fhiclFindIncludes :
            \<C-U>call fhicl#base#Find_FHICL_Includes()<CR>

" <leader>fa -> `F`ind `A`ll
if !hasmapto('<Plug>vim-fhiclFindAll')
    nmap <silent><buffer> <leader>fa <Plug>vim-fhiclFindAll
endif
nnoremap <silent><buffer> <Plug>vim-fhiclFindAll :
            \<C-U>call fhicl#base#Find_All_FHICL()<CR>

" <leader>fs -> `F`hicl `S`earch
if !hasmapto('<Plug>vim-fhiclSearchAll')
    nmap <leader>fs <Plug>vim-fhiclSearchAll
endif
nnoremap <silent><buffer> <Plug>vim-fhiclSearchAll :
                \<C-U>call fhicl#base#Search_All_FHICL()<CR>

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
