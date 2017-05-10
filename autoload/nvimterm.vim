let s:enter_insert = get(g:, 'nvimterm#enter_insert', 1)
let s:enable_keymap = get(g:, 'nvimterm#enable_keymap', 1)
let s:toggle_tname = get(g:, 'nvimterm#toggle_tname', 'NVIM_TERM')
let s:toggle_tname = 'term://' . s:toggle_tname
let s:toggle_size = get(g:, 'nvimterm#toggle_size', 15)
let s:source_dir = get(g:, 'nvimterm#source_dir', '')
let s:source_name = get(g:, 'nvimterm#source_name', '.nvimtermrc')

let s:open_source_command = ''
if s:source_dir == '' && executable('nvr')
	let s:open_source_command = 'source ' . expand('<sfile>:p:h') . '/' . s:source_name
endif

function! s:create_buffer(count, newtype) "{{{1
	let l:newtype = ['new', 'vnew', 'tabnew', 'enew']
	let cmd = l:newtype[a:newtype]
	let cmd = a:count ? a:count . cmd : cmd
	exe cmd
endfunction

function! s:set_autocmd() "{{{1
	augroup nvimterminal
		autocmd!

		if s:enter_insert == 1
			autocmd BufEnter term://* startinsert
		endif
	augroup END
endfunction

function! s:set_keymap() "{{{1
	nnoremap <buffer> <C-q> :bdelete!<CR>
endfunction

function! nvimterm#open(args, count, newtype) " {{{1
	call s:create_buffer(a:count, a:newtype)

	let id = termopen(&sh)
	if s:open_source_command != ''
		call jobsend(id, s:open_source_command . "\<C-m>\<C-l>")
	endif
	if a:args != ''
		call jobsend(id, a:args . "\<C-m>")
	endif
	startinsert
	call s:set_keymap()
endfunction

function! nvimterm#delete_buffers(all) "{{{1
	let lastbuffer = bufnr('$')
	let delete_count = 0
	let buffer = a:all ? -1 : bufnr('%')

	for n in range(1, lastbuffer)
		if buffer != n && buflisted(n)
			if bufname(n) =~ 'term://*'
				silent exe 'bdelete! ' . n
				let delete_count += 1
			endif
		endif
	endfor

	let single = 'term deleted'
	let multi = 'term deleted'
	echomsg delete_count delete_count <= 1 ? single : multi
endfunction

function! s:closeWinTerm() "{{{1
	for n in range(1, winnr('$'))
		let buffer_type = getwinvar(n, '&buftype')
		if buffer_type ==# 'terminal'
			exe n . 'wincmd w'
			q
			return 0
		endif
	endfor
	return 1
endfunction

function! nvimterm#toggle(count) "{{{1
	if s:closeWinTerm() == 0
		return 0
	endif

	let term_size = a:count ? a:count : s:toggle_size

	for n in range(1, bufnr('$'))
		let buffer_name = bufname(n)
		if buffer_name ==# s:toggle_tname
			exe 'silent!' term_size 'new' s:toggle_tname
			startinsert
			return 0
		endif
	endfor

	call nvimterm#open('', term_size, 0)
	stopinsert
	exe 'silent! keepalt file' s:toggle_tname
	startinsert
endfunction
" }}}1 END functions

call s:set_autocmd()
