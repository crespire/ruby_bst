# frozen_string_literal: true

class Node
  include Comparable
  attr_accessor :left, :right, :data

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other_node)
    @data <=> other_node.data
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    safe = prep_array(array)
    @root = build_tree(safe)
  end

  def build_tree(array)
    return nil if array.empty?
    return Node.new(array.first) if array.length == 1

    mid = 0 + array.length / 2
    root_node = Node.new(array[mid])
    root_node.left = build_tree(array.take(mid))
    root_node.right = build_tree(array.drop(mid + 1))

    root_node
  end

  def insert(value, node = @root)
    return @root = Node.new(value) if @root.nil?
    return Node.new(value) if node.nil?

    value < node.data ? node.left = insert(value, node.left) : node.right = insert(value, node.right)
    node
  end

  def delete(value, node = @root)
    # I think this one we have recursion, but we have to keep track of two nodes.
    # Remember that my Node class has the mixin Comparable, so I can probably use that here.

    # 3 cases we must handle
    # no children, just set previous node pointer to nil
    # one child, set previous node pointer to current node child
    # two children, find left most child
    #  save reference to current node's right child
    #  set left most child's parent pointer to nil
    #  replace current node with smallest child
    #  update new current node to point to old right child
  end

  def find(value, node = @root)
    return nil if node.nil?
    return node if node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def prep_array(array)
    array.uniq.sort
  end
end
