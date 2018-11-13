" Vim syntax file
" Language:    FHICL
" Maintainer:  Ryan Cross <r.cross@lancaster.ac.uk>
" Last Change: 2018 Nov 02

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
    finish
endif

" Base it on C syntax, so we get include, numbers, strings etc for
" free.
runtime! syntax/c.vim
unlet b:current_syntax

" FHICL Identifiers, except the keywords which are defined
" individually below.
syntax match fhiclIdentifier "^\s*\w\+\s*\(:\)\@<!"

" FHICL Comments
syntax match fhiclComment "#\(include\)\@!.*"

" FHICL Keywords
syntax match fhiclType "@local::"
syntax match fhiclType "@table::"

syntax keyword fhiclKeyword process_name services source outputs physics output
syntax keyword fhiclKeyword producers analyzers filters trigger_paths end_paths

syntax keyword fhiclPreProc BEGIN_PROLOG END_PROLOG

highlight link fhiclIdentifier Identifier
highlight link fhiclKeyword Type
highlight link fhiclPreProc PreProc
highlight link fhiclComment Comment
highlight link fhiclType Type

let b:current_syntax = 'fhicl'
