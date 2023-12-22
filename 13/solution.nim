import ../utils
import std/[re]

type
  Pattern = seq[seq[char]]

proc readPattern(filename: string): seq[Pattern] =
  let f = open(filename)
  var p: Pattern
  while not endOfFile(f):
    let line = readLine(f)
    var inner: seq[char]
    if line == "":
      result.add p
      p = @[]
      continue
    for ch in line:
      inner.add ch
    p.add inner
  result.add p

proc checkVertical(p: Pattern, x: int, dis: var int): bool =
  result = true
  for i in 0..<p.len:
    for j in x..<p[i].len:
      let offset = j - x + 1
      if x-offset >= 0 and x-offset < p[i].len and p[i][j] != p[i][x-offset]:
        inc dis
        result = false


proc transpose(p: Pattern): Pattern =
  for j in 0..<p[0].len:
    var inner: seq[char]
    for i in 0..<p.len:
      inner.add(p[i][j])
    result.add inner

proc part1(filename: string): int =
  let patterns = readPattern(filename)
  for pattern in patterns:
    var dis = 0
    for x in 1..<pattern[0].len:
      if checkVertical(pattern, x, dis):
        result += x
    let s = transpose(pattern)
    for y in 1..<s[0].len:
      if checkVertical(s, y, dis):
        result += y * 100

proc part2(filename: string): int =
  let patterns = readPattern(filename)
  for pattern in patterns:
    for x in 1..<pattern[0].len:
      var dis = 0
      discard checkVertical(pattern, x, dis)
      if dis == 1:
        result += x
    let s = transpose(pattern)
    for y in 1..<s[0].len:
      var dis = 0
      discard checkVertical(s, y, dis)
      if dis == 1:
        result += y * 100
when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 31739
  echo ""
  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 1129
