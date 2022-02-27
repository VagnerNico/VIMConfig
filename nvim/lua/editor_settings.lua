function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

--Tab display size
vim.opt.tabstop = 2
--Check for the file type and properly indent
vim.cmd('filetype plugin indent on')
--Highlight code
vim.cmd('syntax sync fromstart')
--Shift width when using the tab key
vim.opt.shiftwidth = 2
--This line enumerate lines
vim.opt.number = true
--Sets relative number for better selection process
vim.opt.relativenumber = true
--Search while you typing
vim.opt.incsearch = true
--Highlight search results
vim.opt.hlsearch = true
--Use spaces with the TAB command
vim.opt.expandtab = true
--Backspace respect the indentation
vim.opt.softtabstop = 2

vim.opt.termguicolors = true

--Remap leader key
vim.g.mapleader = ","

--Changing colorscheme
vim.cmd('colorscheme dracula')
