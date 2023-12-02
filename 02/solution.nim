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

proc part2(filename: string): int =
  for line in lines filename:
    var
      bag = findAll(line.split(":")[1], re"\d+ (red|blue|green)")
      minRed = 0
      minGreen = 0
      minBlue = 0

    for cubes in bag:
      let
        cubeInfo = cubes.split
        amount = parseInt(cubeInfo[0])
      if cubeInfo[1] == "red" and amount > minRed:
        minRed = amount
      elif cubeInfo[1] == "green" and amount > minGreen:
        minGreen = amount
      elif cubeInfo[1] == "blue" and amount > minBlue:
        minBlue = amount
    result += minRed * minGreen * minBlue


when isMainModule:
  let
    part1Result = part1("input.txt")
    part2Result = part2("input.txt")

  assert part1Result == 2085
  assert part2Result == 79315
