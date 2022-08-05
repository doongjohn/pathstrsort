# Package

version       = "0.1.0"
author        = "doongjohn"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
namedBin["main"] = "pathstrsort"


# Dependencies

requires "nim >= 1.7.1"
requires "faststreams"
requires "cligen"

task release, "release build":
  exec "nim c -o:pathstrsort -d:danger -d:lto --passL:-s src/main.nim"
