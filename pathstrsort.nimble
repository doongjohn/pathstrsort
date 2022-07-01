# Package

version       = "0.1.0"
author        = "doongjohn"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
namedBin["main"] = "pathstrsort"


# Dependencies

requires "nim >= 1.7.1"
requires "cligen"

task release, "release build":
  exec "nim c --cc:clang -d:danger --passL:-s src/main.nim"
