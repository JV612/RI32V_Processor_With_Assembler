#include<iostream>
#include<fstream>
#include<map>
#include<string>
#include<vector>
using namespace std;

struct Instruction {
    string opcode;
    string arg1, arg2, arg3;
    int line_number;
    string original_line;
};

string ThreeAddressEncoder(string opcode_bin,string modifierbits,string arg1, string arg2, string arg3) {

    cout << "Encoding: " << opcode_bin << " " << modifierbits << " " << arg1 << " " << arg2 << " " << arg3 << endl;

    string isImmediate = "";

    string op1 = "";

    if(arg1[0]!='R') {
        cerr << "Error: Destination Register must be a register (R0-R15)" << endl;
        exit(1);
    }

    arg1 = arg1.substr(1);

    int rd = stoi(arg1);

    if(rd < 0 || rd > 15) {
        cerr << "Error: Destination Register must be between R0 and R15" << endl;
        exit(1);
    }

    string rd_bin = "";
    for (int i = 3; i >= 0; --i) {
        rd_bin += ((rd >> i) & 1) ? '1' : '0';
    }

    if(arg2[0]!='R') {
        cerr << "Error: Operand 1 must be between R0 and R15" << endl;
        exit(1);
    }

    arg2 = arg2.substr(1);

    int rs1 = stoi(arg2);

    if(rs1 < 0 || rs1 > 15) {
        cerr << "Error: Operand 1 must be between R0 and R15" << endl;
        exit(1);
    }

    string rs1_bin = "";
    for (int i = 3; i >= 0; --i) {
        rs1_bin += ((rs1 >> i) & 1) ? '1' : '0';
    }

    if(arg3[0]!='R') {

        isImmediate += "1";

        int immediate_value = stoi(arg3);

        string immediate_bin = "";
        for (int i = 15; i >= 0; --i) {
            immediate_bin += ((immediate_value >> i) & 1) ? '1' : '0';
        }

        cout << "Immediate value: " << immediate_value << endl;

        return opcode_bin + isImmediate + rd_bin + rs1_bin + modifierbits + immediate_bin;

    }
    else {

        isImmediate += "0";
        
        arg3 = arg3.substr(1);
        
        int rs2 = stoi(arg3);

        if(rs2 < 0 || rs2 > 15) {
            cerr << "Error: Operand 2 must be between R0 and R15" << endl;
            exit(1);
        }
        
        string rs2_bin = "";
        for (int i = 3; i >= 0; --i) {
            rs2_bin += ((rs2 >> i) & 1) ? '1' : '0';
        }

        return opcode_bin + isImmediate + rd_bin + rs1_bin + rs2_bin + "00000000000000";

    }

}

string OneAddressEncoder (string opcode_bin, string operand){

    int offset = stoi(operand);

    int32_t mask = (1 << 27) - 1;
    int32_t twos_complement = offset & mask;

    string offset_bin = "";
    for (int i = 26; i >= 0; --i) {
        offset_bin += ((twos_complement >> i) & 1) ? '1' : '0';
    }

    return  opcode_bin + offset_bin;

}

string ZeroAddressEncoder (string opcode){
    return opcode + "000000000000000000000000000";
}

// Helper function to check if a string is a valid integer
bool isInteger(const string& str) {
    if (str.empty()) return false;
    size_t start = 0;
    if (str[0] == '-' || str[0] == '+') start = 1;
    if (start >= str.length()) return false;
    
    for (size_t i = start; i < str.length(); ++i) {
        if (!isdigit(str[i])) return false;
    }
    return true;
}

// Helper function to check if a string is a label (ends with colon)
bool isLabelDefinition(const string& str) {
    return !str.empty() && str.back() == ':';
}

// Helper function to remove colon from label
string cleanLabel(const string& label) {
    if (label.back() == ':') {
        return label.substr(0, label.length() - 1);
    }
    return label;
}

map<string,string> InstructionMap = {

    {"ADD", "0000000"}, {"ADDU", "0000001"}, {"ADDH", "0000010"},
    {"SUB", "0000100"}, {"SUBU", "0000101"}, {"SUBH", "0000110"},
    {"MUL", "0001000"}, {"MULU", "0001001"}, {"MULH", "0001010"},
    {"DIV", "0001100"}, {"DIVU", "0001101"}, {"DIVH", "0001110"},
    {"MOD", "0010000"}, {"MODU", "0010001"}, {"MODH", "0010010"},
    {"CMP", "0010100"}, {"CMPU", "0010101"}, {"CMPH", "0010110"},
    {"AND", "0011000"}, {"ANDU", "0011001"}, {"ANDH", "0011010"},
    {"OR",  "0011100"}, {"ORU",  "0011101"}, {"ORH",  "0011110"},
    {"NOT", "0100000"}, {"NOTU", "0100001"}, {"NOTH", "0100010"},
    {"MOV", "0100100"}, {"MOVU", "0100101"}, {"MOVH", "0100110"},
    {"LSL", "0101000"}, {"LSLU", "0101001"}, {"LSLH", "0101010"},
    {"LSR", "0101100"}, {"LSRU", "0101101"}, {"LSRH", "0101110"},
    {"ASR", "0110000"}, {"ASRU", "0110001"}, {"ASRH", "0110010"},
    {"LD",  "0111000"}, {"LDU", "0111001"}, {"LDH", "0111010"},
    {"ST",  "0111100"}, {"STU", "0111101"}, {"STH", "0111110"},
    {"BEQ", "10000"}, {"BGT", "10001"}, {"B", "10010"},
    {"CALL", "10011"}, {"RET", "10100"}, {"NOP", "01101"}

};

