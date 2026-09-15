# XSgrep

A lightweight (~200 LoC) text-based search utility with a naive substring-search algorithm written in x86-64 Assembly. Designed for high performance and minimal overhead.

## 📋 Table of Contents
- [Features](#features)
- [How It Works](#how-it-works)
- [Usage](#usage)
- [Building](#building)
- [Requirements](#requirements)
- [Performance](#performance)
- [Examples](#examples)

## ✨ Features

- **Lightweight**: ~200 lines of assembly code, 6.0 kB binary size
- **Fast**: Direct syscall implementation without standard library overhead
- **Simple**: Naive substring-search algorithm for reliable pattern matching
- **Pure x86-64**: Written entirely in assembly for maximum control and minimal dependencies
- **Line-based output**: Shows complete lines with line numbers for matched results

## 🔍 How It Works

XSgrep processes files efficiently using a chunked reading approach:

1. **Chunked Reading**: Reads the file in 4096-byte chunks to balance memory usage and I/O efficiency
2. **Line Buffering**: Accumulates bytes into a line buffer until a newline character is encountered
3. **Substring Matching**: Performs a naive substring search (character-by-character comparison) on each line
4. **Output**: Prints matching lines with their corresponding line numbers

### Algorithm Complexity
- **Time**: O(n × m) where n is total file size and m is keyword length
- **Space**: O(1) for buffering (fixed 4KB buffers)

## 🚀 Usage

```bash
./xsgrep [keyword] [filename]
```

### Arguments
- `keyword`: The text pattern to search for
- `filename`: Path to the file to search

### Examples

```bash
# Search for "error" in a log file
./xsgrep error system.log

# Search for a function name
./xsgrep main_function code.c

# Search with special characters
./xsgrep "TODO:" notes.txt
```

### Output Format

Matching lines are printed with their line numbers:
```
5:Error occurred in processing
42:Critical error in module X
```

Special cases:
- **No matches**: Prints "No results found"
- **Invalid arguments**: Prints usage information
- **File not found**: Prints "Could not open file"

## 🔨 Building

### Prerequisites
- NASM (Netwide Assembler)
- GCC (for linking)
- Linux kernel (x86-64)

### Assembly Steps

**Step 1: Assemble to object file**
```bash
nasm -f elf64 xsgrep.asm -o xsgrep.o
```

**Step 2: Link to executable**
```bash
gcc xsgrep.o -o xsgrep -no-pie -nostdlib
```

### One-liner Build
```bash
nasm -f elf64 xsgrep.asm -o xsgrep.o && gcc xsgrep.o -o xsgrep -no-pie -nostdlib
```

## 📦 Requirements

- **OS**: Linux (kernel required for syscalls)
- **Architecture**: x86-64
- **Assembler**: NASM
- **Linker**: GCC (or compatible)

## ⚡ Performance

| Metric | Value |
|--------|-------|
| Binary Size | 6.0 kB |
| Code Size | ~200 LoC |
| Memory Overhead | Minimal (two 4KB buffers) |
| Algorithm | Naive substring search O(n×m) |

**Why x86-64 Assembly?**
- Zero standard library overhead
- Direct syscall access
- Full control over memory and execution
- Minimal resource footprint

## 📝 Examples

### Search Log File
```bash
$ ./xsgrep "ERROR" system.log
3:Error occurred in processing
12:Critical error in module X
45:Database unreachable
```

### Search Source Code
```bash
$ ./xsgrep "malloc" program.c
8:void* ptr = malloc(sizeof(int));
25:char* buffer = malloc(256);
```

### No Matches
```bash
$ ./xsgrep "notfound" data.txt
No results found
```

## 🛠️ Implementation Details

### Key Registers Used
- `r13`: Keyword pointer
- `r14`: Filename pointer
- `r15`: File descriptor
- `r12`: Keyword length
- `rbx`: Current line number
- `r8`: Current position in line buffer
- `r9`: Match found flag
- `r10`/`r11`: Loop counters

### Syscalls Used
- `open` (2): Open file
- `read` (0): Read file chunks
- `write` (1): Print output
- `exit` (60): Terminate program

## 📄 License

[Add your license information here]

## 🤝 Contributing

[Add contribution guidelines here]
