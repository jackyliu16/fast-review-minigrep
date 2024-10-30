use std::env;
use std::fs;

fn main() {
    println!("Hello, world!");

    let args: Vec<String> = env::args().collect();
    dbg!(&args);

    let file_path = &args[1]; // 0 is this file name

    let contents = fs::read_to_string(&file_path).expect("Should have been able to read the file");

    println!("with text:\n{contents}");
}
