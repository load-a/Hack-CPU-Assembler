class AssemblyFile

	OPERATION_COMMAND = "%<operation>s%<destination>s000"
	JUMP_COMMAND = "%<operation>s000%<condition>s"
	INITIAL_VARIABLE_ADDRESS = 16

	private

	attr_accessor :raw_file_text, :processed_code, :variable_dictionary, :label_dictionary

	def initialize(file_name)

		self.raw_file_text = File.open(file_name).readlines
		self.processed_code = tokenize

		self.variable_dictionary = Hash.new(0)
		self.label_dictionary = Hash.new(0)

	end

	def extract_code # Removes whitespace and comments
		raw_file_text
						.map {|line| line.sub(/\/{2}.*/, '').strip} # Removes '//' comments and strips any whitespace
						.delete_if { |line| line == "" } 
	end

	def tokenize
		extract_code.map { |e|
				e.include?("@") ? [:a_instruction, e] : [:c_instruction, e]
			}
	end

	def parse_a_instructions

		processed_code.map! { |element|
			token = element[0]
			code = element[1]

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

	def parse_c_instructions

		processed_code.map! { |element|
			token = element[0]
			code = element[1]

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
				code # What if I tokenized this as well?
			end
		}

	end

	def gather_labels # Labels are declared with "()" and referenced with '@'. They are assigned their declaration's line number
		drift_correction = 0

		processed_code.each_with_index { |e, i|
			if e.include?("(")
				label = e.gsub(/[\(\)]/, '')
				label_dictionary[label] = i - drift_correction
				drift_correction += 1
			end
		}

	end

	def gather_variables #Variables are declared and referenced with '@' and they are assigned the first available address in memory
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

	def set_variables
		processed_code.map! { |e|
			variable = e[1..]
			variable_dictionary.include?(variable) ? "%016b" % [variable_dictionary[variable]] : e
		}
	end

	def set_label_references
		processed_code.map! { |e|
			label = e.gsub('@', '')
			label_dictionary.include?(label) ? "%016b" % [label_dictionary[label]] : e
		}
	end

	def remove_label_declarations
		processed_code.delete_if {|e| label_dictionary.include?(e.gsub(/[\(\)]/, ''))}
	end

	public

	def to_s
		parse_a_instructions
		parse_c_instructions
		gather_labels
		gather_variables
		set_variables
		set_label_references
		remove_label_declarations
	end

end

