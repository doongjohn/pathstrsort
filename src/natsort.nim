# natural sorting algorithm from rosettacode
# https://rosettacode.org/wiki/Natural_sorting#Nim

import std/parseutils
import std/pegs
import std/strutils
import std/unidecode
import opts


type
  Kind = enum
    fString,
    fNumber,

  KeyItem = object
    case kind: Kind
    of fString: str: string
    of fNumber: num: Natural

  Key = seq[KeyItem]


func cmp(a, b: Key): int =
  ## Compare two keys.
  for i in 0 ..< min(a.len, b.len):
    let ai = a[i]
    let bi = b[i]
    if ai.kind == bi.kind:
      result = if ai.kind == fString:
        cmp(ai.str, bi.str)
      else:
        cmp(ai.num, bi.num)
      if result != 0:
        return
    else:
      return if ai.kind == fString: 1 else: -1


proc natOrderKey(s: string): Key =
  ## Return the natural order key for a string.
  # Process 'ʒ' separately as "unidecode" converts it to 'z'.
  var s = s.replace("ʒ", "s")

  # Transform UTF-8 text into ASCII text.
  s = s.unidecode()

  # Remove leading and trailing white spaces.
  s = s.strip()

  # Make all whitespace characters equivalent and remove adjacent spaces.
  s = s.replace(peg"\s+", " ")

  # Switch to lower case.
  if opt.ignoreCase:
    s = s.toLowerAscii()

  # Remove leading "the ".
  if s.startsWith("the ") and s.len > 4: s = s[4..^1]

  # Split into fields.
  var idx = 0
  var val: int
  while idx < s.len:
    var n = s.skipUntil(Digits, start = idx)
    if n != 0:
      result.add KeyItem(kind: fString, str: s[idx..<(idx + n)])
      inc idx, n
    n = s.parseInt(val, start = idx) # FIXME: this can result integerOutOfRangeError
    if n != 0:
      result.add KeyItem(kind: fNumber, num: val)
      inc idx, n


proc cmpNatural*(a, b: string): int =
  ## Natural order comparison function.
  result = cmp(a.natOrderKey, b.natOrderKey)
