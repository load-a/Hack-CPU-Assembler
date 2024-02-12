# Template for assembled operational commands. Used only for C-instructions.
OPERATION_COMMAND = "%<operation>s%<destination>s000"

# Template for assembled jump commands. Used only for C-instructions.
JUMP_COMMAND = "%<operation>s000%<condition>s"

# The default starting address for variables on the Hack CPU.
INITIAL_VARIABLE_ADDRESS = 16

# Binaries for each destination of a C-instruction.
DESTINATION = {
	'0' => 		"000", 
	'M'	=> 		"001",
	'D'	=> 		"010", 
	'DM'	=> 	"011",
	'MD'	=> 	"011",
	'A'	=> 		"100",
	'AM'	=> 	"101",
	'MA'	=> 	"101",
	'AD'	=> 	"110",
	'DA'	=> 	"110",
	'ADM'	=> 	"111",
	'AMD'	=> 	"111",
	'MAD'	=> 	"111",
	'MDA'	=> 	"111",
	'DAM'	=> 	"111",
	'DMA'	=> 	"111",
}

# The binaries for the integer-literal operations.
# @example M=-1
LITERAL_OPERATION = { 
	'0'		=> 		"1110101010", 
	'1'		=> 		"1110111111",
	'-1'	=> 		"1110111010",
}

# The binaries for all Address-only operations.
ADDRESS_OPERATION = {
	'A'		=> 		"1110110000",
	'!A'	=> 		"1110110001",
	'-A'	=> 		"1111110011",
	'A+1'	=> 		"1110110111",
	'A-1'	=> 		"1110110010",
}

# The binaries for all Data Register operations.
DATA_OPERATION = {
	'D'		=> 		"1110001100",
	'!D'	=> 		"1110001101",
	'-D'	=> 		"1110001111",
	'D+1'	=> 		"1110011111",
	'D-1'	=> 		"1110001110",

	'D+A'	=> 		"1110000010",
	'A+D'	=> 		"1110000010",
	'A-D'	=> 		"1110000111", 
	'D-A'	=> 		"1110010011",
	'D&A'	=> 		"1110000000",
	'A&D'	=> 		"1110000000",
	'D|A'	=> 		"1110010101",
	'A|D'	=> 		"1110010101",

	'M+D'	=> 	"1111000010",
	'D+M'	=> 	"1111000010",
	'M-D'	=> 	"1111000111",
	'D-M'	=> 	"1111010011",
	'D&M'	=> 	"1111000000",
	'M&D'	=> 	"1111000000",
	'D|M'	=> 	"1111010101",
	'M|D'	=> 	"1111010101",
}

# The binaries for all Memory(value)-only operations.
MEMORY_OPERATION = {
	'M' 	=>	"1111110000",
	'!M'	=> 	"1111110001",
	'-M'	=> 	"1111110011",
	'M+1'	=> 	"1111110111",
	'M-1'	=> 	"1111110010",
}

# A quick reference to any operation binaries. These are used in both types of instruction.
ANY_OPERATION = MEMORY_OPERATION.merge(DATA_OPERATION, ADDRESS_OPERATION, LITERAL_OPERATION)

# The binaries for every jump condition.
JUMP_TYPE = {
	'JGT' => 	"001",
	'JEQ' =>	"010",
	'JGE' =>	"011", 
	'JLT' => 	"100",
	'JNE' => 	"101",
	'JLE' => 	"110",
	'JMP' => 	"111"
}

# The binary representations for each of Hack Assembly's reserved words.
RESERVED_WORD = {
	"@R0" =>  	"0000000000000000",
	"@R1" =>  	"0000000000000001",
	"@R2" =>  	"0000000000000010",
	"@R3" =>  	"0000000000000011",
	"@R4" =>  	"0000000000000100",
	"@R5" =>  	"0000000000000101",
	"@R6" =>  	"0000000000000110",
	"@R7" =>  	"0000000000000111",
	"@R8" =>  	"0000000000001000",
	"@R9" =>  	"0000000000001001",
	"@R10" => 	"0000000000001010",
	"@R11" => 	"0000000000001011",
	"@R12" => 	"0000000000001100",
	"@R13" => 	"0000000000001101",
	"@R14" => 	"0000000000001110",
	"@R15" => 	"0000000000001111",
	"@SP" =>		"0000000000000000",
	"@LCL" =>		"0000000000000001",
	"@ARG" =>		"0000000000000010",
	"@THIS" =>	"0000000000000011",
	"@THAT" =>	"0000000000000100",

	"@SCREEN" =>	 	"0100000000000000",
	"@KBD" =>	 			"0110000000000000",	
}

# This appears longer then the list provided in the book. This is because
# I have accounted for commutative operations, which is not necessary for the project.
