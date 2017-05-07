let s:enter_insert = get(g:, 'nvimterm#enter_insert', 1)
let s:enable_keymap = get(g:, 'nvimterm#enable_keymap', 1)

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

	exe 'terminal' a:args
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
" }}}1 END functions

call s:set_autocmd()
