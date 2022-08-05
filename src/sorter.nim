import std/algorithm
import std/strutils
import opts
import natsort


proc startsWith(str: openArray[char], prefix: openArray[char], prefixLen: int): bool =
  let sLen = str.len
  var i = 0
  while true:
    if i >= prefixLen: return true
    if i >= sLen or str[i] != prefix[i]: return false
    inc i


var stringSorter:
  proc (a, b: string): int = nil


proc cmpAscii(a, b: string): int =
  var a = a
  var b = b
  if opt.ignoreCase:
    a = a.toLowerAscii()
    b = b.toLowerAscii()

  if a > b:
    result = 1
  elif a < b:
    result = -1
  else:
    result = 0


proc initSorter*() =
  if opt.naturalSorting:
    stringSorter = cmpNatural
  else:
    stringSorter = cmpAscii


proc sortPaths*(paths: var seq[string]) =
  paths.sort stringSorter


proc sortPathsGroupDirFirst*(paths: var seq[string], pathSeperator: char) =
  paths.sort do (a, b: string) -> int:
    let aSepCount = a.count(pathSeperator)
    let bSepCount = b.count(pathSeperator)
    if aSepCount != 0 and bSepCount != 0:
      let aLastSep = a.rfind(pathSeperator)
      let bLastSep = b.rfind(pathSeperator)
      # group directories first
      if aLastSep != bLastSep:
        if a.startsWith(b, bLastSep + 1): return 0
        if b.startsWith(a, aLastSep + 1): return 1
    elif aSepCount != 0 or bSepCount != 0:
      # group directories first
      if aSepCount == 0: return 1
      if bSepCount == 0: return 0
    # sort ascii
    result = stringSorter(a, b)
    if not opt.ascendingOrder:
      result *= -1


proc sortPathsGroupDirLast*(paths: var seq[string], pathSeperator: char) =
  paths.sort do (a, b: string) -> int:
    let aSepCount = a.count(pathSeperator)
    let bSepCount = b.count(pathSeperator)
    if aSepCount != 0 and bSepCount != 0:
      let aLastSep = a.rfind(pathSeperator)
      let bLastSep = b.rfind(pathSeperator)
      # group directories last
      if aLastSep != bLastSep:
        if a.startsWith(b, bLastSep + 1): return 1
        if b.startsWith(a, aLastSep + 1): return 0
    elif aSepCount != 0 or bSepCount != 0:
      # group directories last
      if aSepCount == 0: return 0
      if bSepCount == 0: return 1
    # sort ascii
    result = stringSorter(a, b)
    if not opt.ascendingOrder:
      result *= -1
