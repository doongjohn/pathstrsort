# this is a nim port of natcompare.js from this repo
# https://github.com/sourcefrog/natsort

# other algorithms
# https://github.com/bubkoo/natsort
# https://github.com/yobacca/natural-orderby

import std/unicode
import opts


# TODO: add ignoreCase option


proc isDigitChar(a: Rune): bool =
  var charCode = a.int32
  if charCode in 48 .. 57:
    return true
  else:
    return false


proc compareRight(a, b: string): int =
  var bias = 0
  var ia = 0
  var ib = 0

  var ca: Rune
  var cb: Rune

  while true:
    defer:
      inc ia
      inc ib

    ca = a.runeAt(ia)
    cb = b.runeAt(ib)
    if not isDigitChar(ca) and not isDigitChar(cb):
      return bias
    if not isDigitChar(ca):
      return -1
    if not isDigitChar(cb):
      return +1
    if ca.int32 < cb.int32:
      if bias == 0:
        bias = -1
    if ca.int32 > cb.int32:
      if bias == 0:
        bias = +1
    if ca.int32 == 0 and cb.int32 == 0:
      return bias


proc cmpNaturalAux(a, b: string): int =
  var
    ia = 0
    ib = 0
    nza = 0
    nzb = 0
    ca: Rune
    cb: Rune

  while true:
    nza = 0
    nzb = 0
    ca = a.runeAt(ia)
    cb = b.runeAt(ib)

    while isWhiteSpace(ca) or ca.int32 == '0'.int32:
      if ca.int32 == '0'.int32:
        inc nza
      else:
        nza = 0
      inc ia
      ca = a.runeAt(ia)

    while isWhiteSpace(cb) or cb.int32 == '0'.int32:
      if cb.int32 == '0'.int32:
        inc nzb
      else:
        nzb = 0
      inc ib
      cb = b.runeAt(ib)

    if isDigitChar(ca) and isDigitChar(cb):
      result = compareRight(a[ia .. ^1], b[ib .. ^1])
      if result != 0:
        return result

    if ca.int32 == 0 and cb.int32 == 0:
      return nza - nzb

    if ca.int32 < cb.int32:
      return -1
    elif ca.int32 > cb.int32:
      return +1

    inc ia
    inc ib

proc cmpNatural*(a, b: string): int =
  result = cmpNaturalAux(a, b)
  if not opt.ascendingOrder:
    result *= -1
