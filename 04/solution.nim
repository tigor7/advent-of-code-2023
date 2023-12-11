import ../utils
import std/[re, strutils, sequtils, math, tables]

type
  Card = object
    id: int
    winningNums: seq[string]
    cardNums: seq[string]

iterator cards(filename: string): Card =
  for line in lines filename:
    let
      parsed = line.split(":")
      id = parseInt(parsed[0].splitWhitespace[1])
      nums = parsed[1].split("|")
      winningNums = findAll(nums[0], re"\d+")
      cardNums = findAll(nums[1], re"\d+")
    yield Card(id: id, winningNums: winningNums, cardNums: cardNums)

proc getMatches(card: Card): int =
  return filter(card.cardNums, proc(x: string): bool = x in
      card.winningNums).len

proc part1(filename: string): int =
  for card in cards filename:
    let matches = getMatches(card)
    if matches > 0:
      result += 2^(matches - 1)

proc part2(filename: string): int =
  var
    copies = initTable[int, int]()
  for card in cards filename:
    let
      matches = getMatches(card)
      cardCopies = copies.getOrDefault(card.id)
    for i in 1..matches:
      copies[card.id + i] = copies.getOrDefault(card.id + i) + cardCopies + 1
    result += 1 + cardCopies


when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 26218

  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 9997537
