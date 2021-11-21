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
    return Node.new(value) if node.nil?

    value < node.data ? insert(value, node.left) : insert(value, node.right)
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
