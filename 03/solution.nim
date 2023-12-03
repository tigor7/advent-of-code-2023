import std/strutils

proc readFile(filename: string): seq[seq[char]] =
  for line in lines filename:
    var inner: seq[char]
    for ch in line:
      inner.add(ch)
    result.add(inner)

proc checkSurrodings(sche: seq[seq[char]], seen: seq[seq[bool]], i: int,
    j: int): tuple =
  if i > 0 and not seen[i-1][j] and sche[i-1][j] in '0'..'9':
    return (i-1, j)
  elif j > 0 and not seen[i][j-1] and sche[i][j-1] in '0'..'9':
    return (i, j-1)
  elif i < sche.len - 1 and not seen[i+1][j] and sche[i+1][j] in '0'..'9':
    return (i + 1, j)
  elif j < sche[i].len - 1 and not seen[i][j+1] and sche[i][j+1] in '0'..'9':
    return (i, j+1)
  elif i > 0 and j > 0 and not seen[i-1][j-1] and sche[i-1][j-1] in '0'..'9':
    return (i-1, j-1)
  elif i > 0 and j < sche[i].len - 1 and not seen[i-1][j+1] and sche[i-1][
      j+1] in '0'..'9':
    return (i-1, j+1)
  elif i < sche.len - 1 and j > 0 and not seen[i+1][j-1] and sche[i+1][j-1] in '0'..'9':
    return (i+1, j-1)
  elif i < sche.len - 1 and j < sche[i].len - 1 and not seen[i+1][j+1] and sche[
      i+1][j+1] in '0'..'9':
    return (i+1, j+1)
  return (-1, -1)

proc getNum(sche: seq[seq[char]], seen: var seq[seq[bool]], i, j: int): int =
  var
    strNum = $sche[i][j]
    k = 1
  seen[i][j] = true
  # asume 3 digit number are posible
  while j - k >= 0 and sche[i][j-k] in '0'..'9':
    strNum = sche[i][j-k] & strNum
    seen[i][j-k] = true
    k += 1
  k = 1
  while j + k < sche[i].len and sche[i][j+k] in '0'..'9':
    strNum = strNum & sche[i][j+k]
    seen[i][j+k] = true
    k += 1
  return parseInt(strNum)


proc part1(filename: string): int =
  var
    seen: seq[seq[bool]]
    sche = readFile(filename)
  for i in 0..<sche.len:
    var inner: seq[bool]
    for j in 0..<sche.len:
      inner.add(false)
    seen.add(inner)
  for i in 0..<sche.len:
    for j in 0..<sche[i].len:
      # Check simbol
      if sche[i][j] != '.' and sche[i][j] notin '0'..'9':
        var posFound = checkSurrodings(sche, seen, i, j)
        while posFound[0] != -1 and posFound[1] != -1:
          result += getNum(sche, seen, posFound[0], posFound[1])
          posFound = checkSurrodings(sche, seen, i, j)

proc part2(filename: string): int =
  var
    seen: seq[seq[bool]]
    sche = readFile(filename)
  for i in 0..<sche.len:
    var inner: seq[bool]
    for j in 0..<sche.len:
      inner.add(false)
    seen.add(inner)
  for i in 0..<sche.len:
    for j in 0..<sche[i].len:
      # Check simbol
      if sche[i][j] == '*':
        let firstFound = checkSurrodings(sche, seen, i, j)
        if firstFound == (-1, -1):
          continue
        let
          firstNum = getNum(sche, seen, firstFound[0], firstFound[1])
          secondFound = checkSurrodings(sche, seen, i, j)
        if secondFound == (-1, -1):
          continue
        let secondNum = getNum(sche, seen, secondFound[0], secondFound[1])
        result += firstNum * secondNum
when isMainModule:
  let
    part1Result = part1("input.txt")
    part2Result = part2("input.txt")
  assert part1Result == 526404
  assert part2Result == 84399773

