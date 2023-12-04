import std/[re, strutils, sequtils, math]

proc readFile(filename: string): seq[(seq[string], seq[string])] =
  for line in lines filename:
    let nums = line.split(":")[1].split("|")
    result.add((findAll(nums[0], re"\d+"), findAll(nums[1], re"\d+")))

proc part1(filename: string): int =
  let cards = readFile(filename)
  for (winNums, cardNums) in cards:
    let
      winNums = winNums # For some reason this line make the code works
      matches = filter(cardNums, proc(x: string): bool = x in winNums).len
    if matches != 0:
      result += 2^(matches - 1)


when isMainModule:
  let
    part1Result = part1("input.txt")

  echo "Part 1 is ", part1Result
