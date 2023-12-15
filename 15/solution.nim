import ../utils
import std/[strutils]

proc hash(str: string): int =
  for ch in str:
    result += int(ch)
    result *= 17
    result = result mod 256


proc part1(filename: string): int =
  let
    f = open(filename)
    steps = readAll(f).split(",")
  for step in steps:
    result += hash(step)


proc part2(filename: string): int =
  discard

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 501680
  benchmark "Part 2":
    let part2Result = part2("test.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 0
