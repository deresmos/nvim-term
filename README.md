nvim-term
==
Make neovim's `:terminal` useful.


Setting
--
* Enter terminal set insert mode. (default 1)
```
let g:nvimterm#enter_insert = 1
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
