import std/[monotimes, times, macros]

template benchmark*(benchmarkName: string, code: untyped) =
  block:
    let t0 = getMonoTime()
    code
    let elapsed = getMonoTime() - t0
    echo "CPU Time [", benchmarkName, "] ", elapsed.inMilliseconds, " ms"


proc displayMatrix*[T](matrix: seq[seq[T]]) =
  for i in 0..<matrix.len:
    for j in 0..<matrix[i].len:
      stdout.write matrix[i][j], " "
    echo ""

proc inBounds*[T](matrix: seq[seq[T]], i, j: int): bool =
  return i >= 0 and i < matrix.len and j >= 0 and j < matrix[i].len

macro debug*(n: varargs[typed]): untyped =
  result = newNimNode(nnkStmtList, n)
  for i in 0..n.len-1:
    if n[i].kind == nnkStrLit:
      # pure string literals are written directly
      result.add(newCall("write", newIdentNode("stdout"), n[i]))
    else:
      # other expressions are written in <expression>: <value> syntax
      result.add(newCall("write", newIdentNode("stdout"), toStrLit(n[i])))
      result.add(newCall("write", newIdentNode("stdout"), newStrLitNode(": ")))
      result.add(newCall("write", newIdentNode("stdout"), n[i]))
    if i != n.len-1:
      # separate by ", "
      result.add(newCall("write", newIdentNode("stdout"), newStrLitNode(", ")))
    else:
      # add newline
      result.add(newCall("writeLine", newIdentNode("stdout"), newStrLitNode("")))
