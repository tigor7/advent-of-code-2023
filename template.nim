import utils

proc part1(filename: string): int =
  discard

proc part2(filename: string): int =
  discard

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("test.txt")
    echo "Part 1 result is ", part1Result
    # assert part1Result == 0
  benchmark "Part 2":
    let part2Result = part2("test.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 0
