use std::{fs::File, io::Read};

fn main() {
    let mut input_file = File::open("input").unwrap();
    let mut input = String::new();
    input_file
        .read_to_string(&mut input)
        .expect("Failed to read");
    if std::env::var("PART").unwrap() == "1" {
        part1(&input)
    } else {
        part2(&input)
    }
}

fn part1(input: &str) {
    let input = input
        .lines()
        .map(|line| line.parse::<u32>().unwrap())
        .collect::<Vec<_>>();

    let increase_count: u32 = input.windows(2).map(|w| (w[0] < w[1]) as u32).sum();

    println!("{}", increase_count);
}

fn part2(input: &str) {
    let input = input
        .lines()
        .map(|line| line.parse::<u32>().unwrap())
        .collect::<Vec<_>>();

    let sums = input
        .windows(3)
        .map(|w| w.iter().sum())
        .collect::<Vec<u32>>();

    let increase_count: u32 = sums.windows(2).map(|w| (w[0] < w[1]) as u32).sum();

    println!("{}", increase_count);
}
