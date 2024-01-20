test_file = ARGV[0]
verification_file = ARGV[1]

puts File.open(test_file).readlines == File.open(verification_file).readlines
