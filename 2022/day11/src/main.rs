use std::fmt::Debug;

const INPUT: &str = include_str!("../input.in");

struct Monkey {
    items: Vec<u64>,
    operation: Box<dyn Fn(u64) -> u64>,
    test: u64,
    if_true: usize,
    if_false: usize,
}

impl Debug for Monkey {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Monkey")
            .field("items", &self.items)
            .field("test", &self.test)
            .field("if_true", &self.if_true)
            .field("if_false", &self.if_false)
            .finish_non_exhaustive()
    }
}

impl Monkey {
    fn parse(string: &str) -> Self {
        let mut lines = string.lines();
        lines.next(); // skip first line as it's just "Monkey #idx" and we get that for free.

        let items = lines.next().unwrap()[18..]
            .split(',')
            .map(|s| s.trim().parse().unwrap())
            .collect::<Vec<_>>();

        let operation = &lines.next().unwrap()[23..];
        let operation: Box<dyn Fn(u64) -> u64> = {
            let mut is_plus = false;
            let op = operation.chars().next().unwrap();
            if op == '+' {
                is_plus = true;
            }
            let term = operation[2..].parse::<u64>();
            if let Ok(term) = term {
                if is_plus {
                    Box::new(move |old| old + term)
                } else {
                    Box::new(move |old| old * term)
                }
            } else if is_plus {
                Box::new(|old| old + old)
            } else {
                Box::new(|old| old * old)
            }
        };

        let test = lines.next().unwrap()[21..].parse().unwrap();
        let if_true = lines.next().unwrap()[29..].parse().unwrap();
        let if_false = lines.next().unwrap()[30..].parse().unwrap();
        Self {
            items,
            operation,
            test,
            if_true,
            if_false,
        }
    }
}

fn main() {
    println!("The answer for part one is: {}", solve_part_one());
    println!("The answer for part two is: {}", solve_part_two());
}

enum WorryManager {
    DivideByThree,
    DivisorProduct(u64),
}

impl WorryManager {
    fn eval(&self, item: u64) -> u64 {
        match self {
            WorryManager::DivideByThree => item / 3,
            WorryManager::DivisorProduct(product) => item % product,
        }
    }
}

fn compute_monkey_business(monkeys: &mut [Monkey], rounds: usize, wm: WorryManager) -> u64 {
    let mut inspections = vec![0; monkeys.len()];

    for _ in 0..rounds {
        for i in 0..monkeys.len() {
            for j in 0..monkeys[i].items.len() {
                let item = monkeys[i].items[j];
                let item = wm.eval((monkeys[i].operation)(item));

                let idx = if item % monkeys[i].test == 0 {
                    monkeys[i].if_true
                } else {
                    monkeys[i].if_false
                };

                monkeys[idx].items.push(item);
                inspections[i] += 1;
            }
            monkeys[i].items.clear();
        }
    }

    inspections.sort();

    inspections[inspections.len() - 2..].iter().product()
}

fn solve_part_one() -> u64 {
    let mut monkeys = INPUT.split("\n\n").map(Monkey::parse).collect::<Vec<_>>();
    compute_monkey_business(&mut monkeys, 20, WorryManager::DivideByThree)
}

fn solve_part_two() -> u64 {
    let mut monkeys = INPUT.split("\n\n").map(Monkey::parse).collect::<Vec<_>>();
    let divisor_product = monkeys.iter().map(|m| m.test).product();
    compute_monkey_business(
        &mut monkeys,
        10_000,
        WorryManager::DivisorProduct(divisor_product),
    )
}
