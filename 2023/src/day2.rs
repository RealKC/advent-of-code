use chumsky::{
    error::Simple,
    primitive::{choice, just},
    text::{self, TextParser},
    Parser,
};

static INPUT: &str = include_str!("day2.input");

pub fn solution() {
    println!("day 2, part 1 solution {}", part1(INPUT));
    println!("day 2, part 2 solution {}", part2(INPUT));
}

fn part1(input: &str) -> u64 {
    let games = parser().parse(input).unwrap();

    games
        .into_iter()
        .filter(|game| game.is_possible(12, 13, 14))
        .map(|game| game.id)
        .sum()
}

fn part2(input: &str) -> u64 {
    let games = parser().parse(input).unwrap();

    games.into_iter().map(|game| game.minimum_power()).sum()
}

#[derive(Debug, Clone, Copy)]
enum Colour {
    Red(u64),
    Green(u64),
    Blue(u64),
}

impl Colour {
    fn value(&self) -> u64 {
        match self {
            Self::Red(val) | Self::Green(val) | Self::Blue(val) => *val,
        }
    }
    fn is_less(&self, red: u64, green: u64, blue: u64) -> bool {
        match self {
            Colour::Red(val) => val <= &red,
            Colour::Green(val) => val <= &green,
            Colour::Blue(val) => val <= &blue,
        }
    }
}

#[derive(Debug)]
struct Game {
    id: u64,
    sets: Vec<Vec<Colour>>,
}

impl Game {
    fn is_possible(&self, red: u64, green: u64, blue: u64) -> bool {
        self.sets
            .iter()
            .flat_map(|set| set.iter().map(|colour| colour.is_less(red, green, blue)))
            .all(|is_less| is_less)
    }

    fn minimum_power(&self) -> u64 {
        let (red, green, blue) = self.sets.iter().fold(
            (Colour::Red(0), Colour::Green(0), Colour::Blue(0)),
            |acc, set| {
                let red = set
                    .iter()
                    .filter(|c| matches!(c, Colour::Red(_)))
                    .map(|c| {
                        if let Colour::Red(val) = c {
                            Colour::Red(*val.max(&acc.0.value()))
                        } else {
                            acc.0
                        }
                    })
                    .nth(0)
                    .unwrap_or(acc.0);
                let green = set
                    .iter()
                    .filter(|c| matches!(c, Colour::Green(_)))
                    .map(|c| {
                        if let Colour::Green(val) = c {
                            Colour::Green(*val.max(&acc.1.value()))
                        } else {
                            acc.1
                        }
                    })
                    .nth(0)
                    .unwrap_or(acc.1);
                let blue = set
                    .iter()
                    .filter(|c| matches!(c, Colour::Blue(_)))
                    .map(|c| {
                        if let Colour::Blue(val) = c {
                            Colour::Blue(*val.max(&acc.2.value()))
                        } else {
                            acc.2
                        }
                    })
                    .nth(0)
                    .unwrap_or(acc.2);

                (red, green, blue)
            },
        );

        red.value() * green.value() * blue.value()
    }
}

fn parser() -> impl Parser<char, Vec<Game>, Error = Simple<char>> {
    let red = text::int(10)
        .map(|s: String| Colour::Red(s.parse().unwrap()))
        .padded()
        .then(text::keyword("red"));

    let blue = text::int(10)
        .map(|s: String| Colour::Blue(s.parse().unwrap()))
        .padded()
        .then(text::keyword("blue"));

    let green = text::int(10)
        .map(|s: String| Colour::Green(s.parse().unwrap()))
        .padded()
        .then(text::keyword("green"));

    let colour = choice((red, blue, green));
    let set = colour
        .separated_by(just(','))
        .at_least(1)
        .at_most(3)
        .map(|colours| colours.into_iter().map(|e| e.0).collect::<Vec<_>>());
    let sets = set.separated_by(just(';'));

    let game = text::keyword("Game")
        .padded()
        .ignore_then(text::int(10).map(|s: String| s.parse::<u64>().unwrap()))
        .then_ignore(just(':').padded())
        .then(sets)
        .map(|game| Game {
            id: game.0,
            sets: game.1,
        });

    game.separated_by(just('\n')).allow_trailing()
}

#[cfg(test)]
mod test {
    use super::{part1, part2};

    const TEST_INPUT: &str = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green";

    #[test]
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 8);
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 2286);
    }
}
