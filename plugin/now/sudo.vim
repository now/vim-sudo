" Vim plugin file
" Maintainer:	    Nikolai Weibull <now@bitwi.se>
" Latest Revision:  2006-06-14

if exists("loaded_plugin_now_sudo")
  finish
endif
let loaded_plugin_now_sudo = 1

let s:cpo_save = &cpo
set cpo&vim

augroup sudo
  autocmd!
  autocmd BufReadCmd,FileReadCmd    sudo:{*,*/*} call s:read('<afile>')
  autocmd BufWriteCmd,FileWriteCmd  sudo:{*,*/*} call s:write('<afile>')
augroup end

function s:cleanup(url)
  return escape(substitute(expand(a:url), '^sudo:', '', ''),
              \ " !\"#$%&'()*;<=>?[\\]^`{|}")
endfunction

function s:read(url) abort
  silent execute '1read !sudo cat' s:cleanup(a:url) '2>/dev/null'
  1delete _
  set nomodified
  filetype detect
  file
endfunction

function s:write(url) abort
  execute 'write !sudo tee >/dev/null' s:cleanup(a:url)
  set nomodified
  let bytes = line2byte('$') + len(getline('$'))
  echomsg printf('"%s" %dL, %dC written', bufname('%'), line('$'), bytes)
endfunction

let &cpo = s:cpo_save
