# A class which converts a given '.asm' file into a '.hack' binary executable. All methods here return arrays, 
# 	but none of them accept arguments. This is because each method works on an instance variable, 
# 	rather then the direct output of some previous method. Therefore, they can all be considered to return 
# 	void, in most cases.

class AssemblyFile

	private

	# @!attribute raw_file_text
	# 	The raw file as a list of strings.
	# 	@return [String]
	# @!attribute processed_code
	# 	Initially starts as a tokenized version of the source code, then gets converted into the assembled binary.
	# 	@return [Array]
	# @!attribute variable_dictionary
	# 	Uses a table to store all variables in the code.
	# 	@return [Hash]
	# Uses a table to store all label declarations that appear in the code.
	# @return [Hash]
	attr_accessor :raw_file_text, :processed_code, :variable_dictionary, :label_dictionary

	# @param file_name [String] The path for the file to assemble. Looks for the file in in the working directory by default.
	def initialize(file_name)

		self.raw_file_text = File.open(file_name).readlines
		self.processed_code = tokenize

		self.variable_dictionary = Hash.new(0)
		self.label_dictionary = Hash.new(0)

	end

	# Removes white space and comments.
	# @return [Array<String>]
	def extract_code 
		raw_file_text.map {|line| line.sub(/\/{2}.*/, '').strip} 
								 .delete_if { |line| line == "" } 
	end

	# Takes the extracted code and groups each line with the appropriate Symbol, creating a token.
	# @return [Array]
	def tokenize
		extract_code.map { |instruction|
				instruction.include?("@") ? [:a_instruction, instruction] : [:c_instruction, instruction]
			}
	end

	# Determines whether each token in processed_code is a reserved word, an integer literal, or a label reference.
	# 	It converts the first two types into their snippets of machine code, but passes the third type 
	# 	and everything else as-is to be processed later.
	# @return [Array]
	def parse_a_instructions

		processed_code.map! { |element|
			token, code = element

			next element unless token == :a_instruction and element.kind_of? Array

			if RESERVED_WORD.include? code
				RESERVED_WORD[code]

			elsif code =~ /\@\d+/ # A Numeric literal (i.e. '@57')
				"%016b" % code[1..]

			else # A label reference
				code
			end
		}

	end

	# Determines whether a token in processed_code is an operation, jump or label declaration. 
	# 	It converts the first two types into their snippets of machine code, but passes the third type 
	# 	and everything else as-is to be processed later.
	# @return [Array]
	def parse_c_instructions

		processed_code.map! { |element|
			token, code = element

			next element unless token == :c_instruction and element.kind_of? Array

			if code.include?("=") # then its a Operation command (i.e. 'MDA=D+1')
				code[/([ADM]{1,3})=([\-\!]?[ADM10][\+\-\|\&]?[ADM1]?)/]
				destination = DESTINATION[$1]
				operation = ANY_OPERATION[$2]

				OPERATION_COMMAND % {operation:, destination:}

			elsif code.include?(";") # then it's a Jump command (i.e. 'A+1;JLT')
				code[/([0ADM]);(J.{2})/]
				operation = ANY_OPERATION[$1]
				condition = JUMP_TYPE[$2]
				
				JUMP_COMMAND % {operation:, condition:}

			else # It's a label declaration
				code 
			end
		}

	end

	# Scans the code and marks each label it encounters on the label_dictionary.
	# @note Labels are declared with "()" and referenced with '@'. 
	# @return [Array]
	def gather_label_declarations 
		drift_correction = 0

		processed_code.each_with_index { |e, i|
			if e.include?("(")
				label = e.gsub(/[\(\)]/, '')
				label_dictionary[label] = i - drift_correction
				drift_correction += 1
			end
		}

	end

	# Scans the code for variable declarations and marks them in the variable_dictionary.  
	# 	They are each assigned the first available address in memory.
	# @note Variables are declared and referenced with '@'.
	# @return Array
	def gather_variables 
		variable_address_counter = 0

		processed_code.each { |e|

			next e unless e.include? '@'
			variable = e.gsub('@', '')

			unless label_dictionary.include? variable or variable_dictionary.include? variable
				variable_dictionary[variable] = INITIAL_VARIABLE_ADDRESS + variable_address_counter
				variable_address_counter += 1
			end
		}
	end

	# Converts each variable declaration and reference into its assigned memory address.
	# 	Anything that fails the check is passed over.
	# 	Each address is a 16-bit value. 
	# @return [Array]
	def set_variables
		processed_code.map! { |instruction|
			variable = instruction[1..]
			variable_dictionary.include?(variable) ? "%016b" % [variable_dictionary[variable]] : instruction
		}
	end

	# Assigns each label **reference** into its assigned program counter address.
	# 	Anything that fails the check is passed over.
	# @return [Array]
	def set_label_references
		processed_code.map! { |instruction|
			label = instruction.gsub('@', '')
			label_dictionary.include?(label) ? "%016b" % [label_dictionary[label]] : instruction
		}
	end

	# Removes all label declarations from the code.
	# @return [Array]
	def remove_label_declarations
		processed_code.delete_if {|instruction| label_dictionary.include?(instruction.gsub(/[\(\)]/, ''))}
	end

	public

	# Generates assembly code from the tokenized source.
	# @return [Array<String>]
	def assemble_source_code
		parse_a_instructions
		parse_c_instructions
		gather_label_declarations
		gather_variables
		set_variables
		set_label_references
		remove_label_declarations
	end
	alias to_s assemble_source_code

end

