import std/[re, strutils]

const
  maxRed = 12
  maxGreen = 13
  maxBlue = 14

proc part1(filename: string): int =
  for line in lines filename:
    var
      record = line.split(":")
      id = parseInt(record[0].split[1])
      bag = findAll(record[1], re"\d+ (red|blue|green)")
      valid = true

    for cubes in bag:
      let
        cubeInfo = cubes.split
        amount = parseInt(cubeInfo[0])
      if cubeInfo[1] == "red" and amount > maxRed or cubeInfo[1] == "blue" and
          amount > maxBlue or cubeInfo[1] == "green" and amount > maxGreen:
        valid = false
        break

    if valid:
      result += id


when isMainModule:
  echo "Part1 is ", part1("input.txt")
