# this program sorts path strings
# - it assumes there are no duplicate file names (in a same directory)
# - it assumes there are no empty directories

import std/tables
import std/strutils
import std/terminal
import faststreams
import faststreams/textio
import opts
import sorter
import cligen


proc main =
  if stdin.isatty():
    echo "error: you need to pass input via pipe"
    echo "       for example: fd -t=f | pathstrsort"
    quit(1)

  let stdinStream = fileInput(stdin)
  defer: close stdinStream

  # read input
  var paths: seq[string]
  for line in stdinStream.lines:
    var line = line
    line.stripLineEnd()
    paths.add(line)

  # sort paths
  case opt.groupDir:
  of 'f':
    paths.sortPathsGroupDirFirst(opt.seperator)
  of 'l':
    paths.sortPathsGroupDirLast(opt.seperator)
  of 'n':
    paths.sortPaths()
  else:
    discard

  let stdoutStream = fileOutput(stdout)
  defer: close stdoutStream

  # output result
  for line in paths:
    stdoutStream.write(line)
    stdoutStream.write('\n')


proc entry(
  seperator = '\0',
  groupDir = 'f',
  ignoreCase = true,
  naturalSorting = true,
  ascendingOrder = true,
) =
  # apply options
  if seperator != '\0':
    opt.seperator = seperator
  else:
    opt.seperator = when defined(windows): '\\' else: '/'

  if groupDir in "fln":
    opt.groupDir = groupDir
  else:
    echo "error: invalid option for groupDir"
    echo "       must be one of ['f', 'l', 'n']"
    quit(1)

  opt.ignoreCase = ignoreCase
  opt.naturalSorting = naturalSorting
  opt.ascendingOrder = ascendingOrder

  # init sorter
  initSorter()

  # run program
  main()


# parse options
dispatch entry, cmdName = "pathstrsort", help = {
  "seperator": """
set path seperator
  default for windows     = '\'
  default for non-windows = '/'""",

  "groupDir": """
set directory grouping option
  f => group first (group before files)
  l => group last  (group after files)
  n => no grouping""",
}
