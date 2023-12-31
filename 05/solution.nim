import ../utils
import std/[re, strutils, sequtils, parseutils, math]


type
  Map = object
    des: int
    src: int
    ranges: int
  ItemMap = seq[Map]
  Almanac = seq[ItemMap]

proc readAlmanacFromFile(filename: string, almanac: var Almanac, seeds: var seq[int]) =
  let f = open(filename)
  seeds = findAll(readLine(f), re"\d+").map(proc(x: string): int = parseInt(x))
  discard readLine(f)
  var itemMap: ItemMap
  while not endOfFile(f):
    let
      line = readLine(f)
    if line == "":
      almanac.add(itemMap)
      itemMap = @[]
      continue
    let nums = findAll(line, re"\d+")
    if nums.len == 3:
      itemMap.add(Map(des: parseInt(nums[0]), src: parseInt(nums[1]),
          ranges: parseInt(nums[2])))
  # Add last mapper
  almanac.add(itemMap)


proc part1(filename: string): int =
  var
    almanac: Almanac
    seeds: seq[int]
    minLocation = high(int)
    last: int
  readAlmanacFromFile(filename, almanac, seeds)
  for seed in seeds:
    last = seed
    for itemMap in almanac:
      block outer:
        for map in itemMap:
          if map.src <= last and last < map.src + map.ranges:
            last = last - map.src + map.des
            break outer
    if last < minLocation:
      minLocation = last
  return minLocation


proc part2(filename: string): int =
  var
    almanac: Almanac
    seeds: seq[int]
    minLocation = high(int)
    last: int
  readAlmanacFromFile(filename, almanac, seeds)
  var allSeeds: seq[int]
  for i in countup(0, floorDiv(seeds.len, 2), 2):
    for j in seeds[i]..<seeds[i] + seeds[i+1]:
      allSeeds.add(j)
  for seed in allSeeds:
    last = seed
    for itemMap in almanac:
      block outer:
        for map in itemMap:
          if map.src <= last and last < map.src + map.ranges:
            last = last - map.src + map.des
            break outer
    if last < minLocation:
      minLocation = last
  return minLocation


when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 251346198
  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 72263011
  # assert part1TestResult == 13
  # assert part2TestResult == 30

