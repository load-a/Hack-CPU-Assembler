require_relative 'assembly_file.rb'
require_relative 'constants.rb'

raise "Please pass a file name." if ARGV[0].nil?

file_name = ARGV[0]

AssemblyFile.new(file_name) 

new_name = file_name.to_s.sub('.asm', '.hack')

IO.write(new_name, AssemblyFile.new(ARGV[0]).to_s.join("\n"))
