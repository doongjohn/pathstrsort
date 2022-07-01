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
import cligen

{.experimental:"views".}

# options
var pathSeperator: char

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
  paths.sortPathsGroupDirFirst(pathSeperator)

  # output result
  for line in paths:
    echo line

proc pathstrsort(seperator: char = '\0') =
  # apply options
  if seperator != '\0':
    pathSeperator = seperator
  else:
    pathSeperator = when defined(windows): '\\' else: '/'

  # run program
  main()

# parse options
dispatch pathstrsort, help = {
  "seperator":
    "set path seperator\n" &
    "default value for windows = \'\\\'\n" &
    "default value for linux = \'/\'"
}
