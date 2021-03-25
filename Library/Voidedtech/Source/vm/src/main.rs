extern crate clap;
use clap::{App, Arg};
use serde::{Deserialize, Serialize};
use std::env::current_dir;
use std::fs;
use std::path::Path;
use std::process::{exit, Command};
use std::thread;
use std::time;

#[derive(Debug, PartialEq, Serialize, Deserialize)]
struct MountOptions {
    size: String,
    file: String,
    enable: bool,
}

#[derive(Debug, PartialEq, Serialize, Deserialize)]
struct Machine {
    memory: u32,
    root: String,
    kernel: String,
    initrd: String,
    disk: String,
    params: String,
    tty: String,
    mount: MountOptions,
}

fn start_vm(vm: Machine, can_mount: bool) {
    thread::spawn(move || {
        let mut cmd = Command::new("vftool");
        cmd.arg("-k");
        cmd.arg(vm.kernel);
        cmd.arg("-i");
        cmd.arg(vm.initrd);
        cmd.arg("-m");
        cmd.arg(vm.memory.to_string());
        cmd.arg("-d");
        cmd.arg(vm.disk);
        cmd.arg("-a");
        cmd.arg(vm.params);
        cmd.arg("-y");
        cmd.arg(vm.tty);
        if vm.mount.enable && can_mount {
            cmd.arg("-d");
            cmd.arg(to_dmg(&vm.mount.file));
        }
        cmd.current_dir(vm.root);
        match cmd.output() {
            Ok(_) => {}
            Err(e) => {
                println!("unable to run command: {}", e);
            }
        }
    });
}

fn load_config(config: &str) -> Option<Machine> {
    match fs::read_to_string(config) {
        Ok(data) => {
            let machine = serde_yaml::from_str::<Machine>(&data);
            match machine {
                Ok(m) => {
                    return Some(m);
                }
                Err(e) => println!("failed to parse config: {}", e.to_string()),
            }
        }
        Err(e) => println!("failed to load config: {}", e.to_string()),
    }
    return None;
}

fn get_cwd() -> Option<String> {
    let env = current_dir();
    match env {
        Ok(d) => match d.into_os_string().into_string() {
            Ok(s) => {
                return Some(s);
            }
            Err(_) => {
                println!("unable to read cwd");
            }
        },
        Err(e) => {
            println!("unable to get cwd: {}", e);
        }
    }
    None
}

fn to_dmg(file_name: &str) -> String {
    let mut s = String::new();
    s.push_str(&file_name.to_string());
    s.push_str(".dmg");
    s
}

fn main() {
    let matches = App::new("vm")
        .version("1.0")
        .arg(
            Arg::with_name("config")
                .long("config")
                .value_name("CONFIG")
                .help("vm configuration file")
                .takes_value(true),
        )
        .arg(
            Arg::with_name("vm")
                .long("vm")
                .value_name("VMPATH")
                .help("vm root path")
                .takes_value(true),
        )
        .arg(
            Arg::with_name("timeout")
                .long("timeout")
                .value_name("TIMEOUT")
                .help("timeout waiting for tty")
                .takes_value(true),
        )
        .arg(
            Arg::with_name("mount")
                .long("mount")
                .help("mount the directory")
                .takes_value(false),
        )
        .get_matches();
    let timeout_raw = matches.value_of("timeout").unwrap_or("5");
    let timeout = match timeout_raw.parse::<u64>() {
        Ok(v) => v,
        Err(e) => {
            println!("unable to parse timeout: {}", e);
            exit(1);
        }
    };
    let can_mount = matches.is_present("mount");
    let root = matches.value_of("root").unwrap_or("/Users/enck/VM/");
    let default_cfg = root.to_owned() + "vm.yaml";
    let cfg = matches.value_of("config").unwrap_or(default_cfg.as_str());
    let machine = load_config(cfg);
    if machine == None {
        exit(1);
    }
    let vm = machine.unwrap();
    let tty_file = Path::new(&vm.root.to_string()).join(&vm.tty.to_string());
    if tty_file.exists() {
        match fs::remove_file(&tty_file) {
            Ok(_) => {}
            Err(e) => {
                println!("unable to remove tty file: {}", e);
                exit(1);
            }
        }
    }
    if vm.mount.enable && can_mount {
        println!("creating mounted image");
        let dmg = to_dmg(&vm.mount.file);
        let path = Path::new(&vm.root.to_string()).join(dmg.as_str());
        if path.exists() {
            match fs::remove_file(path) {
                Ok(_) => {}
                Err(e) => {
                    println!("unable to delete old mount file: {}", e);
                    exit(1);
                }
            }
        }
        let work_dir = get_cwd();
        match work_dir {
            Some(val) => {
                let cmd = Command::new("hdiutil")
                    .arg("create")
                    .arg(&vm.mount.file)
                    .arg("-size")
                    .arg(&vm.mount.size)
                    .arg("-srcfolder")
                    .arg(&val)
                    .arg("-fs")
                    .arg("exFAT")
                    .arg("-format")
                    .arg("UDRW")
                    .current_dir(&vm.root)
                    .status()
                    .expect("hdiutil failed");
                if !cmd.success() {
                    println!("hdiutil unable to make image");
                }
            }
            None => {
                exit(1);
            }
        }
    }
    println!("starting vftool");
    start_vm(vm, can_mount);
    println!("waiting for vftool to come online");
    manage(timeout, tty_file);
}

fn manage(timeout: u64, tty_file: std::path::PathBuf) {
    let duration = time::Duration::from_secs(timeout);
    thread::sleep(duration);
    if !tty_file.exists() {
        println!("tty file not found");
        return;
    }
    println!("vftool is online");
    match fs::read_to_string(tty_file) {
        Ok(data) => match Command::new("screen").arg(data.trim()).status() {
            Ok(_) => {}
            Err(e) => {
                println!("unable to attach: {}", e);
                return;
            }
        },
        Err(e) => {
            println!("unable to read tty file: {}", e);
            return;
        }
    }
}
