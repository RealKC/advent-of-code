#include "day8.h"
#include <fstream>
#include <print>
#include <sstream>
#include <unordered_map>

using Solver = std::string (*)(std::string_view);

using namespace std::string_view_literals;

std::unordered_map<std::string_view, std::unordered_map<std::string_view, Solver>> solutions {
    { "8", { { "a", Day8::solve_a }, { "b", Day8::solve_b } } },

};

std::string read_to_string(std::string_view path)
{
    std::ifstream in { path.data() };
    std::ostringstream os;
    os << in.rdbuf();
    return os.str();
}

int main(int argc, char* argv[])
{
    if (argc != 3) {
        std::println("Usage: AdventOfCode <day> <part>");
        return 1;
    }

    auto day = argv[1];
    auto part = argv[2];

    auto input = read_to_string(std::format("inputs/{}", day));

    std::println("The solution was: {}", solutions.at(day).at(part)(input));

    return 0;
}
