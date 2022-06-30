# pathstrsort

this program sorts path strings

- it assumes there are no duplicate file names (in a same directory)
- it assumes there are no empty directories

exampe: sorting `nim/nimdoc/`

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
./test_out_index_dot_html/expected/theindex.html
./test_out_index_dot_html/expected/index.html
./test_out_index_dot_html/expected/foo.idx
./test_out_index_dot_html/foo.nim
./testproject/expected/subdir/subdir_b/utils.idx
./testproject/expected/subdir/subdir_b/utils.html
./testproject/expected/theindex.html
./testproject/expected/testproject.idx
./testproject/expected/testproject.html
./testproject/expected/nimdoc.out.css
./testproject/subdir/subdir_b/utils_overview.rst
./testproject/subdir/subdir_b/utils_helpers.nim
./testproject/subdir/subdir_b/utils.nim
./testproject/testproject.nimble
./testproject/testproject.nim
./tester.nim
./rsttester.nim
```
