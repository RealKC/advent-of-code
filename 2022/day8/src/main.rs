#![allow(clippy::needless_range_loop)] // Leave me alone clippy

const INPUT: &str = include_str!("../input.in");

fn main() {
    println!("The answer for part one is: {}", solve_part_one());
    println!("The answer for part two is: {}", solve_part_two());
}

fn solve_part_one() -> usize {
    let lines = INPUT
        .lines()
        .map(|line| line.as_bytes())
        .collect::<Vec<_>>();

    let len = lines[0].len();
    let mut visible_trees = 4 * len - 4;
    for i in 1..len - 1 {
        for j in 1..len - 1 {
            let val = lines[i][j];

            let mut left_visible = true;
            let mut right_visible = true;
            let mut top_visible = true;
            let mut bottom_visinble = true;

            for k in 0..j {
                if lines[i][k] >= val {
                    left_visible = false;
                }
            }

            for k in j + 1..len {
                if lines[i][k] >= val {
                    right_visible = false;
                }
            }

            for k in 0..i {
                if lines[k][j] >= val {
                    top_visible = false;
                }
            }

            for k in i + 1..len {
                if lines[k][j] >= val {
                    bottom_visinble = false;
                }
            }

            if left_visible || right_visible || top_visible || bottom_visinble {
                visible_trees += 1;
            }
        }
    }

    visible_trees
}

fn solve_part_two() -> usize {
    let lines = INPUT
        .lines()
        .map(|line| line.as_bytes())
        .collect::<Vec<_>>();

    let len = lines[0].len();
    let mut scenic_score = 0;

    for i in 1..len - 1 {
        for j in 1..len - 1 {
            let val = lines[i][j];

            let mut right_score = 0;
            let mut bottom_score = 0;
            let mut top_score = 0;
            let mut left_score = 0;

            for k in (0..j).rev() {
                left_score += 1;
                if lines[i][k] >= val {
                    break;
                }
            }

            for k in j + 1..len {
                right_score += 1;
                if lines[i][k] >= val {
                    break;
                }
            }

            for k in (0..i).rev() {
                top_score += 1;
                if lines[k][j] >= val {
                    break;
                }
            }

            for k in i + 1..len {
                bottom_score += 1;
                if lines[k][j] >= val {
                    break;
                }
            }

            let curr_scenic_score = right_score * bottom_score * top_score * left_score;
            if curr_scenic_score > scenic_score {
                scenic_score = curr_scenic_score;
            }
        }
    }

    scenic_score
}
