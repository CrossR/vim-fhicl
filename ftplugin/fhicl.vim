" FHICL Default Bindings

if !hasmapto('<Plug>vim-fhiclFindFhiclFile')
    nmap <silent><buffer> <CR> <Plug>vim-fhiclFindFhiclFile
endif
nnoremap <silent><buffer> <Plug>vim-fhiclFindFhiclFile :
            \<C-U>call fhicl#base#Find_FHICL_File()<CR>

if !hasmapto('<Plug>vim-fhiclSwapToPrevious')
    nmap <silent><buffer> <BS> <Plug>vim-fhiclSwapToPrevious
endif
nnoremap <silent><buffer> <Plug>vim-fhiclSwapToPrevious :
            \<C-U>call fhicl#base#Swap_To_Previous()<CR>
