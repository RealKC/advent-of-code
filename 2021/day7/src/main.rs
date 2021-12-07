#![feature(map_first_last)]

use std::{collections::BTreeMap, env, fs::File, io::Read};

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
    let nums = input
        .split(',')
        .map(str::trim)
        .map(|s| s.parse::<u16>().unwrap());

    let mut submarines = BTreeMap::new();

    for num in nums {
        *submarines.entry(num).or_insert(0) += 1;
    }

    let max_pos = *submarines.last_entry().unwrap().key();

    let mut minimum_fuel_cost = i32::MAX;
    for guess in 0..=max_pos {
        let mut current_cost = 0;
        for (submarine_pos, submarines_here) in submarines.iter() {
            current_cost += (*submarine_pos as i32 - guess as i32).abs() * submarines_here;
        }
        if current_cost < minimum_fuel_cost {
            minimum_fuel_cost = current_cost;
        }
    }

    println!("{minimum_fuel_cost}");
}

fn part2(input: &str) {
    let nums = input
        .split(',')
        .map(str::trim)
        .map(|s| s.parse::<u16>().unwrap());

    let mut submarines = BTreeMap::new();

    for num in nums {
        *submarines.entry(num).or_insert(0) += 1;
    }

    let max_pos = *submarines.last_entry().unwrap().key();

    let mut minimum_fuel_cost = i32::MAX;
    for guess in 0..=max_pos {
        let mut current_cost = 0;
        for (submarine_pos, submarines_here) in submarines.iter() {
            let n = (*submarine_pos as i32 - guess as i32).abs();
            let sum = n * (n + 1) / 2;
            current_cost += sum * submarines_here;
        }
        if current_cost < minimum_fuel_cost {
            minimum_fuel_cost = current_cost;
        }
    }

    println!("{minimum_fuel_cost}");
}
