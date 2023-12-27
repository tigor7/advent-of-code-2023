import ../utils

const moves = [(-1, 0), (0, 1), (1, 0), (0, -1)]

proc readGarden(filename: string): seq[seq[char]] =
  for line in lines filename:
    var inner: seq[char]
    for ch in line:
      inner.add ch
    result.add inner

proc part1(filename: string): int =
  let garden = readGarden(filename)

  var
    curr: seq[(int, int)]
    next: seq[(int, int)]

  for i in 0 ..< garden.len:
    for j in 0 ..< garden[i].len:
      if garden[i][j] == 'S':
        curr.add (i, j)

  for _ in 0 ..< 64:
    for c in curr:
      for move in moves:
        let n = c + move
        if n[0] >= 0 and n[1] >= 0 and n[0] < garden.len and n[1] < garden[
            0].len and garden[n[0]][n[1]] != '#' and n notin next:
          next.add n
    curr = next
    next = @[]
  result = curr.len

proc part2(filename: string): int =
  discard

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    # assert part1Result == 0
  echo ""
  benchmark "Part 2":
    let part2Result = part2("test.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 0
