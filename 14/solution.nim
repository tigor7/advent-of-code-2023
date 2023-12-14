import ../utils

type
  Platform = seq[seq[char]]

proc readPlatform(filename: string): Platform =
  for line in lines filename:
    var inner: seq[char]
    for ch in line:
      inner.add(ch)
    result.add(inner)

proc part1(filename: string): int =
  var platform = readPlatform(filename)
  for i in 0..<platform.len:
    for j in 0..<platform[i].len:
      if platform[i][j] == 'O':
        var k = 0
        while i-k-1 >= 0 and platform[i-k-1][j] == '.':
          inc k
        if k != 0:
          platform[i][j] = '.'
          platform[i-k][j] = 'O'
  for i in 0..<platform.len:
    for j in 0..<platform[i].len:
      if platform[i][j] == 'O':
        result += platform.len - i

proc part2(filename: string): int =
  discard

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 110407
  benchmark "Part 2":
    let part2Result = part2("test.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 1129
