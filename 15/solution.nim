import ../utils
import std/[strutils]

type
  Lens = object
    label: string
    len: int
  Box = object
    lenses: seq[Lens]
  Boxes = array[256, Box]


proc hash(str: string): int =
  for ch in str:
    result += int(ch)
    result *= 17
    result = result mod 256

proc removeLens(box: var Box, label: string) =
  for i, lens in box.lenses:
    if lens.label == label:
      box.lenses.delete(i)
      return

proc addLens(box: var Box, label: string, len: int) =
  for i, lens in box.lenses:
    if lens.label == label:
      box.lenses[i].len = len
      return
  box.lenses.add(Lens(label: label, len: len))

proc part1(filename: string): int =
  let
    f = open(filename)
    steps = readAll(f).split(",")
  for step in steps:
    result += hash(step)

proc part2(filename: string): int =
  let
    f = open(filename)
    steps = readAll(f).split(",")

  var boxes: Boxes
  for step in steps:
    if step[^1] == '-':
      let
        label = step[0..<step.len-1]
        pos = hash(label)
      removeLens(boxes[pos], label)
    elif step[^2] == '=':
      let
        label = step[0..<step.len-2]
        pos = hash(label)
      addLens(boxes[pos], label, parseInt($step[^1]))

  for i, box in boxes:
    for j, lens in box.lenses:
      result += (i + 1) * (j + 1) * lens.len

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    assert part1Result == 501680
  benchmark "Part 2":
    let part2Result = part2("input.txt")
    echo "Part 2 result is ", part2Result
    assert part2Result == 241094
