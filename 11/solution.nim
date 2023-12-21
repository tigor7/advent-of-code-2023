import ../utils
import std/[strutils, sequtils, deques, tables]

proc readGalaxy(filename: string): seq[seq[char]] =
  for line in lines filename:
    var inner: seq[char]
    for ch in line:
      inner.add(ch)
    result.add(inner)

proc addEmptySpace(galaxy: var seq[seq[char]]) =
  let emptyHor = newSeq[char](galaxy[0].len).map(proc(x: char): char = '.')

  for r in countdown(galaxy.len-1, 0):
    var valid = true
    for c in 0..<galaxy[r].len:
      if galaxy[r][c] == '#':
        valid = false
        break
    if valid:
      galaxy.insert(emptyHor, r)

  for c in countdown(galaxy[0].len-1, 0):
    var valid = true
    for r in 0..<galaxy.len:
      if galaxy[r][c] == '#':
        valid = false
        break
    if valid:
      for r in 0..<galaxy.len:
        galaxy[r].insert('.', c)

proc checkBounds(i, j, sizeI, sizeJ: int): bool =
  return i >= 0 and j >= 0 and i < sizeI and j < sizeJ


proc bfs(galaxy: seq[seq[char]], processed: seq[(int, int)], i, j: int): int =
  var
    processed = processed
    seen: seq[(int, int)]
    next = Deque[(int, int)]()
    dis = newTable[(int, int), int]()

  next.addLast (i, j)
  dis[(i, j)] = 0

  while next.len > 0:
    let (ii, jj) = next.popFirst
    # echo (ii, jj)
    if (ii != i or jj != j) and galaxy[ii][jj] == '#' and (ii, jj) notin
        processed:
      # echo "Here: ", (i, j), ": ", (ii, jj)
      processed.add (ii, jj)
      result += dis[(ii, jj)]
    for (r, c) in [(1, 0), (0, 1), (0, -1)]:
      if checkBounds(ii+r, jj+c, galaxy.len, galaxy[0].len) and (ii+r,
          jj+c) notin seen:
        dis[(ii+r, jj+c)] = dis[(ii, jj)] + 1
        seen.add (ii+r, jj+c)
        next.addLast((ii+r, jj+c))



proc part1(filename: string): int =
  var
    galaxy = readGalaxy(filename)
    procesed: seq[(int, int)]
  addEmptySpace(galaxy)

  for i in 0..<galaxy.len:
    for j in 0..<galaxy[i].len:
      if galaxy[i][j] == '#':
        result += bfs(galaxy, procesed, i, j)
        procesed.add (i, j)



proc part2(filename: string): int =
  discard

when isMainModule:
  var galaxy = readGalaxy("test.txt")
  addEmptySpace(galaxy)
  displayMatrix(galaxy)

  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    # assert part1Result == 1934898178
  echo ""
  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 1129
