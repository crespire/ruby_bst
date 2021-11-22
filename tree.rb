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
    @size = safe.length
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
    if @root.nil?
      @size += 1
      return @root = Node.new(value)
    end

    if node.nil?
      @size += 1
      return Node.new(value)
    end

    value < node.data ? node.left = insert(value, node.left) : node.right = insert(value, node.right)
    node
  end

  def delete(value, node = @root)
    curr_node = node
    next_node = value < curr_node.data ? curr_node.left : curr_node.right
    is_left = value < curr_node.data

    puts "Current node: #{curr_node.data}"
    puts "Next node: #{next_node.data}"
    puts "Is Left? #{is_left}"

    until value == next_node.data
      delete(value, next_node)
    end

    if next_node.left.nil? & next_node.right.nil?
      curr_node.left = nil if is_left
      curr_node.right = nil unless is_left
    elsif next_node.left.nil? || next_node.right.nil?
      # next node has one child
    end

    curr_node
      
    # I think this one we have recursion, but we have to keep track of two nodes.
    # Remember that my Node class has the mixin Comparable, so I can probably use that here, maybe?

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
