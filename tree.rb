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
  attr_accessor :root, :size

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
    return node if node.nil?

    curr_node = node
    if value < curr_node.data
      curr_node.left = delete(value, curr_node.left)
    elsif value > curr_node.data
      curr_node.right = delete(value, curr_node.right)
    else
      if curr_node.left.nil?
        temp = curr_node.right
        curr_node = nil
        @size -= 1
        return temp
      elsif curr_node.right.nil?
        temp = curr_node.left
        curr_node = nil
        @size -= 1
        return temp
      end

      temp = next_min(curr_node.right)
      curr_node.data = temp.data
      curr_node.right = delete(temp.data, curr_node.right)
    end
    curr_node
  end

  def find(value, node = @root)
    return nil if node.nil?
    return node if node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def level_order(node = @root)
    return if node.nil?

    output = []
    queue = []
    queue.push(node)
    until queue.empty?
      current = queue.shift
      output.push(block_given? ? yield(current) : current.data)
      queue.push(current.left) if current.left
      queue.push(current.right) if current.right
    end

    output
  end

  def in_order(node = @root, output = [], &block)
    return if node.nil? # Base case, we have empty node.

    in_order(node.left, output, &block)
    output.push(block_given? ? block.call(node) : node.data)
    in_order(node.right, output, &block)

    output
  end

  def pre_order(node = @root, output = [], &block)
    return if node.nil?

    output.push(block_given? ? block.call(node) : node.data)
    pre_order(node.left, output, &block)
    pre_order(node.right, output, &block)

    output
  end

  def post_order(node = @root, output = [], &block)
    return if node.nil?

    post_order(node.left, output, &block)
    post_order(node.right, output, &block)
    output.push(block_given? ? block.call(node) : node.data)

    output
  end

  def height(node = @root, count = -1)
    return count if node.nil?

    count += 1
    [height(node.left, count), height(node.right, count)].max
  end

  def depth(node)
    return if node.nil?

    curr_node = @root
    count = 0
    until curr_node.data == node.data
      count += 1
      curr_node = curr_node.left if node.data < curr_node.data
      curr_node = curr_node.right if node.data > curr_node.data
    end

    count
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  alias pp pretty_print

  private

  def prep_array(array)
    array.uniq.sort
  end

  def next_min(node)
    current = node
    current = current.left until current.left.nil?
    current
  end
end
