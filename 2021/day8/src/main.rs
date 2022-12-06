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
    let mut ones = 0;
    let mut fours = 0;
    let mut sevens = 0;
    let mut eights = 0;

    for entry in input.lines() {
        let (_, outputs) = entry.split_at(entry.find("|").unwrap());
        for output in outputs.split_whitespace() {
            match output.len() {
                2 => ones += 1,
                4 => fours += 1,
                3 => sevens += 1,
                7 => eights += 1,
                _ => (),
            }
        }
    }

    println!("{}", ones + fours + sevens + eights)
}

fn part2(_input: &str) {
    todo!()
}
