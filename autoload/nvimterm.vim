let s:enter_insert = get(g:, 'nvimterm#enter_insert', 1)
let s:enable_keymap = get(g:, 'nvimterm#enable_keymap', 1)
let s:toggle_tname = get(g:, 'nvimterm#toggle_tname', 'NVIM_TERM')
let s:toggle_tname = 'term://' . s:toggle_tname
let s:toggle_size = get(g:, 'nvimterm#toggle_size', 15)
let s:source_dir = get(g:, 'nvimterm#source_dir', '')
let s:source_name = get(g:, 'nvimterm#source_name', '.nvimtermrc')
let s:term_ft = get(g:, 'nvimterm#term_filetype', 'nvim-term')

let s:open_source_command = ''
if s:source_dir ==# '' && executable('nvr')
	let s:open_source_command = 'source ' . expand('<sfile>:p:h') . '/' . s:source_name
endif

function! s:create_buffer(count, newtype) "{{{1
	let l:newtype = ['new', 'vnew', 'tabnew', 'enew']
	let l:cmd = l:newtype[a:newtype]
	let l:cmd = a:count ? a:count . l:cmd : l:cmd
	execute l:cmd
endfunction

function! nvimterm#set_autocmd() "{{{1
	augroup nvimterminal
		autocmd!

		if s:enter_insert == 1
			autocmd BufEnter term://* startinsert
		endif
    autocmd BufEnter term://* call nvimterm#check_source()
	augroup END
endfunction

function! s:set_keymap() "{{{1
	if s:enable_keymap == 1
		nnoremap <l:buffer> <C-q> :bdelete!<CR>
		nnoremap <l:buffer> I i<C-a>
		nnoremap <l:buffer> A a<C-e>
		nnoremap <l:buffer> dd i<C-e><C-u><C-\><C-n>
		nnoremap <l:buffer> cc i<C-e><C-u>
	endif
endfunction

function! nvimterm#open(args, count, newtype, ...) " {{{1
	call s:create_buffer(a:count, a:newtype)

	let l:ft = get(a:, '1', s:term_ft)
	execute 'setfiletype' l:ft

	let l:id = termopen(&shell)
	if s:open_source_command !=# ''
		call jobsend(l:id, s:open_source_command . "\<C-m>\<C-l>")
    let b:is_run_nvimterm_source = 1
	endif
	if a:args !=# ''
		call jobsend(l:id, a:args . "\<C-m>")
	endif
	startinsert
	call s:set_keymap()
endfunction

function! s:run_source(job_id) "{{{1
  let l:job_id = get(a:, 'job_id', b:terminal_job_id)
  if s:open_source_command !=# ''
    call jobsend(l:job_id, s:open_source_command . "\<C-m>\<C-l>")
    let b:is_run_nvimterm_source = 1
  endif
endfunction

function! nvimterm#check_source() "{{{1
  let l:is_run_source = get(l:, 'is_run_nvimterm_source', 0)
  if l:is_run_source == 0
    call s:run_source()
  endif
endfunction

function! nvimterm#delete_buffers(all) "{{{1
	let l:lastbuffer = bufnr('$')
	let l:delete_count = 0
	let l:buffer = a:all ? -1 : bufnr('%')

	for l:n in range(1, l:lastbuffer)
		if l:buffer != l:n && buflisted(l:n)
			if bufname(l:n) =~# 'term://*'
				silent execute 'bdelete! ' . l:n
				let l:delete_count += 1
			endif
		endif
	endfor

	let l:single = 'term deleted'
	let l:multi = 'terms deleted'
	echomsg l:delete_count l:delete_count <= 1 ? l:single : l:multi
endfunction

function! s:close_win_term(filetype) "{{{1
	for l:n in range(1, winnr('$'))
		let l:filetype = getwinvar(l:n, '&filetype')
		if l:filetype ==# a:filetype
			execute l:n . 'wincmd w'
			q
			return 0
		endif
	endfor
	return 1
endfunction

function! nvimterm#toggle(args, count) "{{{1
	let l:ft = s:term_ft . '-t'
	if s:close_win_term(l:ft) == 0
		return 0
	endif

	let l:term_size = a:count ? a:count : s:toggle_size

	for l:n in range(1, bufnr('$'))
		let l:buffer_name = bufname(l:n)
		if l:buffer_name ==# s:toggle_tname
			execute 'silent!' l:term_size 'new' s:toggle_tname
			startinsert
			return 0
		endif
	endfor

	call nvimterm#open(a:args, l:term_size, 0, l:ft)
	stopinsert
	execute 'silent! keepalt file' s:toggle_tname
	startinsert
endfunction
" }}}1 END functions

call nvimterm#set_autocmd()
