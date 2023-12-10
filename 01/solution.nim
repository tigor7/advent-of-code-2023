import ../utils
import std/[strutils, re, tables]

var lookup = {
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9
}.toTable

proc getNum(num: string): int =
  if num in "0".."9":
    return parseInt(num)
  return lookup[num]


proc part1(filename: string): int =
  for line in lines filename:
    var nums = findAll(line, re"\d")
    result += parseInt(nums[0]) * 10 + parseInt(nums[^1])

proc part2(filename: string): int =
  for line in lines filename:
    var
      nums: seq[string]
      pattern = re"\d|one|two|three|four|five|six|seven|eight|nine"
      bounds = findBounds(line, pattern)

    # Regular findAll only gives non-overlapping values
    while bounds[0] != -1:
      nums.add(line[bounds[0]..bounds[1]])
      bounds = findBounds(line, pattern,
          bounds[0] + 1)
    result += getNum(nums[0]) * 10 + getNum(nums[^1])


when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 54667

  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 54203
