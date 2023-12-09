import ../utils
import std/[re, strutils, sequtils]

proc checkZero(nums: seq[int]): bool =
  for num in nums:
    if num != 0:
      return false
  return true

proc rec(nums: seq[int]): int =
  if checkZero(nums):
    return 0
  var diff: seq[int]
  for i in 1..<nums.len:
    diff.add(nums[i] - nums[i-1])
  return nums[^1] + rec(diff)

proc rec2(nums: seq[int]): int =
  if checkZero(nums):
    return 0
  var diff: seq[int]
  for i in 1..<nums.len:
    diff.add(nums[i] - nums[i-1])
  return nums[0] - rec2(diff)

proc part1(filename: string): int =
  for line in lines filename:
    let nums = findAll(line, re"-?\d+").map(proc(x: string): int = parseInt(x))
    result += rec(nums)

proc part2(filename: string): int =
  for line in lines filename:
    let nums = findAll(line, re"-?\d+").map(proc(x: string): int = parseInt(x))
    result += rec2(nums)

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 1934898178

  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 1129
