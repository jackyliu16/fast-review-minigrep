use std::fs;

fn parse_config(args: &[String]) -> (&str, &str) {
    (&args[1], &args[2])
}
