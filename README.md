# XSgrep

A lightweight (~200 LoC) text-based search utility with a naive substring-search algorithm written in x86-64 Assembly. Designed for high performance and minimal overhead.

##  Features

- **Lightweight**: ~200 lines of assembly code, 6.0 kB binary size
- **Fast**: Direct syscall implementation without standard library overhead
- **Simple**: Naive substring-search algorithm for reliable pattern matching
- **Pure x86-64**: Written entirely in assembly for maximum control and minimal dependencies
- **Line-based output**: Shows complete lines with line numbers for matched results

## Usage

```bash
./xsgrep [keyword] [filename]
```

## Building

### Prerequisites
- NASM 
- GCC 
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

## Requirements

- **OS**: Linux (kernel required for syscalls)
- **Architecture**: x86-64
- **Assembler**: NASM
- **Linker**: GCC (or compatible)

## Performance

| Metric | Value |
|--------|-------|
| Binary Size | 6.0 kB |
| Code Size | ~200 LoC |
| Memory Overhead | Minimal (two 4KB buffers) |
| Algorithm | Naive substring search O(n×m) |

## How It Works

XSgrep processes files efficiently using a chunked reading approach:

1. **Chunked Reading**: Reads the file in 4096-byte chunks to balance memory usage and I/O efficiency
2. **Line Buffering**: Accumulates bytes into a line buffer until a newline character is encountered
3. **Substring Matching**: Performs a naive substring search (character-by-character comparison) on each line
4. **Output**: Prints matching lines with their corresponding line numbers


**Why x86-64 Assembly?**
- Zero standard library overhead
- Direct syscall access
- Full control over memory and execution
- Minimal resource footprint




