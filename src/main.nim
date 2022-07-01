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

proc startsWith(str: string, prefix: openArray[char]): bool =
  if prefix.len > str.len:
    return false

  for i in 0 .. str.high:
    if prefix.high == i:
      return true
    if str[i] != prefix[i]:
      return false

template sortPathsGroupDirFirst(paths: var seq[string]) =
  paths.sort do (a, b: string) -> int:
    let aSepCount = a.count(pathSeperator)
    let bSepCount = b.count(pathSeperator)
    if aSepCount != 0 and bSepCount != 0:
      if b.startsWith(a.toOpenArray(0, a.rfind(pathSeperator))): return 1
      if a.startsWith(b.toOpenArray(0, b.rfind(pathSeperator))): return 0
    if aSepCount + bSepCount != 0:
      if aSepCount == 0: return 1
      if bSepCount == 0: return 0
    if a > b: return 1
    if a < b: return 0
    result = 1

template sortPathsGroupDirLast(paths: var seq[string]) =
  paths.sort do (a, b: string) -> int:
    let aSepCount = a.count(pathSeperator)
    let bSepCount = b.count(pathSeperator)
    if aSepCount != 0 and bSepCount != 0:
      if b.startsWith(a.toOpenArray(0, a.rfind(pathSeperator))): return 0
      if a.startsWith(b.toOpenArray(0, b.rfind(pathSeperator))): return 1
    if aSepCount + bSepCount != 0:
      if aSepCount == 0: return 0
      if bSepCount == 0: return 1
    if a > b: return 1
    if a < b: return 0
    result = 1

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
