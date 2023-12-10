import ../utils
import std/[re, strutils]

const
  maxRed = 12
  maxGreen = 13
  maxBlue = 14

type
  Bag = object
    Red: int
    Green: int
    Blue: int

proc getMaxCubes(cubes: string): Bag =
  for cube in findAll(cubes, re"\d+ (red|green|blue)"):
    let
      parse = cube.split
      value = parseInt(parse[0])
      color = parse[1]
    if color == "red" and value > result.Red:
      result.Red = value
    elif color == "green" and value > result.Green:
      result.Green = value
    elif color == "blue" and value > result.Blue:
      result.Blue = value

proc part1(filename: string): int =
  for line in lines filename:
    let
      record = line.split(":")
      id = parseInt(record[0].split[1])
      bag = getMaxCubes(record[1])
    if bag.Red <= maxRed and bag.Green <= maxGreen and bag.Blue <= maxBlue:
      result += id


proc part2(filename: string): int =
  for line in lines filename:
    let bag = getMaxCubes(line.split(":")[1])
    result += bag.Red * bag.Green * bag.Blue


when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 2085

  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 79315
