" FHICL Helper functions

" TODO: Restrict to just fcl files.
" TODO: Work out sensible default binds.

let g:vim_fhicl#search_current = get(g:, 'vim_fhicl#search_current', v:false)
let g:vim_fhicl#search_setting = get(g:, 'vim_fhicl#search_setting', "all")
let g:vim_fhicl#always_open_first = get(g:, 'vim_fhicl#always_open_first', v:false)

let s:fhicl_include = '#include \?"\([a-zA-Z0-9/._]\+\)"'

function! Find_FHICL_File() abort

    " If the env var isn't set, stop.
    if empty($FHICL_FILE_PATH)
        echoerr "$FHICL_FILE_PATH isn't set!"
        return
    endif

    let l:current_line = getline(".")

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
    " TODO: Check if we should manually add the srcs folder.
    let l:fhicl_file = split(l:match_list[1], "/")[-1]
    let l:search_paths = split($FHICL_FILE_PATH, ";")

    let l:found_fhicl = []

    for path in l:search_paths
        " Search for the file

        " If the folder doesn't exist, don't bother searching there.
        if !isdirectory(path)
            continue
        endif

        " Skip checking the current working dir if the config option is set.
        " This is to match the functionality of find_fhicl.sh by default.
        if path == "." && g:vim_fhicl#search_current == v:false
            continue
        endif

        echo "find " . l:fhicl_file . " -name " . path
        let l:result = []
        " let l:result = systemlist("find " . l:fhicl_file . " -name " . path)

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
        edit l:found_fhicl[0]
    elseif len(l:found_fhicl) > 1

        " TODO: Populate QF here.

        if g:vim_fhicl#always_open_first
            edit l:found_fhicl[0]
        endif
    endif

    let b:vim_fhicl_prev_link = {}
    let b:vim_fhicl_prev_link.path = expand('%')

endfunction