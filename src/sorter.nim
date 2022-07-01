import std/algorithm
import std/strutils

{.experimental:"views".}

proc startsWith(str: string, prefix: openArray[char]): bool =
  if prefix.len > str.len:
    return false

  for i in 0 .. str.high:
    if prefix.high == i:
      return true
    if str[i] != prefix[i]:
      return false

proc sortPathsGroupDirFirst*(paths: var seq[string], pathSeperator: char) {.inline.} =
  paths.sort do (a, b: string) -> int:
    let aSepCount = a.count(pathSeperator)
    let bSepCount = b.count(pathSeperator)
    if aSepCount != 0 and bSepCount != 0:
      let aUntilSep = a.toOpenArray(0, a.rfind(pathSeperator))
      let bUntilSep = b.toOpenArray(0, b.rfind(pathSeperator))
      # group directories first
      if aUntilSep != bUntilSep:
        if a.startsWith(bUntilSep): return 0
        if b.startsWith(aUntilSep): return 1
      # sort ascii
      if a > b: return 1
      if a < b: return 0
    # group directories first
    if aSepCount + bSepCount != 0:
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
      let aUntilSep = a.toOpenArray(0, a.rfind(pathSeperator))
      let bUntilSep = b.toOpenArray(0, b.rfind(pathSeperator))
      # group files first
      if aUntilSep != bUntilSep:
        if a.startsWith(bUntilSep): return 1
        if b.startsWith(aUntilSep): return 0
      # sort ascii
      if a > b: return 1
      if a < b: return 0
    # group files first
    if aSepCount + bSepCount != 0:
      if aSepCount == 0: return 0
      if bSepCount == 0: return 1
    # sort ascii
    if a > b: return 1
    if a < b: return 0
