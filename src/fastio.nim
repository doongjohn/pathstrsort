when defined(linux):
  proc write(fd: cint, buffer: pointer, count: int): int {.
    header: "<unistd.h>",
    importc: "write"
  .}

  let newLine = '\n'

template stdoutWriteLine*(str: string) =
  when defined(linux):
    discard write(1.cint, str[0].addr, str.len.cint)
    discard write(1.cint, newLine.addr, 1.cint)
  else:
    stdout.writeLine(str)