int main() {

    // open file AssemblyProgram.txt
    ifstream infile("AssemblyProgram.txt");
    if (!infile.is_open()) {
        cerr << "Error opening file AssemblyProgram.txt" << endl;
        return 1;
    }

    // First pass: collect all instructions and identify labels
    vector<Instruction> instructions;
    map<string, int> labelAddresses;
    string line;
    int currentAddress = 0;

    cout << "=== FIRST PASS: Collecting labels and instructions ===" << endl;

    while (getline(infile, line)) {
        size_t start = line.find_first_not_of(" \t");
        line.erase(0, start);

        if (line.empty()) {
            cout << "Skipping empty line!" << endl;
            continue;
        }

        // Check if this line starts with a label definition
        size_t colonPos = line.find(':');
        if (colonPos != string::npos) {
            // Extract the label name
            string labelName = line.substr(0, colonPos);
            
            // Remove any whitespace from label name
            size_t labelStart = labelName.find_first_not_of(" \t");
            size_t labelEnd = labelName.find_last_not_of(" \t");
            if (labelStart != string::npos && labelEnd != string::npos) {
                labelName = labelName.substr(labelStart, labelEnd - labelStart + 1);
            }
            
            labelAddresses[labelName] = currentAddress;
            cout << "Found label: " << labelName << " at address " << currentAddress << endl;
            
            // Check if there's an instruction after the colon
            string remainder = line.substr(colonPos + 1);
            size_t instrStart = remainder.find_first_not_of(" \t");
            if (instrStart == string::npos) {
                // No instruction on this line, continue to next line
                continue;
            }
            line = remainder.substr(instrStart);
        }

        // Parse the instruction - handle comma-separated arguments
        string opcode, arg1, arg2, arg3;
        
        size_t end = line.find_first_of(" \t");
        opcode = line.substr(0, end);
        if (end != string::npos) {
            line.erase(0, end);
        } else {
            line = "";
        }

        start = line.find_first_not_of(" \t");
        if (start != string::npos) {
            line.erase(0, start);
        } else {
            line = "";
        }

        if(line.empty()) {
            arg1 = "";
            arg2 = "";
            arg3 = "";
        }
        else {
            // Split arguments by comma or space/tab
            vector<string> args;
            string current_arg = "";
            
            for (size_t i = 0; i < line.length(); ++i) {
                char c = line[i];
                if (c == ',' || c == ' ' || c == '\t') {
                    if (!current_arg.empty()) {
                        args.push_back(current_arg);
                        current_arg = "";
                    }
                    // Skip whitespace after comma
                    while (i + 1 < line.length() && (line[i + 1] == ' ' || line[i + 1] == '\t')) {
                        ++i;
                    }
                } else {
                    current_arg += c;
                }
            }
            
            // Add the last argument if it exists
            if (!current_arg.empty()) {
                args.push_back(current_arg);
            }
            
            // Assign arguments
            if (args.size() > 0) arg1 = args[0];
            if (args.size() > 1) arg2 = args[1];
            if (args.size() > 2) arg3 = args[2];
            
            if (args.size() > 3) {
                cerr << "Instruction can contain maximum of 4 words" << endl;
                return 1;
            }
        }

        // Store the instruction
        Instruction instr;
        instr.opcode = opcode;
        instr.arg1 = arg1;
        instr.arg2 = arg2;
        instr.arg3 = arg3;
        instr.line_number = currentAddress;
        instructions.push_back(instr);
        
        cout << "Instruction " << currentAddress << ": " << opcode << " " << arg1 << " " << arg2 << " " << arg3 << endl;
        currentAddress++;
    }

    infile.close();

    // Second pass: resolve labels and generate machine code
    cout << "\n=== SECOND PASS: Resolving labels and generating machine code ===" << endl;

    ofstream outfile("Instructions.txt");
    if (!outfile.is_open()) {
        cerr << "Error opening file Instructions.txt" << endl;
        return 1;
    }

    for (const auto& instr : instructions) {
        string opcode = instr.opcode;
        string arg1 = instr.arg1;
        string arg2 = instr.arg2;
        string arg3 = instr.arg3;

        cout << "Processing instruction: " << opcode << " " << arg1 << " " << arg2 << " " << arg3 << endl;

        string opcode_bin = InstructionMap[opcode];

        if(opcode_bin.empty()) {
            cerr << "Error: Invalid Label of instruction " << opcode << endl;
            return 1;
        }

        if(opcode_bin.length() != 7) {
            
            if(opcode_bin.length() != 5) {
                cerr << "Error: Invalid opcode length for instruction " << opcode << endl;
                return 1;
            }

            if(opcode_bin == "01101" || opcode_bin == "10100") {
                if(!arg1.empty()) {
                    cerr << "Error: NOP and RET instructions do not take operands" << endl;
                    return 1;
                }

                outfile << ZeroAddressEncoder(opcode_bin) << endl;
            }
            else {
                // Handle branch instructions and CALL - all are single operand (label/offset)
                // BEQ, BGT, B, CALL all take one operand which is the branch target
                if(arg1.empty()) {
                    cerr << "Error: " << opcode << " instruction must have Format: " << opcode << " label/offset" << endl;
                    return 1;
                }

                string resolvedArg = arg1;
                
                // Check if arg1 is a label reference
                if (labelAddresses.find(arg1) != labelAddresses.end()) {
                    int targetAddress = labelAddresses[arg1];
                    int currentPC = instr.line_number;
                    int offset = targetAddress - currentPC;  // Removed the -1
                    resolvedArg = to_string(offset);
                    cout << "Resolved label " << arg1 << " to offset " << offset << endl;
                } else if (!isInteger(arg1)) {
                    cerr << "Error: Undefined label " << arg1 << endl;
                    return 1;
                }

                outfile << OneAddressEncoder(opcode_bin, resolvedArg) << endl;
            }

        }
        else {

            string modifierbits = opcode_bin.substr(5, 2);
            opcode_bin = opcode_bin.substr(0, 5);

            if(opcode_bin == "01110" || opcode_bin == "01111") {

                if(arg2.empty() || !arg3.empty()) {
                    cerr << "Error: LD/ST instructions must have Format : Label RD, immediate[RS1] " << endl;
                    return 1;
                }

                size_t pos = arg2.find('[');

                if(pos == string::npos || arg2.back() != ']') {
                    cerr << "Error: LD/ST instructions must have Format : Label RD, immediate[RS1] " << endl;
                    return 1;
                }

                string immediate = arg2.substr(0, pos);
                string rs = arg2.substr(pos + 1, arg2.length() - pos - 2);

                if(immediate.empty() || rs.empty()) {
                    cerr << "Error: LD/ST instructions must have Format : Label RD, immediate[RS1] " << endl;
                    return 1;
                }

                // Resolve label in immediate field if it's a label
                if (labelAddresses.find(immediate) != labelAddresses.end()) {
                    immediate = to_string(labelAddresses[immediate]);
                    cout << "Resolved label " << immediate << " in LD/ST instruction" << endl;
                }

                outfile << ThreeAddressEncoder(opcode_bin, modifierbits, arg1, rs, immediate) << endl;

            }
            else if(opcode_bin == "00101" || opcode_bin == "01001" || opcode_bin == "01000") {

                if(arg2.empty() || !arg3.empty()) {
                    cerr << "Error: CMP, MOV, NOT instructions must have Format : Label RD, RS1/immediate" << endl;
                    return 1;
                }

                // Resolve label in immediate field if it's a label and not a register
                string resolvedArg2 = arg2;
                if (arg2[0] != 'R' && labelAddresses.find(arg2) != labelAddresses.end()) {
                    resolvedArg2 = to_string(labelAddresses[arg2]);
                    cout << "Resolved label " << arg2 << " in immediate field" << endl;
                }

                if(opcode_bin == "00101") {
                    outfile << ThreeAddressEncoder(opcode_bin, modifierbits, "R0", arg1, resolvedArg2) << endl;
                }
                else {
                    outfile << ThreeAddressEncoder(opcode_bin, modifierbits, arg1, "R0", resolvedArg2) << endl;
                }

            }
            else {
                
                if(arg3.empty()) {
                    cerr << "Error: Three address instructions must have Format : Label RD, RS1, RS2/immediate" << endl;
                    return 1;
                }

                // Resolve label in immediate field if it's a label and not a register
                string resolvedArg3 = arg3;
                if (arg3[0] != 'R' && labelAddresses.find(arg3) != labelAddresses.end()) {
                    resolvedArg3 = to_string(labelAddresses[arg3]);
                    cout << "Resolved label " << arg3 << " in immediate field" << endl;
                }

                outfile << ThreeAddressEncoder(opcode_bin, modifierbits, arg1, arg2, resolvedArg3) << endl;
            }
        }
    }

    outfile.close();

    cout << "Assembly program has been successfully converted to machine code and saved in Instructions.txt" << endl;
    return 0;
}
