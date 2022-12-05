use std::{fs::File, io::Write};

const INPUT: &str = include_str!("../input.in");

fn main() {
    let count_of_chars_without_nl: usize = INPUT
        .lines()
        .take_while(|line| !line.is_empty())
        .map(|line| line.len())
        .sum();
    let line_count = INPUT.lines().take_while(|line| !line.is_empty()).count();
    let crate_separator = count_of_chars_without_nl + line_count;

    let crates = parse_crates(INPUT.split_at(crate_separator).0);

    let mut crate_file = File::create("crates.in").unwrap();

    for vec in crates {
        write!(crate_file, "{} ", vec.len()).unwrap();
        for ch in vec {
            write!(crate_file, "{ch}").unwrap();
        }
        write!(crate_file, "\n").unwrap();
    }

    let mut instructions = File::create("instructions.in").unwrap();
    write!(instructions, "{}", &INPUT[crate_separator..]).unwrap();
}

fn parse_crates(crates: &str) -> Vec<Vec<char>> {
    let crate_count = crates
        .lines()
        .last()
        .unwrap()
        .split_ascii_whitespace()
        .last()
        .unwrap()
        .parse::<usize>()
        .unwrap();

    let line_length = crates.lines().map(str::len).max().unwrap();

    let crates_bytes = crates.as_bytes();
    let mut crates = vec![vec![]; crate_count];

    let mut curr_crate = 0;
    let mut lines = crates_bytes.split(|ch| *ch == b'\n').collect::<Vec<_>>();
    lines.pop();
    lines.pop();

    for i in (1..line_length).step_by(4) {
        for line in &lines {
            crates[curr_crate].push(line.get(i).copied().unwrap_or(b' ') as char);
        }
        curr_crate += 1;
    }

    crates
        .iter()
        .map(|cr| {
            cr.into_iter()
                .filter(|ch| **ch != ' ')
                .copied()
                .collect::<Vec<_>>()
        })
        .collect()
}
