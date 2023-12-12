import ../utils
import std/[strutils, sequtils, algorithm, re]

type
  Record = object
    springs: string
    nums: seq[int]

proc satisfy(springs: string, nums: seq[int]): bool =
  let damaged = findAll(springs, re"[#]+")
  if damaged.len != nums.len:
    return false
  for i in 0..<nums.len:
    if nums[i] != damaged[i].len:
      return false
  return true

proc getCombinations(springs: string): seq[string] =
  let l = springs.filter(proc(x: char): bool = x == '?').len
  var temp: seq[seq[int]]
  for i in 0..<l:
    temp.add(@[0, 1])
  let combs = product(temp)

  for com in combs:
    var
      c = 0
      str = ""
    for spring in springs:
      if spring != '?':
        str.add(spring)
      else:
        if com[c] == 1:
          str.add(".")
        else:
          str.add("#")
        inc c
    result.add(str)





proc readRecords(filename: string): seq[Record] =
  for line in lines filename:
    let
      parse = line.split
      nums = parse[1].split(",").map(proc(x: string): int = parseInt(x))
    result.add Record(springs: parse[0], nums: nums)

proc part1(filename: string): int =
  let records = readRecords(filename)
  for record in records:
    let combs = getCombinations(record.springs)
    for com in combs:
      if satisfy(com, record.nums):
        result += 1




proc part2(filename: string): int =
  discard

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    # assert part1Result == 6947

  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 1129
