use std::str::Lines;

const INPUT: &str = include_str!("../input.in");

#[derive(Debug)]
enum File {
    NormalFile(u64),
    Directory { name: String, children: Vec<File> },
}

impl File {
    fn append_child(&mut self, child: Self) {
        match self {
            Self::NormalFile(_) => panic!(),
            Self::Directory { children, .. } => children.push(child),
        }
    }

    fn name(&self) -> Option<&str> {
        match self {
            Self::NormalFile(_) => None,
            Self::Directory { name, .. } => Some(name),
        }
    }

    fn children(&self) -> &[File] {
        match self {
            Self::NormalFile(_) => &[],
            Self::Directory { children, .. } => children,
        }
    }

    fn children_mut(&mut self) -> &mut [File] {
        match self {
            Self::NormalFile(_) => &mut [],
            Self::Directory { children, .. } => children,
        }
    }

    fn is_directory(&self) -> bool {
        matches!(self, Self::Directory { .. })
    }

    fn for_each_directory(&self, callback: &mut impl FnMut(&File)) {
        callback(self);
        for child in self.children() {
            if child.is_directory() {
                child.for_each_directory(callback);
            }
        }
    }

    fn size(&self) -> u64 {
        match self {
            Self::NormalFile(size) => *size,
            Self::Directory { children, .. } => {
                let mut size = 0;
                for child in children {
                    size += child.size();
                }
                size
            }
        }
    }
}

fn main() {
    let mut lines = INPUT.lines();
    lines.next(); // skip the "cd /" line

    let mut fs = File::Directory {
        name: "/".to_string(),
        children: vec![],
    };
    interpret_commands(&mut lines, &mut fs);
    println!("The solution for part one is: {}", solve_part_one(&fs));
    println!(
        "The smallest folder up for deletion has the size: {}",
        solve_part_two(&fs)
    );
}

fn solve_part_one(fs: &File) -> u64 {
    let mut sum = 0;
    for child in fs.children() {
        if child.is_directory() {
            let child_size = child.size();
            if child.size() < 100000 {
                sum += child_size;
            }
            let sum_rec = solve_part_one(child);
            sum += sum_rec;
        }
    }
    sum
}

/// Call this with the root of your filesystem!
fn solve_part_two(fs: &File) -> u64 {
    const NEEDED: u64 = 30000000;

    let disk_capacity = 70000000;
    let used_space = fs.size();
    let free_space = disk_capacity - used_space;

    assert!(free_space < NEEDED);

    let mut candidates = vec![];

    fs.for_each_directory(&mut |dir| {
        let size = dir.size();
        if size >= (NEEDED - free_space) {
            candidates.push(size);
        }
    });

    candidates.sort();
    candidates[0]
}

fn interpret_commands(lines: &mut Lines, parent: &mut File) {
    let mut line;
    loop {
        line = match lines.next() {
            Some(l) => l,
            None => return,
        };

        if line.starts_with("$ cd") {
            let name = &line[5..];
            if name == ".." {
                return;
            }
            for child in parent.children_mut() {
                if child.name() == Some(name) {
                    interpret_commands(lines, child)
                }
            }
            continue;
        }

        if line.starts_with("$ ls") {
            continue;
        }

        if line.starts_with("dir") {
            parent.append_child(File::Directory {
                name: line[4..].to_string(),
                children: vec![],
            });
            continue;
        }

        let ws_idx = line.find(|ch: char| ch.is_whitespace()).unwrap();
        let size = line[..ws_idx].parse().unwrap();
        parent.append_child(File::NormalFile(size));
    }
}
