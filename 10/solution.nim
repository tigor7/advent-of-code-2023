import ../utils
import std/[deques, tables]

type Map = seq[seq[char]]

const
  north = (-1, 0)
  south = (1, 0)
  east = (0, 1)
  west = (0, -1)

  moves = [north, south, east, west]

var pipeMoves = {
  '|': [north, south],
  '-': [east, west],
  'L': [north, east],
  'J': [north, west],
  '7': [south, west],
  'F': [south, east]
}.toTable



proc readPipes(filename: string): Map =
  for line in lines filename:
    var inner: seq[char]
    for ch in line:
      inner.add(ch)
    result.add(inner)

proc getAdj(map: Map, i, j: int): seq[(int, int)] =
  for (r, c) in moves:
    if map.inBounds(i + r, j + c) and map[i+r][j+c] != '.':
      let
        ch = map[i+r][j+c]
        pipe = pipeMoves[ch]
      for move in pipe:
        if r + move[0] == 0 and c + move[1] == 0:
          result.add((i+r, j+c))

proc part1(filename: string): int =
  let map = readPipes(filename)
  var
    next = initDeque[(int, int)]()
    seen = initTable[(int, int), bool]()
    dis = initTable[(int, int), int]()
  for i in 0..<map.len:
    for j in 0..<map[i].len:
      if map[i][j] == 'S':
        let nums = getAdj(map, i, j)
        dis[(i, j)] = 0
        dis[nums[0]] = 1
        dis[nums[1]] = 1
        next.addLast(nums[0])
        next.addLast(nums[1])
  while next.len > 0:
    let curr = next.popFirst
    for (r, c) in pipeMoves[map[curr[0]][curr[1]]]:
      if (curr[0] + r, curr[1] + c) notin seen and map[curr[0] + r][curr[1] +
          c] != 'S':
        seen[(curr[0] + r, curr[1] + c)] = true
        dis[(curr[0] + r, curr[1] + c)] = dis[(curr[0], curr[1])] + 1
        next.addLast((curr[0] + r, curr[1] + c))
  var max = 0
  for i in 0..<map.len:
    for j in 0..<map[i].len:
      if (i, j) in dis and dis[(i, j)] > max:
        max = dis[(i, j)]

  return max

proc part2(filename: string): int =
  discard

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    # assert part1Result == 1934898178

  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 1129
