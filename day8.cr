input =
  File.read("day8.input")
    .split
    .map &.to_i

def consume(input, &block : Array(Int32), Array(Int32) -> Int32)
  child_nodes = input.shift
  metadata = input.shift
  children = child_nodes.times.map do
    consume(input, &block).as(Int32)
  end.to_a
  meta = metadata.times.map do
    input.shift
  end.to_a
  block.call(children, meta)
end

puts "part1"
puts consume(input.dup) { |children, metadata| metadata.sum + children.sum }

puts "part2"
s = consume(input.dup) do |children, metadata|
  next metadata.sum if children.none?
  metadata.map { |m| m.zero? ? 0 : children[m - 1]? || 0 }.sum
end
p s
