" FHICL Helper functions

let g:vim_fhicl#search_current = get(g:, 'vim_fhicl#search_current', 0)
let g:vim_fhicl#search_setting = get(g:, 'vim_fhicl#search_setting', "all")
let g:vim_fhicl#always_open_first = get(g:, 'vim_fhicl#always_open_first', 0)

let s:fhicl_include = '#include \?"\([a-zA-Z0-9/._]\+\)"'

" Function to find and follow a FHICL include.
function! fhicl#base#Find_FHICL_File() abort

    " If the env var isn't set, stop.
    if empty($FHICL_FILE_PATH)
        echoerr "$FHICL_FILE_PATH isn't set!"
        return
    endif

    let l:current_line = getline(".")
    let l:current_file = expand('%')

    " If we aren't on an include line, stop.
    if l:current_line !~# s:fhicl_include
        echoerr "Not on an include line!"
        return
    endif

    let l:match_list = matchlist(l:current_line, s:fhicl_include)

    " If there is no second group, (ie the FHICL file path), stop.
    if len(l:match_list) < 2
        echoerr "No path found!"
        return
    endif

    " Get the file to look for, and setup the search paths.
    let l:fhicl_file = split(l:match_list[1], "/")[-1]
    let l:search_paths = split($FHICL_FILE_PATH, ":")

    " If a local sources folder exists, use that.
    " Add to the front since to favour a local, editable copy.
    if exists($MRB_SOURCE)
        l:search_paths = [$MRB_SOURCE] + l:search_paths
    endif

    let l:found_fhicl = []

    for path in l:search_paths
        " Search for the file

        " If the folder doesn't exist, don't bother searching there.
        if !isdirectory(path)
            continue
        endif

        " Skip checking the current working dir if the config option is set.
        " This is to match the functionality of find_fhicl.sh by default.
        if path == "." && g:vim_fhicl#search_current == 0
            continue
        endif

        let l:result = systemlist("find " . path . " -name " . l:fhicl_file)

        if len(l:result) > 0
            let l:found_fhicl = l:found_fhicl + l:result

            if g:vim_fhicl#search_setting == "first"
                break
            endif
        endif
    endfor

    " Deal with the results to open file.
    " TODO: Open behaviour, ie readonly buffer etc.
    if len(l:found_fhicl) == 1
        execute "edit " . l:found_fhicl[0]
    elseif len(l:found_fhicl) > 1

        if g:vim_fhicl#always_open_first
            execute "edit " . l:found_fhicl[0]
        endif

        call setloclist(0, map(l:found_fhicl, '{"filename: v:val"}'))
        exec lopen
    endif

    let b:vim_fhicl_prev_link = {}
    let b:vim_fhicl_prev_link.path = l:current_file

endfunction

" Function to move back to the previous FHICL file.
function! fhicl#base#Swap_To_Previous() abort

    " If there is no variable set, can't move back.
    if !exists(b:vim_fhicl_prev_link)
        return
    endif

    " If the variable is empty, can't move back.
    if empty(b:vim_fhicl_prev_link)
        return
    endif

    " Otherwise, swap to the listed file.
    execute "edit " . b:vim_fhicl_prev_link.path

endfunction
