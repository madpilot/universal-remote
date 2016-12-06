require 'csv'

# The internet is the best
# https://nobbin.net/tag/yamahanec-ir-codes/
#
def convert(code)
  if code =~ /^([A-F0-9])([A-F0-9])-([A-F0-9])([A-F0-9])$/
    m = Regexp.last_match

    a = '%04b' % m[1].to_i(16)
    b = '%04b' % m[2].to_i(16)
    c = '%04b' % m[3].to_i(16)
    d = '%04b' % m[4].to_i(16)

    byte1 = b.reverse + a.reverse
    byte2 = '%08b' % (0xFF - byte1.to_i(2))
    byte3 = d.reverse + c.reverse
    byte4 = '%08b' % (0xFF - byte3.to_i(2))

    return "0x" + (byte1 + byte2 + byte3 + byte4).to_i(2).to_s(16).upcase
  end

  if code =~ /^([A-F0-9])([A-F0-9])\-([A-F0-9])([A-F0-9])([A-F0-9])([A-F0-9])$/
    m = Regexp.last_match

    a = '%04b' % m[1].to_i(16)
    b = '%04b' % m[2].to_i(16)
    c = '%04b' % m[3].to_i(16)
    d = '%04b' % m[4].to_i(16)
    e = '%04b' % m[5].to_i(16)
    f = '%04b' % m[6].to_i(16)

    byte1 = b.reverse + a.reverse
    byte2 = '%08b' % (0xFF - byte1.to_i(2))
    byte3 = d.reverse + c.reverse
    byte4 = f.reverse + e.reverse

    return "0x" + (byte1 + byte2 + byte3 + byte4).to_i(2).to_s(16).upcase
  end

  if code =~ /^([A-F0-9])([A-F0-9])([A-F0-9])([A-F0-9])\-([A-F0-9])([A-F0-9])$/
    m = Regexp.last_match

    a = '%04b' % m[1].to_i(16)
    b = '%04b' % m[2].to_i(16)
    c = '%04b' % m[3].to_i(16)
    d = '%04b' % m[4].to_i(16)
    e = '%04b' % m[5].to_i(16)
    f = '%04b' % m[6].to_i(16)

    byte1 = b.reverse + a.reverse
    byte2 = d.reverse + c.reverse
    byte3 = f.reverse + e.reverse
    byte4 = '%08b' % (0xFF - byte3.to_i(2))

    return "0x" + (byte1 + byte2 + byte3 + byte4).to_i(2).to_s(16).upcase
  end

  if code =~ /^([A-F0-9])([A-F0-9])([A-F0-9])([A-F0-9])\-([A-F0-9])([A-F0-9])([A-F0-9])([A-F0-9])$/
    m = Regexp.last_match

    a = '%04b' % m[1].to_i(16)
    b = '%04b' % m[2].to_i(16)
    c = '%04b' % m[3].to_i(16)
    d = '%04b' % m[4].to_i(16)
    e = '%04b' % m[5].to_i(16)
    f = '%04b' % m[6].to_i(16)
    g = '%04b' % m[7].to_i(16)
    h = '%04b' % m[8].to_i(16)

    byte1 = b.reverse + a.reverse
    byte2 = d.reverse + c.reverse
    byte3 = f.reverse + e.reverse
    byte4 = h.reverse + g.reverse

    return "0x" + (byte1 + byte2 + byte3 + byte4).to_i(2).to_s(16).upcase
  end
end

# Device,Function Group,Function name,ZONE,Code(ID1),Code(ID2),Comment
#skip = true
#CSV.foreach("rx-v371.csv") do |row|
  #if skip
    #skip = false
    #next
  #end
  #row = row.map { |r| r.to_s.strip }
  #name = row[2]
  #code = row[4]

  #puts "#{name}\t#{convert(code)}"
#end

puts convert("7A-1D")
puts convert("7A-1E")
