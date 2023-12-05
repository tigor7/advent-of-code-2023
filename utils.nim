import std/[strutils, times, os]

template benchmark*(benchmarkName: string, code: untyped) =
  block:
    let t0 = epochTime()
    code
    let elapsed = epochTime() - t0
    let elapsedStr = elapsed.formatFloat(format = ffDecimal, precision = 8)
    echo "CPU Time [", benchmarkName, "] ", elapsedStr, "s"
