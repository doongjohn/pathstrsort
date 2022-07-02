import std/algorithm
import std/strutils

proc startsWith(str: openArray[char], prefix: openArray[char], prefixLen: int): bool =
  let sLen = str.len
  var i = 0
  while true:
    if i >= prefixLen: return true
    if i >= sLen or str[i] != prefix[i]: return false
    inc i

proc sortPathsAscii*(paths: var seq[string]) {.inline.} =
  paths.sort do (a, b: string) -> int:
    if a > b: return 1
    if a < b: return 0

proc sortPathsGroupDirFirst*(paths: var seq[string], pathSeperator: char) {.inline.} =
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
    if a > b: return 1
    if a < b: return 0

proc sortPathsGroupDirLast*(paths: var seq[string], pathSeperator: char) {.inline.} =
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
    if a > b: return 1
    if a < b: return 0
