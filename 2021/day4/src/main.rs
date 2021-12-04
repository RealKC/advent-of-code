use std::{env, fs::File, io::Read};

fn main() {
    let mut input_file = File::open("input").unwrap();
    let mut input = String::new();
    input_file.read_to_string(&mut input).unwrap();

    if env::var("PART").unwrap_or("1".into()) == "1" {
        part1(&input);
    } else {
        part2(&input);
    }
}

struct Input {
    drawn_numbers: Vec<u8>,
    boards: Vec<Board>,
}

struct Board(Vec<Vec<Cell>>);

impl Board {
    fn set(&mut self, num: u8) {
        self.0
            .iter_mut()
            .flatten()
            .find(|cell| cell.number == num)
            .map(|cell| cell.drawn = true);
    }

    fn is_winning(&self) -> bool {
        let rows_winning = self
            .0
            .iter()
            .map(|line| line.iter().all(|cell| cell.drawn))
            .any(|b| b);

        if rows_winning {
            return true;
        }

        let mut colums_winning = false;

        for i in 0..5 {
            let mut curr_column_is_winning = true;
            for j in 0..5 {
                curr_column_is_winning &= self.0[j][i].drawn;
            }
            colums_winning |= curr_column_is_winning;
            if colums_winning {
                break;
            }
        }

        colums_winning
    }

    fn score(&self, last_drawn: u8) -> u32 {
        dbg!(last_drawn);
        &self
            .0
            .iter()
            .flatten()
            .filter(|cell| !cell.drawn)
            .map(|cell| cell.number as u32)
            .sum::<_>()
            * (last_drawn as u32)
    }
}

#[derive(Debug)]
struct Cell {
    number: u8,
    drawn: bool,
}

fn parse_input(input: &str) -> Input {
    let mut lines = input.lines();

    let drawn_numbers = lines
        .next()
        .unwrap()
        .split(",")
        .map(|s| s.parse::<u8>().unwrap())
        .collect::<Vec<_>>();

    let mut boards = vec![];
    let mut current_board = Board(Default::default());

    let mut lines = lines.filter(|line| !line.is_empty());
    while let Some(line) = lines.next() {
        if current_board.0.len() == 5 {
            boards.push(current_board);
            current_board = Board(Default::default());
        }

        let bingo_line = line
            .split_whitespace()
            .map(|s| Cell {
                number: s.parse().unwrap(),
                drawn: false,
            })
            .collect();
        current_board.0.push(bingo_line);
    }

    if current_board.0.len() == 5 {
        boards.push(current_board)
    }

    Input {
        drawn_numbers,
        boards,
    }
}

fn part1(input: &str) {
    let mut input = parse_input(input);

    for num in input.drawn_numbers.iter() {
        for board in input.boards.iter_mut() {
            board.set(*num);

            if board.is_winning() {
                println!("{}", board.score(*num));
                return;
            }
        }
    }
}

fn part2(input: &str) {
    let mut input = parse_input(input);

    let mut score = 0;
    for num in input.drawn_numbers.iter() {
        let mut idx = 0;
        while idx < input.boards.len() {
            input.boards[idx].set(*num);

            if input.boards[idx].is_winning() {
                let new_score = input.boards[idx].score(*num);
                input.boards.remove(idx);
                if new_score != 0 {
                    score = new_score;
                }
            } else {
                idx += 1;
            }
        }
    }

    println!("{}", score)
}
