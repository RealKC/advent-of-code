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

#[derive(Default, Clone, Copy, Debug)]
struct BitFrequency {
    one: u64,
    zero: u64,
}

fn part1(input: &str) {
    let mut frequencies: Vec<BitFrequency> = vec![Default::default(); 12];

    for line in input.lines() {
        for (idx, bit) in line.bytes().enumerate() {
            match bit {
                b'0' => frequencies[idx].zero += 1,
                b'1' => frequencies[idx].one += 1,
                _ => unreachable!(),
            }
        }
    }

    let gamma = frequencies
        .iter()
        .map(|freq| if freq.zero > freq.one { 0u64 } else { 1u64 })
        .rev()
        .enumerate()
        .fold(0, |acc, (bit_idx, val)| acc | (val << bit_idx));

    let epsilon = frequencies
        .iter()
        .map(|freq| if freq.zero < freq.one { 0u64 } else { 1u64 })
        .rev()
        .enumerate()
        .fold(0, |acc, (bit_idx, val)| acc | (val << bit_idx));

    println!("{}", epsilon * gamma)
}

fn part2(input: &str) {
    let mut lines = input.lines().collect::<Vec<&str>>();

    let mut bit_idx = 0;

    while lines.len() > 1 {
        let mut frequency = BitFrequency::default();
        for line in lines.iter() {
            match line.bytes().nth(bit_idx).unwrap() {
                b'0' => frequency.zero += 1,
                b'1' => frequency.one += 1,
                _ => unreachable!(),
            }
        }

        let bit = if frequency.one >= frequency.zero {
            '1'
        } else {
            '0'
        };

        lines = lines
            .into_iter()
            .filter(|s| s.chars().nth(bit_idx).unwrap() == bit)
            .collect();
        bit_idx += 1;
    }

    let o2 = lines[0];

    bit_idx = 0;
    let mut lines = input.lines().collect::<Vec<&str>>();
    while lines.len() > 1 {
        let mut frequency = BitFrequency::default();
        for line in lines.iter() {
            match line.bytes().nth(bit_idx).unwrap() {
                b'0' => frequency.zero += 1,
                b'1' => frequency.one += 1,
                _ => unreachable!(),
            }
        }

        let bit = if frequency.one < frequency.zero {
            '1'
        } else {
            '0'
        };

        lines = lines
            .into_iter()
            .filter(|s| s.chars().nth(bit_idx) == Some(bit))
            .collect();
        bit_idx += 1;
    }
    let co = lines[0];

    let o2 = o2
        .bytes()
        .map(|b| (b - b'0') as u32)
        .rev()
        .enumerate()
        .fold(0, |acc, (bit_idx, val)| acc | (val << bit_idx));
    let co = co
        .bytes()
        .map(|b| (b - b'0') as u32)
        .rev()
        .enumerate()
        .fold(0, |acc, (bit_idx, val)| acc | (val << bit_idx));

    println!("{} ", o2 * co);
}
