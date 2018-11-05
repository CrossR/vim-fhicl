" FHICL Helper functions

let g:vim_fhicl#search_current = get(g:, 'vim_fhicl#search_current', 0)
let g:vim_fhicl#search_setting = get(g:, 'vim_fhicl#search_setting', "all")
let g:vim_fhicl#always_open_first = get(g:, 'vim_fhicl#always_open_first', 0)

let s:fhicl_include = '#include \?"\([a-zA-Z0-9/._]\+\)"'

" Function to find and follow a FHICL include.
function! fhicl#base#Find_FHICL_File() abort

    " If the env var isn't set, stop.
    if empty($FHICL_FILE_PATH)
        call EchoWarning("$FHICL_FILE_PATH isn't set!")
        return
    endif

    let l:current_line = getline(".")
    let l:current_file = expand('%:p')

    " If we aren't on an include line, stop.
    if l:current_line !~# s:fhicl_include
        call EchoWarning("Not on an include line!")
        return
    endif

    let l:match_list = matchlist(l:current_line, s:fhicl_include)

    " If there is no second group, (ie the FHICL file path), stop.
    if len(l:match_list) < 2
        call EchoWarning("No path found!")
        return
    endif

    " Get the file to look for, and setup the search paths.
    let l:fhicl_file = split(l:match_list[1], "/")[-1]
    let l:search_paths = split($FHICL_FILE_PATH, ":")

    " If a local sources folder exists, use that.
    " Add to the front since to favour a local, editable copy.
    if exists($MRB_SOURCE)
        let l:search_paths = [$MRB_SOURCE] + l:search_paths
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

        call setloclist(0, map(l:found_fhicl, '{"filename": v:val}'))
        lopen
    elseif len(l:found_fhicl) == 0
        call EchoWarning("No matches found...")
        return
    endif

    " If the global variable storing the previous link does not exist, make
    " it. Initialise it to the starter file so that we can always get back to
    " that no matter what.
    if !exists('g:vim_fhicl_prev_link')
        let l:start_file = {}
        let l:start_file.path = l:current_file

        let g:vim_fhicl_prev_link = [l:start_file]
    endif

    let l:prev_link = {}
    let l:prev_link.path = l:current_file

    let g:vim_fhicl_prev_link = g:vim_fhicl_prev_link + [l:prev_link]

endfunction

" Function to move back to the previous FHICL file.
function! fhicl#base#Swap_To_Previous() abort

    " If there is no variable set, can't move back.
    if !exists('g:vim_fhicl_prev_link')
        return
    endif

    " If the variable is empty, can't move back.
    if empty(g:vim_fhicl_prev_link)
        return
    endif

    " Otherwise, swap to the listed file.
    let l:previous_file = g:vim_fhicl_prev_link[-1]

    " Don't remove the final element, sinch its the initial file the user
    " opened. That way, we can always go back to that file.
    if len(g:vim_fhicl_prev_link) > 1
        call remove(g:vim_fhicl_prev_link, -1)
    endif

    execute "edit " . l:previous_file.path

endfunction

" Helper function to echo a warning
" Using echoerr is too much for not an error.
" Using just echo isn't that visible.
function! EchoWarning(msg)
    echohl WarningMsg
    echo "Warning"
    echohl None
    echon ': ' a:msg
endfunction
