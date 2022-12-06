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

fn part1(input: &str) {
    let mut states = input
        .split(',')
        .map(|s| s.trim().parse().unwrap())
        .collect::<Vec<u8>>();

    for _ in 0..80 {
        let mut to_insert = 0;

        for state in states.iter_mut() {
            if *state == 0 {
                *state = 6;
                to_insert += 1;
            } else {
                *state -= 1;
            }
        }
        states.resize(states.len() + to_insert, 8);
    }

    println!("{}", states.len())
}

fn part2(input: &str) {
    let mut states = [0i64; 9];

    for i in input.split(',').map(|s| s.trim().parse::<usize>().unwrap()) {
        states[i] += 1;
    }

    for _ in 0..256 {
        let mut new_states = [0i64; 9];
        for i in 1..9 {
            new_states[i - 1] = states[i];
        }
        new_states[6] += states[0];
        new_states[8] += states[0];
        states = new_states;
    }

    println!("{}", states.iter().sum::<i64>())
}
