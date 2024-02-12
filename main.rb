require_relative 'assembly_file.rb'
require_relative 'constants.rb'

raise "Please pass a file name." if ARGV[0].nil?

source_code = ARGV[0]

binary_file = source_code.to_s.sub('.asm', '.hack')

IO.write(binary_file, AssemblyFile.new(source_code).to_s.join("\n"))
