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
    return Node.new(array[0]) if array.length == 1

    mid = 0 + array.length / 2
    root_node = Node.new(array[mid])
    root_node.left = build_tree(array.take(mid))
    root_node.right = build_tree(array.drop(mid))

    root_node
  end

  private

  def prep_array(array)
    array.uniq.sort    
  end
end