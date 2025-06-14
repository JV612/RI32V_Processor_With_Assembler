
#include<iostream>
#include<fstream>
#include<map>
#include<string>
using namespace std;

string ThreeAddressEncoder(string opcode_bin,string modifierbits,string arg1, string arg2, string arg3) {

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

        int immediate_value = stoi(arg2);

        string immediate_bin = "";
        for (int i = 15; i >= 0; --i) {
            immediate_bin += ((immediate_value >> i) & 1) ? '1' : '0';
        }

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

    ifstream infile("Program.asm");
    if (!infile.is_open()) {
        cerr << "Error opening file AssemblyProgram.txt" << endl;
        return 1;
    }

    ofstream outfile("Instructions.txt");
    if (!outfile.is_open()) {
        cerr << "Error opening file Instructions.txt" << endl;
        return 1;
    }

    string line;
    while (getline(infile, line)) {

        size_t start = line.find_first_not_of(" \t");
        line.erase(0, start);

        if (line.empty()) {
            cout << "Skipping empty line !" << endl;
            continue;
        }

        string opcode, arg1, arg2, arg3;

        size_t end = line.find_first_of(" \t");
        opcode = line.substr(0, end);
        line.erase(0, end);

        start = line.find_first_not_of(" \t");
        line.erase(0, start);

        if(line.empty()) {

            arg1 = "";
            arg2 = "";
            arg3 = "";

        }
        else {

            end = line.find_first_of(" \t");
            arg1 = line.substr(0, end);
            line.erase(0, end);

            start = line.find_first_not_of(" \t");
            line.erase(0, start);
            if(line.empty()) {

                arg2 = "";
                arg3 = "";

            }
            else {

                end = line.find_first_of(" \t");
                arg2 = line.substr(0, end);
                line.erase(0, end);

                start = line.find_first_not_of(" \t");
                line.erase(0, start);

                if(line.empty()) {

                    arg3 = "";

                }
                else {

                    end = line.find_first_of(" \t");
                    arg3 = line.substr(0, end);
                    line.erase(0, end);
                    
                    start = line.find_first_not_of(" \t");
                    line.erase(0, start);

                    if(!line.empty()) {
                        cerr << "Instruction can contain maximum of 4 words" << endl;
                        return 1;
                    }

                }
            
            }

        }

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

                if(arg1.empty()) {
                    cerr << "Error: One address instructions must have Format : Label Offset" << endl;
                    return 1;
                }

                outfile << OneAddressEncoder(opcode_bin,arg1) << endl;
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

                outfile << ThreeAddressEncoder(opcode_bin, modifierbits, arg1, rs, immediate) << endl;

            }
            else if(opcode_bin == "00101" || opcode_bin == "01001" || opcode_bin == "01000") {

                if(arg2.empty() || !arg3.empty()) {
                    cerr << "Error: CMP, MOV, NOT instructions must have Format : Label RD, RS1/immediate" << endl;
                    return 1;
                }

                if(opcode_bin == "00101") {

                    outfile << ThreeAddressEncoder(opcode_bin, modifierbits, "R0", arg1, arg2) << endl;

                }
                else {

                    outfile << ThreeAddressEncoder(opcode_bin, modifierbits, arg1, "R0", arg2) << endl;

                }

            }
            else {
                
                if(arg3.empty()) {
                    cerr << "Error: Three address instructions must have Format : Label RD, RS1, RS2/immediate" << endl;
                    return 1;
                }

                outfile << ThreeAddressEncoder(opcode_bin, modifierbits, arg1, arg2, arg3) << endl;

            }

        }

    }

    infile.close();
    outfile.close();

    cout << "Assembly program has been successfully converted to machine code and saved in Instructions.txt" << endl;
    return 0;

}
