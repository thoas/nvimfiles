" Jinja HTML templates: HTML highlighting with Jinja layered on top.
" Runs before the built-in syntax/jinja.vim, which then sees b:current_syntax and stops.
if exists('b:current_syntax')
  finish
endif

if expand('%:t') =~# '\.html\%(\.j2\|\.jinja2\=\)\=$'
  runtime! syntax/html.vim
  unlet! b:current_syntax
endif

execute 'source' fnameescape($VIMRUNTIME . '/syntax/jinja.vim')
