#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
// #include <stringstream>

#include "Vcore_sim.h"
#include "verilated.h"

bool _assert(std::string assertation, bool condition) {
  cout << assertation << ": ";
  if (condition) {
    cout << "\033[1;35mPass!\033[0m" << endl;
    return true;
  } else {
    cout << "\033[1;31mFail!\033[0m" << endl;
    return false;
  }
}

int main(int argc, char **argv, char **env) {
  Verilated::commandArgs(argc, argv);

  int failures = 0;

  for (int file_index = 1; file_index < argc; file_index++) {
    Vcore_sim* top = new Vcore_sim;
    top->clk_i = 0;

    ifstream ml_file;
    ml_file.open(argv[file_index]);

    for(string line; getline(ml_file, line); )
    {
        string instruction = line;
        string comment;

        for (int i = 0; i < line.length(); i++) {
          if ((line[i] == '/') && (line[i+1] == '/')) {
            if (i > 0)
              instruction = line.substr(0, i - 1);

            if (line.length() > i) {
              comment = line.substr(i + 3, line.length() - (i + 2));
            }

            break;
          }
        }

        if (comment.substr(0, 12) == "CoreSimInput") {
          string in = comment.substr(13, comment.length() - 13);

          top->input_i = stoull(in);
        }

        if (comment.substr(0, 13) == "CoreSimAssert") {
          uint64_t expected = stoull(comment.substr(14, comment.length() - 14));
          if (!_assert(to_string(expected) + " == " + to_string(top->output_o), expected == top->output_o))
            failures++;
        }

        if (instruction.length() >= 5) {
          unsigned int x;
          std::stringstream ss;
          ss << std::hex << instruction.substr(0, 5);
          ss >> x;

          top->instruction_i = x;

          top->clk_i = 1;
          top->eval();
          top->clk_i = 0;
          top->eval();

          cout << "Instruction: " << instruction << "; Output: " << top->output_o;

          if (comment.length() > 0) {
            cout << "; Comment = " << comment << endl;
          } else {
            cout << endl;
          }

          cout << "  RAM Address: " << to_string(top->ram_address_o) << "; RAM Output: " << to_string(top->ram_output_o) << "; RAM Input: " << to_string(top->ram_input_o) << "; RAM Write: " << to_string(top->ram_write_o) << endl;
        }
    }

    delete top;
    ml_file.close();
  }

  cout << "Tests finished with " << to_string(failures) << " failures." << endl;

  exit(0);
}
