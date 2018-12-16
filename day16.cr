input =
  File.read("day16.input")
    .lines

Instructions = %w(addr addi mulr muli banr bani borr bori setr seti gtir gtri gtrr eqir eqri eqrr)
macro addr(reg) {{reg}}[op[1]] + {{reg}}[op[2]] end
macro addi(reg) {{reg}}[op[1]] + op[2] end
macro mulr(reg) {{reg}}[op[1]] * {{reg}}[op[2]] end
macro muli(reg) {{reg}}[op[1]] * op[2] end
macro banr(reg) {{reg}}[op[1]] & {{reg}}[op[2]] end
macro bani(reg) {{reg}}[op[1]] & op[2] end
macro borr(reg) {{reg}}[op[1]] | {{reg}}[op[2]] end
macro bori(reg) {{reg}}[op[1]] | op[2] end
macro setr(reg) {{reg}}[op[1]] end
macro seti(reg) op[1] end
macro gtir(reg) bti op[1] > {{reg}}[op[2]] end
macro gtri(reg) bti {{reg}}[op[1]] > op[2] end
macro gtrr(reg) bti {{reg}}[op[1]] > {{reg}}[op[2]] end
macro eqir(reg) bti op[1] == {{reg}}[op[2]] end
macro eqri(reg) bti {{reg}}[op[1]] == op[2] end
macro eqrr(reg) bti {{reg}}[op[1]] == {{reg}}[op[2]] end

def same(reg, reg2, except)
  (0..3).each do |i|
    next if i == except
    return false if reg[i] != reg2[i]
  end
  true
end

def bti(b)
  b ? 1 : 0
end

matches = 0
start_of_code = 0
op_to_code = Hash(String, Int32).new
code_to_op = Hash(Int32, String).new

i = 0
while op_to_code.size < 16
  input.each_slice(4) do |(before, op, after, _)|
    break unless before.match(/Before/)
    start_of_code += 4
    alts = [] of String
    before = before.split(',').map(&.gsub(/\D/, "")).map &.to_i
    op = op.split.map(&.to_i)
    after = after.split(',').map(&.gsub(/\D/, "")).map &.to_i
    {% for ins in Instructions %}
      if after[op[3]] == {{ ins.id }}(before) && same(after, before, op[3])
        alts << {{ ins }}
      end
    {% end %}
    new_alts = alts - op_to_code.keys
    if new_alts.size == 1
      code_to_op[op[0]] = new_alts.first
      op_to_code[new_alts.first] = op[0]
    end
    matches += 1 if alts.size > 2
  end
  if i == 0
    puts "part1"
    p matches
  end
end

regs = [0, 0, 0, 0]
input[start_of_code..-1].each do |l|
  next if l.empty?
  op = l.split.map &.to_i
  {% begin %}
    case code_to_op[op[0]]
    {% for ins in Instructions %}
      when {{ins}}
        regs[op[3]] = {{ ins.id }}(regs)
    {% end %}
    end
  {% end %}
end
puts "part2"
p regs[0]
