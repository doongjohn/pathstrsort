# this program sorts path strings
# - it assumes there are no duplicate file names (in a same directory)
# - it assumes there are no empty directories (everything is a file path)

# TODO:
# - [ ] create flat list directly from the input
# - [ ] implement several sorting options

import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/streams
# import std/os

type Node = ref object
  name: string
  parent: Node
  children: OrderedTable[string, Node]

proc addChild(this: var Node, child: Node): Node =
  if child.name notin this.children:
    child.parent = this
    this.children[child.name] = child
    result = child
  else:
    result = this.children[child.name]

proc new(T: typedesc[Node], name: string): Node =
  Node(
    name: name,
    parent: nil,
    children: initOrderedTable[string, Node]()
  )

var pathSeperator = '/'

proc printTree(root: Node) =
  # use bfs to find all leaf nodes
  var queue = @[root]
  var node: Node

  while queue.len != 0:
    node = queue.pop()
    if node.children.len == 0:
      var repr = node.name
      var parent = node.parent
      while parent != root:
        repr = "{parent.name}{pathSeperator}{repr}".fmt
        parent = parent.parent
      echo repr
    else:
      for _, child in node.children:
        queue.add(child)

# references
# https://towardsdatascience.com/4-types-of-tree-traversal-algorithms-d56328450846

proc toFlatList(root: Node): seq[seq[Node]] =
  result = newSeq[seq[Node]]()

  # use bfs to find all leaf nodes
  var queue = @[root]
  var node: Node

  while queue.len != 0:
    node = queue.pop()
    if node.children.len == 0:
      var parent = node.parent
      result.add(newSeq[Node]())
      result[^1].add(node)
      while parent != root:
        result[^1].insert(parent, 0)
        parent = parent.parent
    else:
      for _, child in node.children:
        queue.add(child)

proc printFlatList(flatList: seq[seq[Node]]) =
  for list in flatList:
    for i, elem in list:
      stdout.write elem.name
      if i != list.high:
        stdout.write pathSeperator
    echo ""

template sortFlatListGroupDirFirst(flatList: var seq[seq[Node]]) =
  flatList.sort do (a, b: seq[Node]) -> int:
    result = 1
    for i in 0 .. min(a.high, b.high):
      if a.high == i and b.high != i: return 1
      if a.high != i and b.high == i: return 0
      if a[i].name > b[i].name: return 1
      if a[i].name < b[i].name: return 0

template sortFlatListGroupDirLast(flatList: var seq[seq[Node]]) =
  flatList.sort do (a, b: seq[Node]) -> int:
    result = 1
    for i in 0 .. min(a.high, b.high):
      if a.high == i and b.high != i: return 0
      if a.high != i and b.high == i: return 1
      if a[i].name > b[i].name: return 1
      if a[i].name < b[i].name: return 0

proc main =
  # for i in 1 .. paramCount():
  #   echo paramStr(i)

  let stdinStream = newFileStream(stdin)
  defer: close stdinStream

  var root = Node.new("root")

  # parse input and create tree structure
  for line in stdinStream.lines:
    let files = line.strip.split(pathSeperator)
    var node = root
    for i, f in files:
      let child = Node.new(f)
      node = node.addChild(child)

  var flatList = root.toFlatList()
  flatList.sortFlatListGroupDirFirst()
  flatList.printFlatList()

main()
