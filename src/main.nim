import std/[
  tables,
  unicode,
  strutils,
  terminal,
]

import
  faststreams,
  faststreams/textio,
  opts,
  sorter


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
    var line = strutils.strip(line)

    # ignore case
    if opt.ignoreCase:
      line = line.toLower()

    # add to seq
    paths.add(line)

  # init sorter
  initSorter()

  # sort paths
  case opt.groupDir:
  of 'f':
    paths.sortPathsGroupDirFirst()
  of 'l':
    paths.sortPathsGroupDirLast()
  of 'n':
    paths.sortPaths()
  else:
    discard

  let stdoutStream = fileOutput(stdout)
  defer: close stdoutStream

  # output result
  for line in paths:
    stdoutStream.write(line & '\n')


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

  # run program
  main()


# parse options
import cligen

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
