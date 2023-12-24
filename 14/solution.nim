import ../utils

type
  Platform = seq[seq[char]]

proc readPlatform(filename: string): Platform =
  for line in lines filename:
    var inner: seq[char]
    for ch in line:
      inner.add(ch)
    result.add(inner)

proc transpose(p: Platform): Platform =
  for j in 0..<p[0].len:
    var inner: seq[char]
    for i in 0..<p.len:
      inner.add(p[i][j])
    result.add inner

proc reflect(p: Platform): Platform =
  for i in countdown(p.len - 1, 0):
    var inner: seq[char]
    for j in 0..<p[i].len:
      inner.add(p[i][j])
    result.add inner

proc tiltNorth(p: var Platform) =
  for i in 0..<p.len:
    for j in 0..<p[i].len:
      if p[i][j] == 'O':
        var k = 0
        while i-k-1 >= 0 and p[i-k-1][j] == '.':
          inc k
        if k != 0:
          p[i][j] = '.'
          p[i-k][j] = 'O'

proc runCycle(p: var Platform) =
  tiltNorth(p)
  p = transpose(p)
  tiltNorth(p)
  p = transpose(p)
  p = reflect(p)
  tiltNorth(p)
  p = reflect(p)
  p = transpose(p)
  p = reflect(p)
  tiltNorth(p)
  p = reflect(p)
  p = transpose(p)

proc part1(filename: string): int =
  var platform = readPlatform(filename)
  tiltNorth(platform)
  for i in 0..<platform.len:
    for j in 0..<platform[i].len:
      if platform[i][j] == 'O':
        result += platform.len - i

proc part2(filename: string): int =
  var
    tortoise = readPlatform(filename)
    hare = readPlatform(filename)
    left: int
  for cycle in 0 ..< 1000000000:
    if tortoise == hare and cycle != 0:
      left = 1000000000 mod cycle
      break
    runCycle(tortoise)
    runCycle(hare)
    runCycle(hare)

  for _ in 0 ..< left:
    runCycle(tortoise)

  for i in 0..<tortoise.len:
    for j in 0..<tortoise[i].len:
      if tortoise[i][j] == 'O':
        result += tortoise.len - i

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 110407
  echo ""
  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 87273
