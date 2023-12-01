use std::env;

mod day1;

fn main() {
    let Some(day) = env::args().nth(1) else {
        eprintln!("Provide the day for which the solution should be executed");
        return;
    };

    match day.as_ref() {
        "day1" => day1::solution(),
        day => eprintln!("Unimplemented solution for day {day}"),
    }
}
