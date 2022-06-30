# this program sorts path strings
# - it assumes there are no duplicate file names (in a same directory)
# - it assumes there are no empty directories

# TODO:
# - [ ] implement several sorting options

import std/algorithm
import std/strutils
import std/tables
import std/streams
# import std/os

var pathSeperator =
  when defined(windows):
    '\\'
  else:
    '/'

template sortPathsGroupDirFirst(paths: var seq[string]) =
  paths.sort do (a, b: string) -> int:
    result = 1
    let aSepCount = a.count(pathSeperator)
    let bSepCount = b.count(pathSeperator)
    if aSepCount != 0 and bSepCount != 0:
      let aUntilLastSep = a[0 .. a.rfind(pathSeperator)]
      let bUntilLastSep = b[0 .. b.rfind(pathSeperator)]
      if b.startsWith(aUntilLastSep): return 1
      if a.startsWith(bUntilLastSep): return 0
    if aSepCount + bSepCount != 0:
      if aSepCount == 0: return 1
      if bSepCount == 0: return 0
    if a > b: return 1
    if a < b: return 0

template sortPathsGroupDirLast(paths: var seq[string]) =
  paths.sort do (a, b: string) -> int:
    result = 1
    let aSepCount = a.count(pathSeperator)
    let bSepCount = b.count(pathSeperator)
    if aSepCount != 0 and bSepCount != 0:
      let aUntilLastSep = a[0 .. a.rfind(pathSeperator)]
      let bUntilLastSep = b[0 .. b.rfind(pathSeperator)]
      if b.startsWith(aUntilLastSep): return 0
      if a.startsWith(bUntilLastSep): return 1
    if aSepCount + bSepCount != 0:
      if aSepCount == 0: return 0
      if bSepCount == 0: return 1
    if a > b: return 1
    if a < b: return 0

proc main =
  # for i in 1 .. paramCount():
  #   echo paramStr(i)

  let stdinStream = newFileStream(stdin)
  defer: close stdinStream

  var paths: seq[string]
  for line in stdinStream.lines:
    paths.add(strip(line))

  paths.sortPathsGroupDirFirst()
  for line in paths:
    echo line

main()
