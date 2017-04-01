file = File.open 'keymap_test.c'

row_regex = /(\(|^)\s*((\w|,|\s)*)(\\|,|\))/

file.each_line do |l|
  if result = l.match(row_regex)
    p result[2]
  end
end

layers = /(\[\d+\])\s*=\s*KEYMAP/

puts layers.match(file.read).size
