import ../utils

type
  Image = seq[seq[char]]
  Galaxy = (int, int)
  Empty = (seq[int], seq[int])


proc readImage(filename: string, image: var Image, galaxies: var seq[Galaxy],
    empty: var Empty) =
  var i = 0
  for line in lines filename:
    var
      inner: seq[char]
      isEmpty = true
    for j, ch in line:
      if ch == '#':
        isEmpty = false
        galaxies.add (i, j)
      inner.add(ch)
    if isEmpty:
      empty[0].add(i)
    image.add(inner)
    inc i
  # Check Cols
  for c in 0..<image[0].len:
    var isEmpty = true
    for r in 0..<image.len:
      if image[r][c] == '#':
        isEmpty = false
    if isEmpty:
      empty[1].add(c)

proc part(filename: string, mul: int): int =
  var
    image: Image
    galaxies: seq[Galaxy]
    empty: Empty
  readImage(filename, image, galaxies, empty)
  for i, (r1, c1) in galaxies[0..^2]:
    for (r2, c2) in galaxies[i+1..^1]:
      for r in min(r1, r2)..<max(r1, r2):
        result += (if r in empty[0]: mul else: 1)
      for c in min(c1, c2)..<max(c1, c2):
        result += (if c in empty[1]: mul else: 1)

when isMainModule:
  benchmark "Part 1":
    let part1Result = part("input.txt", 2)
    echo "Part 1 result is ", part1Result
    assert part1Result == 9623138
  echo ""
  benchmark "Part 2":
    let part2Result = part("input.txt", 1000000)
    echo "Part 2 result is ", part2Result
    assert part2Result == 726820169514
