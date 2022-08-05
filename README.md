# pathstrsort

this program sorts path strings

- it assumes there are no duplicate file names (in a same directory)
- it assumes there are no empty directories

```
Usage:
  pathstrsort [optional-params]
Options:
  -h, --help                          print this cligen-erated help
  --help-syntax                       advanced: prepend,plurals,..
  -s=, --seperator=     char  '\x00'  set path seperator
                                        default for windows     = '\'
                                        default for non-windows = '/'
  -g=, --groupDir=      char  'f'     set directory grouping option
                                        f => group first (group before files)
                                        l => group last  (group after files)
                                        n => no grouping
  -i, --ignoreCase      bool  true    set ignoreCase
  -n, --naturalSorting  bool  true    set naturalSorting
  -a, --ascendingOrder  bool  true    set ascendingOrder
```

**example**: sorting [`nim/nimdoc/`](https://github.com/nim-lang/Nim/tree/devel/nimdoc)

`fd -t=f`
```
./rst2html/expected/rst_examples.html
./rst2html/source/rst_examples.rst
./rsttester.nim
./test_out_index_dot_html/expected/foo.idx
./test_out_index_dot_html/expected/index.html
./test_out_index_dot_html/expected/theindex.html
./test_out_index_dot_html/foo.nim
./tester.nim
./testproject/expected/nimdoc.out.css
./testproject/expected/subdir/subdir_b/utils.html
./testproject/expected/subdir/subdir_b/utils.idx
./testproject/expected/testproject.html
./testproject/expected/testproject.idx
./testproject/expected/theindex.html
./testproject/subdir/subdir_b/utils.nim
./testproject/subdir/subdir_b/utils_helpers.nim
./testproject/subdir/subdir_b/utils_overview.rst
./testproject/testproject.nim
./testproject/testproject.nimble
```

`fd -t=f | pathstrsort`
```
./rst2html/expected/rst_examples.html
./rst2html/source/rst_examples.rst
./test_out_index_dot_html/expected/foo.idx
./test_out_index_dot_html/expected/index.html
./test_out_index_dot_html/expected/theindex.html
./test_out_index_dot_html/foo.nim
./testproject/expected/subdir/subdir_b/utils.html
./testproject/expected/subdir/subdir_b/utils.idx
./testproject/expected/nimdoc.out.css
./testproject/expected/testproject.html
./testproject/expected/testproject.idx
./testproject/expected/theindex.html
./testproject/subdir/subdir_b/utils.nim
./testproject/subdir/subdir_b/utils_helpers.nim
./testproject/subdir/subdir_b/utils_overview.rst
./testproject/testproject.nim
./testproject/testproject.nimble
./rsttester.nim
./tester.nim
```
