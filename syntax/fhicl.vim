" Vim syntax file
" Language:	FHICL configure file
" Maintainer:	Ryan Cross <r.cross@lancaster.ac.uk>
" Last Change:	2018 Nov 02

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
    finish
endif

" Base it on C syntax, so we get include, numbers, strings etc for
" free.
runtime! syntax/c.vim
unlet b:current_syntax

" FHICL Comments
syntax match fhiclComment "#\(include\)\@!.*"

" FHICL Keywords
syntax match fhiclKeyword "@local::"
syntax match fhiclKeyword "@table::"
syntax keyword fhiclKeyword process_name services source outputs physics
syntax keyword fhiclKeyword producers analyzers filters trigger_paths end_paths
syntax keyword fhiclKeyword BEGIN_PROLOG END_PROLOG

highlight link fhiclKeyword Structure
highlight def link fhiclComment Comment

let b:current_syntax = 'fhicl'
