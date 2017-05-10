nvim-term
==
Make neovim's `:terminal` useful.


Installation
--
* To install using dein:
```
[[plugins]]
repo = 'deresmos/nvim-term'
if = '''has('nvim')'''
```


Setting
--
* Enter terminal, set insert mode. *Default 1*
```
let g:nvimterm#enter_insert = 1
```

* Set buffer name of toggle terminal. *Default NVIM_TERM*
```
let g:nvimterm#toggle_tname = 'NVIM_TERM'
```

* Set window size of toggle terminal. *Default 15*
```
let g:nvimterm#toggle_size = 15
```

* Set source directory. *Default script directory* (Run source command, Before open terminal)
```
let g:nvimterm#source_dir = '~/'
```

* Set source file name. *Default .nvimtermrc*
```
let g:nvimterm#source_name = '.nvimtermrc'
```


Usage
--
* Terminal in current window
```
:NTerm
```

* Terminal in split
```
:NTermS
```

* Terminal in vsplit
```
:NTermV
```

* Terminal in tab
```
:NTermT
```

* Terminal toggle. (The toggle terminal is same buffer)
```
:NTermToggle
```

* Delete terminal buffers. If current buffer is *terminal*, it doesn't delete.
```
:NTermDeletes
```

* Delete all terminal buffers.
```
:NTermDeleteAll
```


License
--
Released under the MIT license, see LICENSE.
