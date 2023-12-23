import ../utils
import std/[tables]

type
  Field = seq[seq[char]]
  LoopInfo = object
    size: int
    corners: seq[(int, int)]

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

proc readField(filename: string): Field =
  for line in lines filename:
    var inner: seq[char]
    for ch in line:
      inner.add ch
    result.add(inner)

proc `+`(a, b: (int, int)): (int, int) =
  result = (a[0] + b[0], a[1] + b[1])

proc `==`(a, b: (int, int)): bool =
  result = a[0] == b[0] and a[1] == b[1]

proc getStartAdj(field: Field, i, j: int): (int, int) =
  for (r, c) in moves:
    if field.inBounds(i + r, j + c) and field[i+r][j+c] != '.':
      let
        ch = field[i+r][j+c]
        pipe = pipeMoves[ch]

      for move in pipe:
        if move + (r, c) == (0, 0):
          return (i, j) + (r, c)

proc traverse(field: Field): LoopInfo =
  var
    first: (int, int)
    c: (int, int)
    p: (int, int)
  for i in 0 ..< field.len:
    for j in 0 ..< field[0].len:
      if field[i][j] == 'S':
        first = (i, j)
        p = (i, j)
        c = getStartAdj(field, i, j)
        inc result.size

  while field[c[0]][c[1]] != 'S':
    let pipe = field[c[0]][c[1]]
    if pipe in "LJ7F":
      result.corners.add c
    for move in pipeMoves[pipe]:
      # Check to not move to the previous node
      if (c + move) != p:
        inc result.size
        p = c
        c = c + move
        break
  # If there are odd corners then 'S' is a corner:
  if result.corners.len mod 2 != 0:
    result.corners.add first

proc part1(filename: string): int =
  let
    field = readField(filename)
    loopInfo = traverse(field)
  result = loopInfo.size div 2

proc part2(filename: string): int =
  # Using Pick's Theorem and the shoelace formula
  let
    field = readField(filename)
    LoopInfo = traverse(field)
    corners = LoopInfo.corners

  var det = 0
  for i in 0 ..< corners.len:
    var
      c1 = i
      c2 = i + 1
    if c1 == corners.len - 1:
      c2 = 0
    det += corners[c1][0] * corners[c2][1] - corners[c2][0] * corners[c1][1]
  let area = abs(det) div 2
  result = area - LoopInfo.size div 2 + 1

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 6947
  echo ""
  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 273
