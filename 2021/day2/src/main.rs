use std::{env, fs::File, io::Read};

fn main() {
    let mut input_file = File::open("input").unwrap();
    let mut input = String::new();
    input_file.read_to_string(&mut input).unwrap();

    if env::var("PART").unwrap() == "1" {
        part1(&input);
    } else {
        part2(&input);
    }
}

enum Command {
    Up(i64),
    Down(i64),
    Forward(i64),
}

impl Command {
    fn from_str(s: &str) -> Self {
        let mut split = s.split_whitespace();
        let command = split.next().unwrap();
        let distance = split.next().unwrap().parse().unwrap();

        match command {
            "up" => Self::Up(distance),
            "down" => Self::Down(distance),
            "forward" => Self::Forward(distance),
            _ => unreachable!(),
        }
    }
}

fn part1(input: &str) {
    let (horizontal, depth) = input.lines().map(|line| Command::from_str(line)).fold(
        (0, 0),
        |(horizontal, depth), cmd| match cmd {
            Command::Up(dist) => (horizontal, depth - dist),
            Command::Down(dist) => (horizontal, depth + dist),
            Command::Forward(dist) => (horizontal + dist, depth),
        },
    );

    println!("{}", horizontal * depth)
}

fn part2(input: &str) {
    let commands = input.lines().map(|line| Command::from_str(line));

    let mut horizontal = 0;
    let mut depth = 0;
    let mut aim = 0;

    for cmd in commands {
        match cmd {
            Command::Up(units) => aim -= units,
            Command::Down(units) => aim += units,
            Command::Forward(units) => {
                horizontal += units;
                depth += aim * units;
            }
        }
    }

    println!("{}", horizontal * depth)
}
