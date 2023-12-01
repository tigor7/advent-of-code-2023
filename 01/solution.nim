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
    if nums[0] in lookup:
      result += lookup[nums[0]] * 10
    else:
      result += parseInt(nums[0]) * 10

    if nums[^1] in lookup:
      result += lookup[nums[^1]]
    else:
      result += parseInt(nums[^1])


when isMainModule:
  # Test
  assert part1("input.txt") == 54667
  assert part2("input.txt") == 54203
  echo "Test passed"
