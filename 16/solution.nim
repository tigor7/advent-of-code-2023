import ../utils
import std/[deques, tables]

type
  Direction = (int, int)

  Beam = object
    pos: (int, int)
    dir: Direction

proc `+`(a, b: (int, int)): (int, int) =
  return (a[0] + b[0], a[1] + b[1])

proc readMatrix*(filename: string): Matrix[char] =
  for line in lines filename:
    var inner: seq[Cell[char]]
    for ch in line:
      inner.add Cell[char](val: ch)
    result.add inner

proc energizedTiles(grid: Matrix[char], initialPos, initialDir: (int, int)): int =
  var
    beams: Deque[Beam]
    seen = newTable[(int, int), (int, int)]()

  beams.addLast(Beam(pos: initialPos, dir: initialDir))

  while beams.len > 0:
    var beam = beams.popFirst()
    while true:
      if not (beam.pos in grid):
        break
      elif beam.pos in seen and seen[beam.pos] == beam.dir:
        break
      else:
        seen[beam.pos] = beam.dir

      case grid.get beam.pos:
      of '|':
        if beam.dir == (0, 1) or beam.dir == (0, -1):
          beams.addLast Beam(pos: beam.pos + (1, 0), dir: (1, 0))
          beams.addLast Beam(pos: beam.pos + (-1, 0), dir: (-1, 0))
          break
      of '-':
        if beam.dir == (1, 0) or beam.dir == (-1, 0):
          beams.addLast Beam(pos: beam.pos + (0, 1), dir: (0, 1))
          beams.addLast Beam(pos: beam.pos + (0, -1), dir: (0, -1))
          break
      of '/':
        let n = (-beam.dir[1], -beam.dir[0])
        beam.dir = n
      of '\\':
        let n = (beam.dir[1], beam.dir[0])
        beam.dir = n
      else:
        discard
      beam.pos = beam.pos + beam.dir
  result = seen.len

proc part1(filename: string): int =
  var grid = readMatrix(filename)
  result = energizedTiles(grid, (0, 0), (0, 1))

proc part2(filename: string): int =
  var grid = readMatrix(filename)

  # First row
  for i in 0 ..< grid[0].len:
    let e = energizedTiles(grid, (0, i), (1, 0))
    if e > result:
      result = e
    let s = energizedTiles(grid, (grid[0].len - 1, i), (-1, 0))
    if s > result:
      result = s

  for i in 0 ..< grid.len:
    let e = energizedTiles(grid, (i, 0), (0, 1))
    if e > result:
      result = e
    let s = energizedTiles(grid, (i, grid.len - 1), (0, -1))
    if s > result:
      result = s

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 7498
  echo ""
  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 7846
