" FHICL Helper functions

" TODO: Restrict to just fcl files.
" TODO: Work out sensible default binds.

let g:vim_fhicl#search_current = get(g:, 'vim_fhicl#search_current', v:false)

let s:fhicl_include = '#include \?"\([A-Za-z/.]\+\)"'

function! Find_FHICL_File() abort

    " If the env var isn't set, stop.
    if empty($FHICL_FILE_PATH)
        echoerr "$FHICL_FILE_PATH isn't set!"
        return
    endif

    let l:current_line = getline(".")

    " If we aren't on an include line, stop.
    if l:current_line !~# s:current_line
        echoerr "Not on an include line!"
        return
    endif

    let l:match_list = matchlist(l:current_line, s:fhicl_include)

    " If there is no second group, (ie the FHICL file path), stop.
    if l:match_list < 2
        echoerr "No path found!"
        return
    endif

    " Get the file to look for, and setup the search paths.
    " TODO: Check if we should manually add the srcs folder.
    let l:fhicl_file = split(l:match_list[1], "/")[-1]
    let l:search_paths = split($FHICL_FILE_PATH, ";")

    let l:results = []

    for path in l:search_paths
        " Search for the file
        " TODO: Add result to list
        " TODO: Add config option for search settings:
        "   Stop after 1.
        "   Do all. (Default)

        " If the folder doesn't exist, don't bother searching there.
        if !isdirectory(path)
            continue
        endif

        " Skip checking the current working dir if the config option is set.
        " This is to match the functionality of find_fhicl.sh by default.
        if path == "." && g:vim_fhicl#search_current == v:false
            continue
        endif

        echo "find " . l:fhicl_file . "-name " . path
        " let l:result = systemlist("find " . l:fhicl_file . "-name " . path)
    endfor

    " Deal with the results to open file.
    " TODO: Open the results.
    " TODO: Config options for behaviour:
    "   If one, swap to it.
    "   If many, send to QF (and config option to open first result)
    " TODO: Open behaviour, ie readonly buffer etc.

    " TODO: Store current file in a global var, to move back through them.

endfunction
