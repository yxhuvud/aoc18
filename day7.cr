input =
  File.read("day7.input")
    .lines

deps = input.compact_map do |l|
  m = l.match /p (.).*p (.)/
  {m[1], m[2]} if m
end

def dependencies(deps)
  depends_on = {} of String => Set(String)
  deps.map do |(a, b)|
    depends_on[a] ||= Set(String).new
    depends_on[b] ||= Set(String).new
    depends_on[b] << a
  end
  depends_on
end

depends_on = dependencies(deps)
res = [] of String
while !depends_on.empty?
  alts = depends_on.select { |a, ds| ds.empty? }
  k = alts.keys.min
  depends_on.delete(k)
  res << k
  depends_on.values.each { |s| s.delete k }
end

puts "part1"
puts res.join

depends_on = dependencies(deps)
current_time = 0i64
i = 0
jobs = depends_on.select { |a, ds| ds.empty? }.keys.sort
workings = [] of Tuple(Int64, String)

while !depends_on.empty? || workings.any?
  while workings.size < 5 && (job = jobs.shift?)
    done_by = current_time + 60 + (job[0].ord - 'A'.ord + 1)
    workings << {done_by, job}
  end
  workings.sort_by! &.first
  current_time, j = workings.shift
  depends_on.delete(j)
  depends_on.each do |k, s|
    if s.includes? j
      s.delete j
      jobs << k if s.empty?
    end
  end
  jobs.sort!
end
puts "part2"
puts current_time
