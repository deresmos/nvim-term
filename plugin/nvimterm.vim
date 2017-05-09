if exists('g:loaded_nvimterm') 
	finish
endif
let g:loaded_nvimterm = 1

command! -nargs=* -count NTermS call nvimterm#open(<q-args>, <count>, 0)
command! -nargs=* -count NTermV call nvimterm#open(<q-args>, <count>, 1)
command! -nargs=* NTermT call nvimterm#open(<q-args>, 0, 2)
command! -nargs=* NTerm call nvimterm#open(<q-args>, 0, 3)

command! -nargs=0 NTermDeletes call nvimterm#delete_buffers(0)
command! -nargs=0 NTermDeleteAll call nvimterm#delete_buffers(1)
command! -nargs=0 -count NTermToggle call nvimterm#toggle(<count>)
