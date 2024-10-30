use std::env;
use std::fs;

fn main() {
    println!("Hello, world!");

    let args: Vec<String> = env::args().collect();
    dbg!(&args);

    let (query, file_path) = parse_config(&args);
    println!("{query} and {file_path}");

    let contents = fs::read_to_string(file_path);
}

fn parse_config(args: &[String]) -> (&str, &str) {
    // (&args[1], &args[2])
    let query = &args[1];
    let file_path = &args[2];

    (query, file_path)
}
