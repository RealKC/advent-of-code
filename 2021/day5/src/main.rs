use std::{cmp::min, collections::HashMap, env, fs::File, io::Read};

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
    let input = parse_input(input);
    let mut points = HashMap::new();

    for Line { start, end } in input.iter() {
        if start.x == end.x {
            for i in 0..=(end.y - start.y).abs() {
                *points
                    .entry(Point {
                        x: start.x,
                        y: min(start.y, end.y) + i,
                    })
                    .or_insert(0) += 1;
            }
        }

        if start.y == end.y {
            for i in 0..=(end.x - start.x).abs() {
                *points
                    .entry(Point {
                        x: min(start.x, end.x) + i,
                        y: start.y,
                    })
                    .or_insert(0) += 1;
            }
        }
    }

    let intersections = points.iter().filter(|(_, v)| **v > 1).count();

    println!("{}", intersections)
}

fn part2(input: &str) {
    let input = parse_input(input);
    let mut points = HashMap::new();

    for Line { start, end } in input.iter() {
        if start.x == start.y && end.x == end.y {
            let end_x_delta = (end.x - start.x).abs();
            let end_y_delta = (end.y - start.y).abs();
            let start_x = min(start.x, end.x);
            let start_y = min(start.y, end.y);
            for (i, j) in (0..=end_x_delta).zip(0..=end_y_delta) {
                *points
                    .entry(Point {
                        x: start_x + i,
                        y: start_y + j,
                    })
                    .or_insert(0) += 1;
            }
        } else if start.x == end.x {
            for i in 0..=(end.y - start.y).abs() {
                *points
                    .entry(Point {
                        x: start.x,
                        y: min(start.y, end.y) + i,
                    })
                    .or_insert(0) += 1;
            }
        } else if start.y == end.y {
            for i in 0..=(end.x - start.x).abs() {
                *points
                    .entry(Point {
                        x: min(start.x, end.x) + i,
                        y: start.y,
                    })
                    .or_insert(0) += 1;
            }
        } else if (start.x - end.x).abs() == (start.y - end.y).abs() {
            let delta = (end.x - start.x).abs();

            for i in 0..=delta {
                match ((start.x - end.x).signum(), (start.y - end.y).signum()) {
                    (-1, -1) => {
                        *points
                            .entry(Point {
                                x: start.x + i,
                                y: start.y + i,
                            })
                            .or_insert(0) += 1
                    }
                    (1, 1) => {
                        *points
                            .entry(Point {
                                x: start.x - i,
                                y: start.y - i,
                            })
                            .or_insert(0) += 1
                    }
                    (-1, 1) => {
                        *points
                            .entry(Point {
                                x: start.x + i,
                                y: start.y - i,
                            })
                            .or_insert(0) += 1
                    }
                    (1, -1) => {
                        *points
                            .entry(Point {
                                x: start.x - i,
                                y: start.y + i,
                            })
                            .or_insert(0) += 1
                    }
                    _ => unreachable!(),
                }
            }
        }
    }

    let intersections = points.iter().filter(|(_, v)| **v > 1).count();

    println!("{}", intersections)
}

#[derive(PartialEq, Eq, Hash)]
struct Line {
    start: Point,
    end: Point,
}

#[derive(PartialEq, Eq, Hash, Debug)]
struct Point {
    x: i16,
    y: i16,
}

fn parse_input(input: &str) -> Vec<Line> {
    input
        .lines()
        .map(|line| line.split_whitespace())
        .map(|mut s| {
            let mut start = s.next().unwrap().split(",").map(|s| s.parse().unwrap());
            assert_eq!(s.next().unwrap(), "->");
            let mut end = s.next().unwrap().split(",").map(|s| s.parse().unwrap());
            let start = Point {
                x: start.next().unwrap(),
                y: start.next().unwrap(),
            };
            let end = Point {
                x: end.next().unwrap(),
                y: end.next().unwrap(),
            };

            Line { start, end }
        })
        .collect()
}
