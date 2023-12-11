import ../utils
import std/[strutils, math]

const moves = [
  (1, 0),
  (-1, 0),
  (0, 1),
  (0, -1),
  (-1, -1),
  (1, 1),
  (-1, 1),
  (1, -1)
]

proc readFile(filename: string): seq[seq[char]] =
  for line in lines filename:
    var inner: seq[char]
    for ch in line:
      inner.add(ch)
    result.add(inner)

proc getAdjNums(sche: seq[seq[char]], i, j: int): seq[int] =
  var
    seen: seq[(int, int)]
  for (r, c) in moves:
    if (i+r, j+c) in seen:
      continue
    var
      pos = 0
      str = ""
    if sche[i+r][j+c].isDigit:
      # Get start of digit
      while j+c + pos - 1 >= 0 and j + c + pos - 1 < sche[i+r].len and sche[
          i+r][j + c + pos - 1].isDigit:
        dec pos
      while j+c+pos < sche[i+r].len and sche[i+r][j+c+pos].isDigit:
        seen.add((i+r, j+c+pos))
        str.add(sche[i+r][j+c+pos])
        inc pos
      result.add parseInt(str)

proc part1(filename: string): int =
  let sche = readFile(filename)
  for i in 0..<sche.len:
    for j in 0..<sche[i].len:
      if sche[i][j] notin '0'..'9' and sche[i][j] != '.':
        result += sum(getAdjNums(sche, i, j))

proc part2(filename: string): int =
  let sche = readFile(filename)
  for i in 0..<sche.len:
    for j in 0..<sche[0].len:
      if sche[i][j] notin '0'..'9' and sche[i][j] != '.':
        let nums = getAdjNums(sche, i, j)
        if nums.len == 2:
          result += nums[0] * nums[1]


when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 526404

  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 84399773
