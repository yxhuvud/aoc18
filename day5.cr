input =
  File.read("day5.input")
  .strip
  .chars

def react(input)
  reacted = typeof(input).new
  input.each do |c|
    if reacted.size > 0 && reacted.last.downcase == c.downcase && reacted.last != c 
      reacted.pop
    else
      reacted.push c
    end
  end
  reacted.size
end

puts "part1"
puts react(input)

chars_to_test = input.map(&.downcase).uniq
res = chars_to_test.min_of do |chr|
  inp = input.dup
  inp.delete chr
  inp.delete chr.upcase
  react(inp)
end

puts "part2"
puts res
