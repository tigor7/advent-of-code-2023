import ../utils
import std/[strutils, tables, algorithm]

type
  Kind = enum
    single, pair, twoPair, three, full, four, five
  Hand = object
    cards: string
    bid: int
    kind: Kind

var lookup = {
  '2': 2,
  '3': 3,
  '4': 4,
  '5': 5,
  '6': 6,
  '7': 7,
  '8': 8,
  '9': 9,
  'T': 10,
  'J': 11,
  'Q': 12,
  'K': 13,
  'A': 14,

  }.toTable

proc numOfInstances(cards: string, card: char): int =
  for i in cards:
    if i == card:
      result += 1

proc getKind(cards: string): Kind =
  var
    frec = toCountTable(cards)
    first = frec.largest
  if first[1] == 5:
    return Kind.five
  if first[1] == 4:
    return Kind.four

  frec.del(first[0])
  let second = frec.largest
  if first[1] == 3 and second[1] == 2:
    return Kind.full
  if first[1] == 3:
    return Kind.three
  if first[1] == 2 and second[1] == 2:
    return Kind.twoPair
  if first[1] == 2:
    return Kind.pair
  return Kind.single


proc readHands(filename: string): seq[Hand] =
  for line in lines filename:
    let
      str = line.split
      hand = Hand(cards: str[0], bid: parseInt(str[1]), kind: getKind(str[0]))
    result.add hand

proc part1(filename: string): int =
  var hands = readHands(filename)
  hands.sort do (x, y: Hand) -> int:
    if ord(x.kind) != ord(y.kind):
      return cmp(ord(x.kind), ord(y.kind))
    for i in 0..<5:
      if x.cards[i] != y.cards[i]:
        return cmp(lookup[x.cards[i]], lookup[y.cards[i]])


  for i, hand in hands:
    result += hand.bid * (i + 1)

proc part2(filename: string): int =
  discard


when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 253866470

  benchmark "Part 2":
    let part2Result = part2("test.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 72263011
