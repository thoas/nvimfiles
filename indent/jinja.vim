" Jinja HTML templates indent like HTML
if expand('%:t') =~# '\.html\%(\.j2\|\.jinja2\=\)\=$'
  runtime! indent/html.vim
endif
