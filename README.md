# XSgrep

A lightweight ~200 LoC text based search utility with a naive substring-search agorithm written in X86-64 Assembly.

## How it works
Loops in chunks of 4096 bytes to compare against keyword until it reaches the end of file. 
Prints entire line with line number 


## Usage
./xsgrep [keyword] [filename]

## Assembling
### .asm -> .o (NASM)
```
nasm -f elf64 xsgrep.asm -o xsgrep.o
```

### .o -> Executable binary (GCC)
```
 gcc xsgrep.o -o xsgrep -no-pie -nostdlib
```

## Dependencies
Linux Kernel

## Storage
### 6.0 kB
