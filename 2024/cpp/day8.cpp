#include "day8.h"

#include <algorithm>
#include <boost/container_hash/hash.hpp>
#include <functional>
#include <print>
#include <ranges>
#include <unordered_set>

namespace Day8 {

struct Coordinate {
    ssize_t i, j;

    bool operator==(Coordinate const&) const = default;

    std::string to_string() const
    {
        return std::format("({}, {})", i, j);
    }
};

}

template<>
struct std::hash<Day8::Coordinate> {
    std::size_t operator()(Day8::Coordinate const& c) const noexcept
    {
        auto seed = 0uz;
        boost::hash_combine(seed, c.i);
        boost::hash_combine(seed, c.i);
        return seed;
    }
};

namespace Day8 {

static char const frequencies[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

class Board {
public:
    explicit Board(std::string_view board)
        : m_board(board)
        , m_width { static_cast<ssize_t>(board.find_first_of('\n')) }
        , m_height { std::ranges::count(board, '\n') }
    {
        std::erase(m_board, '\n');
    }

    [[nodiscard]] char get(ssize_t i, ssize_t j) const
    {
        return m_board[i * m_width + j];
    }

    [[nodiscard]] char get(Coordinate const& c) const { return get(c.i, c.j); };

    [[nodiscard]] auto width() const { return m_width; }
    [[nodiscard]] auto height() const { return m_height; }

    [[nodiscard]] bool in_bounds(Coordinate const& c) const noexcept
    {
        if (c.i < 0 || c.i >= height()) {
            return false;
        }

        if (c.j < 0 || c.j >= width()) {
            return false;
        }

        return true;
    }

private:
    std::string m_board;

    ssize_t m_width { 0 };
    ssize_t m_height { 0 };
};

std::string solve_a(std::string_view input)
{
    auto board = Board { input };

    std::unordered_set<Coordinate> result;

#pragma omp parallel for
    for (auto freq = 0uz; freq < std::size(frequencies); ++freq) {
        auto frequency = frequencies[freq];

        std::unordered_set<Coordinate> coords;

        for (auto fi = 0z; fi < board.height(); ++fi) {
            for (auto fj = 0z; fj < board.width(); ++fj) {
                if (board.get(fi, fj) != frequency) {
                    continue;
                }

                for (auto i = 0z; i < board.height(); ++i) {
                    for (auto j = 0z; j < board.width(); ++j) {
                        if (fi == i && fj == j) {
                            continue;
                        }

                        if (board.get(i, j) != frequency) {
                            continue;
                        }

                        auto off_i = i - fi;
                        auto off_j = j - fj;

                        auto first = Coordinate { fi - off_i, fj - off_j };
                        if (board.in_bounds(first)) {
                            coords.insert(first);
                        }

                        auto second = Coordinate { i + off_i, j + off_j };
                        if (board.in_bounds(second)) {
                            coords.insert(second);
                        }
                    }
                }
            }
        }

#pragma omp critical
        {
            result.merge(coords);
        }
    }

    return std::to_string(result.size());
}

std::string solve_b(std::string_view input)
{
    auto board = Board { input };

    std::unordered_set<Coordinate> result;

#pragma omp parallel for
    for (auto freq = 0uz; freq < std::size(frequencies); ++freq) {
        auto frequency = frequencies[freq];

        std::unordered_set<Coordinate> coords;

        for (auto fi = 0z; fi < board.height(); ++fi) {
            for (auto fj = 0z; fj < board.width(); ++fj) {
                if (board.get(fi, fj) != frequency) {
                    continue;
                }

                for (auto i = 0z; i < board.height(); ++i) {
                    for (auto j = 0z; j < board.width(); ++j) {
                        if (fi == i && fj == j) {
                            continue;
                        }

                        if (board.get(i, j) != frequency) {
                            continue;
                        }

                        coords.insert(Coordinate { fi, fj });
                        coords.insert(Coordinate { i, j });

                        auto off_i = i - fi;
                        auto off_j = j - fj;

                        auto first = Coordinate { fi - off_i, fj - off_j };
                        while (board.in_bounds(first)) {
                            coords.insert(first);
                            first.i -= off_i;
                            first.j -= off_j;
                        }

                        auto second = Coordinate { i + off_i, j + off_j };
                        while (board.in_bounds(second)) {
                            coords.insert(second);
                            second.i += off_i;
                            second.j += off_j;
                        }
                    }
                }
            }
        }

#pragma omp critical
        {
            result.merge(coords);
        }
    }

    return std::to_string(result.size());
}

}
