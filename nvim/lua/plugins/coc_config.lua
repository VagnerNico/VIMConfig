local config = {}
function config.cocSetup()
  --Install CoC servers
  vim.cmd [[ let g:coc_global_extensions = [ 'coc-eslint', 'coc-prettier', 'coc-svelte', 'coc-tsserver' ] ]]

  --Set internal encoding of vim, not needed on neovim, since coc.nvim using some
  --unicode characters in the file autoload/float.vim
  vim.opt.encoding = 'utf-8'

  --TextEdit might fail if hidden is not set.
  vim.opt.hidden = true

  --Some servers have issues with backup files, see #649.
  vim.opt.backup = true
  vim.opt.writebackup = true

  --Give more space for displaying messages.
  vim.opt.cmdheight = 2

  --Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  --delays and poor user experience.
  vim.opt.updatetime = 300

  --Don't pass messages to |ins-completion-menu|.
  vim.opt.shortmess:append({ c = true })

  --Always show the signcolumn, otherwise it would shift the text each time
  --diagnostics appear/become resolved.
  if vim.fn.has("nvim-0.5.0") or vim.fn.has("patch-8.1.1564") then
    --Recently vim can merge signcolumn and number column into one
    vim.opt.signcolumn = 'number'
  else
    vim.opt.signcolumn = 'yes'
  end

  vim.api.nvim_set_keymap('i', '<cr>', 'pumvisible() ? "<C-y>" : "<C-g>u<CR>"', { noremap = true, silent = true, expr = true })
  vim.api.nvim_set_keymap('i', '<cr>', 'pumvisible() ? coc#_select_confirm() : "<C-g>u<CR>"', { noremap = true, silent = true, expr = true })

  if vim.fn.exists('*complete_info') then
    vim.api.nvim_set_keymap('i', '<cr>', 'complete_info(["selected"])["selected"] != -1 ? "<C-y>" : "<C-g>u<CR>"', { noremap = true, silent = true, expr = true })
  end
  --use <tab> for trigger completion and navigate to the next complete item
  vim.cmd [[
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction
  ]]

  --Use <c-space> to trigger completion.
  if vim.fn.has('nvim') then
    vim.api.nvim_set_keymap('i', '<c-space>', 'coc#refresh()', { noremap = true, silent = true, expr = true })
  else
    vim.api.nvim_set_keymap('i', '<c-@>', 'coc#refresh()', { noremap = true, silent = true, expr = true })
  end

  vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', { noremap = true, expr = true })
  vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', { noremap = true, expr = true })

  --Returns true if the color hex value is light
  vim.cmd [[
    function! IsHexColorLight(color) abort
      let l:raw_color = trim(a:color, '#')

      let l:red = str2nr(substitute(l:raw_color, '(.{2}).{4}', '1', 'g'), 16)
      let l:green = str2nr(substitute(l:raw_color, '.{2}(.{2}).{2}', '1', 'g'), 16)
      let l:blue = str2nr(substitute(l:raw_color, '.{4}(.{2})', '1', 'g'), 16)

      let l:brightness = ((l:red * 299) + (l:green * 587) + (l:blue * 114)) / 1000

      return l:brightness > 155
    endfunction
  ]]

  vim.cmd [[ 
  function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
    silent call CocActionAsync('doHover')
    endif
    endfunction
  ]]

  --Fixing background bug
  vim.g['&t_ut'] = ''
  vim.g.coc_default_semantic_highlight_groups = 1

  --Use tab for trigger completion with characters ahead and navigate.
  --NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  --other plugin before putting this into your config.
  vim.api.nvim_set_keymap('i', '<TAB>', 'pumvisible() ? "<C-n>" : <SID>check_back_space() ? "<TAB>" : coc#refresh()', { noremap = true, silent = true, expr = true })
  vim.api.nvim_set_keymap('i', '<S-TAB>', 'pumvisible() ? "<C-p>" : "<C-h>"', { noremap = true, expr = true })

  vim.cmd [[
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
  ]]

  --Make <CR> auto-select the first completion item and notify coc.nvim to
  --format on enter, <cr> could be remapped by other vim plugin
  vim.api.nvim_set_keymap('i', '<cr>', 'pumvisible() ? coc#_select_confirm() : "<C-g>u<CR><c-r>=coc#on_enter()<CR>"', { noremap = true, silent = true, expr = true })

  --Use `[g` and `]g` to navigate diagnostics
  --Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.

  vim.api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
  vim.api.nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })

  --GoTo code navigation.
  vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { silent = true })
  vim.api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
  vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
  vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { silent = true })

  --Use K to show documentation in preview window.
  vim.api.nvim_set_keymap('n', 'K', ':call <SID>show_documentation()<CR>', { noremap = true, silent = true })

  vim.cmd [[
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction
  ]]

  --Highlight the symbol and its references when holding the cursor.
  vim.cmd [[ autocmd CursorHold * silent call CocActionAsync('highlight') ]]

  --Symbol renaming.
  vim.api.nvim_set_keymap('n', '<leader>rn', '<Plug>(coc-rename)', {})

  --Formatting selected code.
  vim.api.nvim_set_keymap('x', '<leader>f', '<Plug>(coc-format-selected)', {})
  vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>(coc-format-selected)', {})

  vim.cmd [[
    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder.
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end
  ]]

  --Applying codeAction to the selected region.
  --Example: `<leader>aap` for current paragraph
  vim.api.nvim_set_keymap('x', '<leader>a', '<Plug>(coc-codeaction-selected)', {})
  vim.api.nvim_set_keymap('n', '<leader>a', '<Plug>(coc-codeaction-selected)', {})

  --Remap keys for applying codeAction to the current buffer.
  vim.api.nvim_set_keymap('n', '<leader>ac', '<Plug>(coc-codeaction)', {})
  --Apply AutoFix to problem on the current line.
  vim.api.nvim_set_keymap('n', '<leader>qf', '<Plug>(coc-fix-current)', {})

  --Run the Code Lens action on the current line.
  vim.api.nvim_set_keymap('n', '<leader>cl', '<Plug>(coc-codelens-action)', {})

  --Map function and class text objects
  --NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  vim.api.nvim_set_keymap('x', 'if', '<Plug>(coc-funcobj-i)', {})
  vim.api.nvim_set_keymap('o', 'if', '<Plug>(coc-funcobj-i)', {})
  vim.api.nvim_set_keymap('x', 'af', '<Plug>(coc-funcobj-a)', {})
  vim.api.nvim_set_keymap('o', 'af', '<Plug>(coc-funcobj-a)', {})
  vim.api.nvim_set_keymap('x', 'ic', '<Plug>(coc-classobj-i)', {})
  vim.api.nvim_set_keymap('o', 'ic', '<Plug>(coc-classobj-i)', {})
  vim.api.nvim_set_keymap('x', 'ac', '<Plug>(coc-classobj-a)', {})
  vim.api.nvim_set_keymap('o', 'ac', '<Plug>(coc-classobj-a)', {})

  --Remap <C-f> and <C-b> for scroll float windows/popups.
  if vim.fn.has('nvim-0.4.0') or vim.fn.has('patch-8.2.0750') then
    vim.api.nvim_set_keymap('n', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', { noremap = true, silent = true, expr = true, nowait = true })
    vim.api.nvim_set_keymap('n', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', { noremap = true, silent = true, expr = true, nowait = true })
    vim.api.nvim_set_keymap('i', '<C-f>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', { noremap = true, silent = true, expr = true, nowait = true })
    vim.api.nvim_set_keymap('i', '<C-b>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', { noremap = true, silent = true, expr = true, nowait = true })
    vim.api.nvim_set_keymap('v', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', { noremap = true, silent = true, expr = true, nowait = true })
    vim.api.nvim_set_keymap('v', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', { noremap = true, silent = true, expr = true, nowait = true })
  end

  --Use CTRL-S for selections ranges.
  --Requires 'textDocument/selectionRange' support of language server.
  vim.api.nvim_set_keymap('n', '<C-s>', '<Plug>(coc-range-select)', { silent = true })
  vim.api.nvim_set_keymap('x', '<C-s>', '<Plug>(coc-range-select)', { silent = true })

  vim.cmd [[
    "Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocActionAsync('format')
    "Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)
    "Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
  ]]

  --Add (Neo)Vim's native statusline support.
  --NOTE: Please see `:h coc-status` for integrations with external plugins that
  --provide custom statusline: lightline.vim, vim-airline.
  vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

  --Mappings for CoCList
  --Show all diagnostics.
  vim.api.nvim_set_keymap('n', '<space>a', ':<C-u>CocList diagnostics<cr>', { noremap = true, silent = true, nowait = true })
  --Manage extensions.
  vim.api.nvim_set_keymap('n', '<space>e', ':<C-u>CocList extensions<cr>', { noremap = true, silent = true, nowait = true })
  --Show commands.
  vim.api.nvim_set_keymap('n', '<space>c', ':<C-u>CocList commands<cr>', { noremap = true, silent = true, nowait = true })
  --Find symbol of current document.
  vim.api.nvim_set_keymap('n', '<space>o', ':<C-u>CocList outline<cr>', { noremap = true, silent = true, nowait = true })
  --Search workspace symbols.
  vim.api.nvim_set_keymap('n', '<space>s', ':<C-u>CocList -I symbols<cr>', { noremap = true, silent = true, nowait = true })
  --Do default action for next item.
  vim.api.nvim_set_keymap('n', '<space>j', ':<C-u>CocNext<CR>', { noremap = true, silent = true, nowait = true })
  --Do default action for previous item.
  vim.api.nvim_set_keymap('n', '<space>k', ':<C-u>CocPrev<CR>', { noremap = true, silent = true, nowait = true })
  --Resume latest coc list.
  vim.api.nvim_set_keymap('n', '<space>p', ':<C-u>CocListResume<CR>', { noremap = true, silent = true, nowait = true })

  vim.cmd [[
    let &t_Cs = "\e[4:3m"
    let &t_Ce = "\e[4:0m"
    hi SpellBad gui=undercurl guifg=Red guisp=Red cterm=undercurl ctermfg=Red term=undercurl
    hi CocUnderline gui=undercurl guisp=Red cterm=undercurl ctermfg=Red term=undercurl
  ]]
end

return config
