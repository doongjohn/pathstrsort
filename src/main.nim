# this program sorts path strings
# - it assumes there are no duplicate file names (in a same directory)
# - it assumes there are no empty directories

# TODO:
# - [ ] implement several sorting options

import std/tables
import std/strutils
import std/streams
import std/terminal
import sorter
import fastio
import cligen

# options
var optSeperator: char
var optGroupDir: char

proc main =
  if stdin.isatty():
    echo "error: you need to pass input via pipe"
    echo "       for example: fd -t=f | pathstrsort"
    quit(1)

  let stdinStream = newFileStream(stdin)
  defer: close stdinStream

  # read input
  var paths: seq[string]
  for line in stdinStream.lines:
    paths.add(strip(line))

  # sort paths
  case optGroupDir:
  of 'f':
    paths.sortPathsGroupDirFirst(optSeperator)
  of 'l':
    paths.sortPathsGroupDirLast(optSeperator)
  of 'n':
    paths.sortPathsAscii()
  else:
    discard

  # output result
  for line in paths:
    stdoutWriteLine(line)

proc pathstrsort(
  seperator = '\0',
  groupDir = 'f'
) =
  # apply options
  if seperator != '\0':
    optSeperator = seperator
  else:
    optSeperator = when defined(windows): '\\' else: '/'

  if groupDir in ['f', 'l', 'n']:
    optGroupDir = groupDir
  else:
    echo "error: invalid option for groupDir"
    echo "       must be one of ['f', 'l', 'n']"
    quit(1)

  # run program
  main()

# parse options
dispatch pathstrsort, help = {
  "seperator":
    "set path seperator\n" &
    "  default for windows     = \'\\\'\n" &
    "  default for non-windows = \'/\'",
  "groupDir":
    "set directory grouping option\n" &
    "  (default) f => group first (group before files)\n" &
    "            l => group last  (group after files)\n" &
    "            n => no grouping"
}
