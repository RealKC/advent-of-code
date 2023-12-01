static INPUT: &str = include_str!("day1.input");
pub fn solution() {
    part_1(INPUT);
    part_2(INPUT);
}

fn part_1(input: &str) {
    let result: u32 = input
        .lines()
        .map(|line| {
            let (first, last) = line
                .chars()
                .flat_map(|ch| ch.to_digit(10))
                .fold((None, 0), |(first, _), digit| {
                    (first.or(Some(digit)), digit)
                });

            first.unwrap() * 10 + last
        })
        .sum();

    println!("day 1, part 1 result: {result}")
}

fn part_2(input: &str) {
    static DIGITS: &[&str] = &[
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "one", "two", "three", "four", "five", "six",
        "seven", "eight", "nine",
    ];

    let mut acc = 0;
    let mut digits = vec![];
    for line in input.lines() {
        digits.clear();
        digits.reserve(digits.len().saturating_sub(line.len()));

        for i in 0..line.len() {
            for (idx, digit) in DIGITS.iter().enumerate() {
                if line[i..].starts_with(digit) {
                    digits.push(idx % 9 + 1);
                }
            }
        }

        let first = digits.first().unwrap();
        let last = digits.last().unwrap();

        acc += first * 10 + last;
    }

    println!("day 1, part 2 result: {acc}");
}
