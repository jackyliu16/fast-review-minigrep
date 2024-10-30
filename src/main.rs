use std::env;
use std::fs;
use std::process;

use ripgrep_tutorial::Config;

fn main() {
    println!("Hello, world!");

    let args: Vec<String> = env::args().collect();
    dbg!(&args);

    let config = Config::new(&args).unwrap_or_else(|err| {
        println!("Problem parsing arguments: {err}");
        process::exit(1);
    });

    println!("Searching for {}", config.query);
    println!("Read String From {}", config.file_path);

    if let Err(e) = ripgrep_tutorial::run(config) {
        println!("Problem parsing arguments: {e}");
        process::exit(1);
    }
}


