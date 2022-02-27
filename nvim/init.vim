:lua require('entry_point')
:lua require('nvim-tree').setup(require('plugins.nvim_tree_config'))
:lua require('plugins.nvim_treesitter_config')
:lua require('editor_settings')
:lua require('plugins.coc_config').cocSetup()

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
