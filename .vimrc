" Configured by Itsnexn (itsnexn.xyz) for vim 8+
" Repository: https://github.com/itsnexn/dotfiles

let minimalvim = 0

if ! minimalvim
    ru! ftplugin/man.vim
endif

" ---------------------- Options and Global settings ---------------------------

set nocompatible
set path+=**/*

if $TERM != "linux"
	set term=xterm " fix c-left c-right in command mode
	set termguicolors
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	let &t_SI.="\e[5 q" " SI = INSERT mode
	let &t_SR.="\e[4 q" " SR = REPLACE mode
	let &t_EI.="\e[1 q" " EI = NORMAL mode (ELSE)
	set cursorline
endif

if has("clipboard")
    set clipboard=unnamedplus
endif

if v:version >= 800
	set foldmethod=manual
	set nofixendofline
	set nofoldenable

	if $TERM == "linux"
		" ascii friendly chars
		set listchars=tab:\|\ ,nbsp:*
	else
		set listchars=tab:\|\ ,space:∙,nbsp:∙
	endif
endif

" core
set autoread
set autowrite
set belloff="all"
set completeopt=menu,menuone,noselect
set hidden
set history=100
set ignorecase
set mouse=a
set shortmess=at
set smartcase
set spelllang="en"
set ttyfast
set updatetime=100

" User interface
set background=dark
set hlsearch
set incsearch
set laststatus=2
set number
set numberwidth=3
set pumheight=15
set relativenumber
set ruler
set scrolloff=6
set showcmd
set showmode
set signcolumn=yes
set splitbelow
set splitright
set wildmenu
set wildmode=full
set wrap

" text format
set autoindent
set shiftwidth=4
set smartindent
set smarttab
set tabstop=4
set colorcolumn=80
set textwidth=80

" grep
set grepformat="%f:%l:%c:%m"
set grepprg="rg --no-ignore --vimgrep --color=never --trim""

" leader
let mapleader = "\<space>"

if has("syntax")
    syntax on
endif

" --------------------------------- Functions ----------------------------------

function! <SID>SynStack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function MdConvertLinks()
	sil! %s/\[\[\([A-z0-9-_\?\!@$:. ]\+\)\]\]/[\1](\1)
	sil! %s/\[\[\([A-z0-9-_\?\!@$:. ]\+\)|\([A-z0-9\-_. ]\+\)\]\]/[\2](\1)
	noh
endfunction

" ------------------------------- Key Bindings ---------------------------------

" sort stuff in visual mode
if executable('sort')
	vmap s :!sort<CR>
endif

" make Y consitent with D and C
map Y y$

" Save curosr position when doing J
nnoremap J mzJ`z

" Easier movemnent between splits
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Resizing windows
nnoremap <C-M-j> :resize -2<CR>
nnoremap <C-M-k> :resize +2<CR>
nnoremap <C-M-h> :vertical-resize -2<CR>
nnoremap <C-M-l> :vertical-resize +2<CR>

" Move lines in visual mode
vnoremap <S-j> :m '>+1<CR>gv=gv
vnoremap <S-k> :m '<-2<CR>gv=gv

" Edit config file
nnoremap <leader>fe :e $MYVIMRC<CR>

" Buffer actions.
nnoremap <leader>bn bnext
nnoremap <leader>bp bprev
nnoremap <leader>bp bd

" Toggle stuff
map <F1> :set spell!<CR>
map <F2> :set fdm=indent<CR>
map <F3> :set nu!<CR> :set rnu!<CR>
map <F4> :set cul!<CR>
map <F5> :set list!<CR>
map <F12> :so $MYVIMRC<CR>

" show highlight name of the current word
nmap <leader>\ :call <SID>SynStack()<CR>

" Better use of arrow keys, number increment/decrement
nnoremap <up> <C-a>
nnoremap <down> <C-x>

" Better page down and page up
noremap <C-n> <C-d>
noremap <C-p> <C-b>

" disable search highlighting with <C-L> when refreshing screen
nnoremap <C-L> :nohl<CR><C-L>

" ------------------------------- AutoCommands ---------------------------------

" start at last place you were editing
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" filetype auto commands
au Filetype html,css,scss setlocal ts=2 sw=2
au Filetype make setlocal  ts=8  sw=8
au Filetype markdown command! MdConvertLinks call MdConvertLinks()
au Filetype markdown,gitcommit ru! macros/justify.vim
au Filetype markdown,gitcommit set cole=2 et tw=72 cc=72 spell

" ------------------------------ UI & Highlights -------------------------------

" highlight trailing spaces as errors
let hits_exclude = ['markdown'] " hits = highlight trailing space
au Filetype * if index(hits_exclude, &ft) < 0 | match Error '\s\+$' | endif

let list_exclude = ['help', 'man', 'markdown']
au Filetype * if index(list_exclude, &ft) < 0 | set list | endif

au FileType * hi SpellBad  gui=underline guifg=#fb4934 ctermfg=darkred
au FileType * hi SpellCap  gui=underline guifg=#fe8019 ctermfg=darkyellow
au FileType * hi SpellRare gui=underline guifg=#fabd2f ctermfg=yellow
au FileType * hi Todo      gui=bold      guifg=#fb4934 ctermfg=darkyellow
au FileType markdown hi mkdLink   gui=underline guifg=#83a598 ctermfg=blue
au FileType markdown hi mkdURL                  guifg=#a89984 ctermfg=gray
au FileType markdown hi mkdHeading gui=bold     guifg=#fb4934 ctermfg=red

" ------------------------------- Status Line ----------------------------------

function Statusline_GitBranch()
	if g:loaded_fugitive
		let l:b = FugitiveHead()
		return len(l:b) > 0 ? '(' . l:b . ')' : ''
	endif
	return ''
endfunction

function Statusline_GitSummary()
	if g:loaded_gitgutter
		let l:gs = GitGutterGetHunkSummary()
		return empty(l:gs) ? '' :
					\ '+' . l:gs[0] . ' ~' . l:gs[1] . ' -' . l:gs[2]
	endif
	return ''
endfunction

function MyStatusLine()
	let l:s =  '%#CursorColumn# %f'
	let l:s .= &modified ? &modifiable ? '+' : '-' : ''
	let l:s .= &readonly ? ' [RO]' : ''
	let l:s .= ' '
	let l:s .= len(&ft) > 0 ? '(' . &ft . ')' : ''
	let l:s .= ' | ' . Statusline_GitBranch() . ' ' . Statusline_GitSummary()
	let l:s .= '%='
	let l:s .= (&fileencoding ? &fileencoding : &encoding)
	let l:s .= ' [' . &fileformat . ']'
	let l:s .= ' | %p%% %l:%c '
	let l:s .= '%#NONE#'
	return l:s
endfunction

set stl=%!MyStatusLine()

" --------------------------------- Plugins ------------------------------------

if filereadable(expand("~/.vim/autoload/plug.vim"))
	call plug#begin()
	Plug 'morhetz/gruvbox'
	Plug 'aymericbeaumet/vim-symlink'
	Plug 'moll/vim-bbye' " vim symlink dependecy
	Plug 'andymass/vim-matchup'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-vinegar'

	if ! minimalvim
		Plug 'ap/vim-css-color'
		Plug 'prabirshrestha/vim-lsp'
		Plug 'prabirshrestha/asyncomplete.vim'
		Plug 'prabirshrestha/asyncomplete-lsp.vim'
		Plug 'prabirshrestha/asyncomplete-file.vim'
		Plug 'godlygeek/tabular'
		Plug 'editorconfig/editorconfig-vim'
		Plug 'airblade/vim-gitgutter'
		Plug 'tpope/vim-commentary'
		Plug 'tpope/vim-fugitive'
		Plug 'tpope/vim-repeat'
		Plug 'junegunn/fzf', { 'do': {->fzf#install()} }
		Plug 'junegunn/fzf.vim'
		Plug 'itspriddle/vim-shellcheck'
		Plug 'junegunn/goyo.vim'
		Plug 'preservim/vim-markdown'
	endif
	call plug#end()

	if has_key(plugs, "vim-markdown")
		let g:vim_markdown_conceal_code_blocks = 0
		let g:vim_markdown_follow_anchor = 1
	endif

	if has_key(plugs, "gruvbox")
		let g:gruvbox_undercurl = 0
		let g:gruvbox_contrast_dark = "high"
		colorscheme gruvbox
	endif

	if has_key(plugs, "fzf") && has_key(plugs, "fzf.vim")
		function! FzfSpellSink(word)
			exe 'normal! "_ciw'.a:word
		endfunction
		function! FzfSpell()
			let suggestions = spellsuggest(expand("<cword>"))
			return fzf#run({'source': suggestions, 'sink':
						\ function("FzfSpellSink"), 'down': 10 })
		endfunction

		nmap <leader>ff :Files<CR>
		nmap <leader>fr :History<CR>
		nnoremap z= :call FzfSpell()<CR>
	endif

	if has_key(plugs, "vim-matchup")
		let g:matchup_matchparen_offscreen = {'method': 'popup'}
	endif

	if has_key(plugs, "asyncomplete.vim")
		let g:asyncomplete_auto_popup = 0
		let g:lsp_async_completion = 1

		" For Vim 8 (<c-@> corresponds to <c-space>)
		imap <c-@> <Plug>(asyncomplete_force_refresh)
		inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
		inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
		inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<CR>"

		" auto close popup menu
		au! CompleteDone * if pumvisible() == 0 | pclose | endif
	endif

	if has_key(plugs, "vim-lsp")
		let g:lsp_preview_float = 1
		let g:lsp_diagnostics_virtual_text_enabled = 0
		let g:lsp_diagnostics_float_cursor = 1

		function! s:on_lsp_buffer_enabled() abort
			setlocal omnifunc=lsp#complete
			if exists('+tagfunc')
				setlocal tagfunc=lsp#tagfunc
			endif
			nmap <buffer> gd <plug>(lsp-definition)
			nmap <buffer> gs <plug>(lsp-document-symbol-search)
			nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
			nmap <buffer> gr <plug>(lsp-references)
			nmap <buffer> gi <plug>(lsp-implementation)
			nmap <buffer> gt <plug>(lsp-type-definition)
			nmap <buffer> <leader>rn <plug>(lsp-rename)
			nmap <buffer> [d <plug>(lsp-previous-diagnostic)
			nmap <buffer> ]d <plug>(lsp-next-diagnostic)
			nmap <buffer> K <plug>(lsp-hover)
			nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
			nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
		endfunction

		aug lsp_install
			au!
			au	User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
		aug END

		if executable('clangd')
			au User lsp_setup call lsp#register_server({
						\ 'name': 'clangd',
						\ 'cmd': {server_info->['clangd', '-background-index']},
						\	'whitelist':   ['c',   'cpp',	'objc',   'objcpp'],
						\ })
		endif
		if executable('vim-language-server')
			" npm install -g vim-language-server
			au User lsp_setup call lsp#register_server({
						\ 'name': 'vim-language-server',
						\ 'cmd': { server_info->['vim-language-server', '--stdio'] },
						\ 'whitelist': ['vim'],
						\ 'initialization_options': {
						\   'vimruntime': $VIMRUNTIME,
						\   'runtimepath': &rtp,
						\ }})
		endif
		if executable('gopls')
			" go install golang.org/x/tools/gopls@latest
			au User lsp_setup call lsp#register_server({
						\ 'name': 'gopls',
						\	'cmd':	 {server_info->['gopls',   '-remote=auto']},
						\ 'allowlist': ['go'],
						\ })
			autocmd BufWritePre *.go LspDocumentFormatSync
		endif
		if executable('pyls')
			" pip install python-lsp-server
			au User lsp_setup call lsp#register_server({
						\ 'name': 'pyls',
						\ 'cmd': {server_info->['pyls']},
						\ 'whitelist': ['python'],
						\ })
		endif
		if executable('texlab')
			" cargo install texlab
			au User lsp_setup call lsp#register_server({
						\'name': 'texlab',
						\'cmd': {server_info->['texlab']},
						\'whitelist': ['tex']
						\})
		endif
	endif
endif
