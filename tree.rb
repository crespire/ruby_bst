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
        return temp
      elsif curr_node.right.nil?
        temp = curr_node.left
        curr_node = nil
        return temp
      end

      temp = minValueNode(curr_node.right)
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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def pp
    pretty_print()
  end

  private

  def prep_array(array)
    array.uniq.sort
  end

  def minValueNode(node)
    current = node
    until current.left.nil?
      current = current.left
    end
    current
  end
end
