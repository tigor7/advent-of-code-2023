import ../utils
import std/[re]

type
  Node = object
    val: string
    left: string
    right: string

proc readNodes(filename: string, nodes: var seq[Node], inst: var string) =
  let f = open(filename)
  inst = readLine(f)
  discard readLine(f)
  while not endOfFile(f):
    let line = findAll(readLine(f), re"\w+")
    nodes.add(Node(val: line[0], left: line[1], right: line[2]))

proc getNode(nodes: seq[Node], val: string): Node =
  for node in nodes:
    if node.val == val:
      return node


proc part1(filename: string): int =
  var
    nodes: seq[Node]
    inst: string
  readNodes(filename, nodes, inst)
  var curr = nodes.getNode("AAA")
  var i = 0
  while true:
    if curr.val == "ZZZ":
      break
    let a = inst[i mod inst.len]
    if a == 'L':
      curr = nodes.getNode(curr.left)
    elif a == 'R':
      curr = nodes.getNode(curr.right)
    inc i
  return i

proc part2(filename: string): int =
  discard

when isMainModule:
  benchmark "Part 1":
    let part1Result = part1("input.txt")
    echo "Part 1 result is ", part1Result
    # assert part1Result == 253866470

  benchmark "Part 2":
    let part2Result = part2("test.txt")
    echo "Part 2 result is ", part2Result
    # assert part2Result == 254494947
