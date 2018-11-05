" FHICL Helper functions

let g:vim_fhicl#search_current = get(g:, 'vim_fhicl#search_current', 0)
let g:vim_fhicl#search_setting = get(g:, 'vim_fhicl#search_setting', "all")
let g:vim_fhicl#always_open_first = get(g:, 'vim_fhicl#always_open_first', 0)
let g:vim_fhicl#dont_open_file = get(g:, 'vim_fhicl#dont_open_file', 0)

let s:fhicl_include = '#include \?"\([a-zA-Z0-9/._]\+\)"'

" Function to find and follow a FHICL include.
function! fhicl#base#Find_FHICL_File() abort

    " If the env var isn't set, stop.
    if empty($FHICL_FILE_PATH)
        call EchoWarning("$FHICL_FILE_PATH isn't set!")
        return
    endif

    " Get the current line to check if it has an include.
    " Get the current file path for later use of saving the current file for
    " navigating back.
    let l:current_line = getline(".")
    let l:current_file = expand('%:p')

    " If we aren't on an include line, stop.
    if l:current_line !~# s:fhicl_include
        call EchoWarning("Not on an include line!")
        return
    endif

    " At this point, we are on an include line, so get the FHICL file name.
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

    " Search for the file
    for path in l:search_paths

        " If the folder doesn't exist, don't bother searching there.
        if !isdirectory(path)
            continue
        endif

        " Skip checking the current working dir if the config option is set.
        " This is to match the functionality of find_fhicl.sh by default.
        if path == "." && g:vim_fhicl#search_current == 0
            continue
        endif

        " Actually do the search using find.
        " If there is any results, add them to the ongoing list.
        " If the relevant config option to stop on the first match is set,
        " break when a match is found.
        let l:result = systemlist("find " . path . " -name " . l:fhicl_file)

        if len(l:result) > 0
            let l:found_fhicl = l:found_fhicl + l:result

            if g:vim_fhicl#search_setting == "first"
                break
            endif
        endif
    endfor

    " Deal with the results:
    "     - If there is only 1 result, open it.
    "       - There is a config option to skip this and only populate the
    "       location list instead.
    "     - If there is more than 1, put them in the location list and open the
    "     list.
    "       - There is a config option to also open a file in the current
    "       buffer here too.
    "     - If nothing was found, report it and stop.
    if len(l:found_fhicl) == 1

        if g:vim_fhicl#dont_open_file
            call setloclist(0, map(l:found_fhicl, '{"filename": v:val}'))
            lopen
        else
            execute "edit " . l:found_fhicl[0]
        endif

    elseif len(l:found_fhicl) > 1

        if g:vim_fhicl#always_open_first && !g:vim_fhicl#dont_open_file
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

    " Store the current file in a global variable such that it can be used
    " later to move back to the previous file.
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

    " Don't remove the final element, since its the initial file the user
    " opened. That way, we can always go back to that file.
    if len(g:vim_fhicl_prev_link) > 1
        call remove(g:vim_fhicl_prev_link, -1)
    endif

    execute "edit " . l:previous_file.path

endfunction

" Helper function to echo a warning
" Using echoerr is too much for not an error.
" Using just echo isn't that visible.
function! EchoWarning(msg) abort
    echohl WarningMsg
    echo "Warning"
    echohl None
    echon ': ' a:msg
endfunction
