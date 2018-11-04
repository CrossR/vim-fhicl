" FHICL Default Bindings

if !hasmapto('<Plug>vim-fhiclFindFhiclFile')
    nnoremap <silent><buffer> <CR> <Plug>vim-fhiclFindFhiclFile
endif
nnoremap <silent><buffer> <CR> <Plug>vim-fhiclFindFhiclFile :
            \<C-U>call fhicl#base#Find_FHICL_File()<CR>

if !hasmapto('<Plug>vim-fhiclSwapToPrevious')
    nnoremap <silent><buffer> <CR> <Plug>vim-fhiclSwapToPrevious
endif
nnoremap <silent><buffer> <CR> <Plug>vim-fhiclSwapToPrevious :
            \<C-U>call fhicl#base#Swap_To_Previous()<CR>
