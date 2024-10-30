use std::env;
use std::fs;

fn main() {
    println!("Hello, world!");

    let args: Vec<String> = env::args().collect();
    dbg!(&args);

    let config = Config::new(&args);

    println!("Read String From {}", config.file_path);
    let contents = fs::read_to_string(config.file_path)
        .expect("Should have access to read file");
    println!("{contents}");
}

struct Config {
    query: String,
    file_path: String,
}

impl Config {
    fn new(args: &[String]) -> Config {
        Self { query: args[1].clone(), file_path: args[2].clone() }
    }
}

