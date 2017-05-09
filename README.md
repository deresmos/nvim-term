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
* Enter terminal, set insert mode. (default 1)
```
let g:nvimterm#enter_insert = 1
```

* Set buffer name of toggle terminal. (default NVIM_TERM)
```
let g:nvimterm#toggle_tname = 'NVIM_TERM'
```

* Set window size of toggle terminal. (default 15)
```
let g:nvimterm#toggle_size = 15
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
