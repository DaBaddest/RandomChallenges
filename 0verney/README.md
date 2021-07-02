# 0verney
[Download Link](https://crackmes.one/crackme/6049f27f33c5d42c3d016dea)

This crackme shows an interesting concept that we mostly just ignore when we are solving crackmes.

Checking the file type

```bash
D:\Wargames\Crackmes.one\0verney>file 0verney
0verney; ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 3.2.0, not stripped
```

So its a 64bit Linux binary. It is not stripped, so we have the symbols, which is already 50% of the work done (but in this crackme this doesnt really matter).

I will be statically analysing the binary.

The file is small (only 17KB). Opening the file in binary ninja, and disassembling main

```asm
main:
push    rbp {__saved_rbp}
mov     rbp, rsp {__saved_rbp}
sub     rsp, 0x10
mov     dword [rbp-0x4 {var_c}], edi
mov     qword [rbp-0x10 {var_18}], rsi
lea     rdi, [rel data_402004]  {"Hello there!"}
call    puts
mov     eax, 0x0
leave    {__saved_rbp}
retn     {__return_addr}
```

The code is super short and all it does is print "Hello there!". But where is the main crackme code.

One thing that is not usually ignore are the constructors and destructors. But you might be wondering constructors and destructors in C? Some compilers allows constructors and destructors to be declared in C. The example code is given below.

```c
__attribute__((constructor)) void cons(){
  puts("Constructor Called");
}
__attribute__((destructor)) void cons(){
  puts("Destructor Called");
}
void main(){
  puts("MAIN");
}
```

So now we know that there is some code which is run before and after main, we can start our analysis.

So how do we get that code. One way is to use a debugger and trace the execution, but I am not going to try it, we will do it statically.

Lets take a look at `_start`, this is where the execution starts
```asm
_start:
endbr64 
xor     ebp, ebp  {0x0}
mov     r9, rdx
pop     rsi {__return_addr}
mov     rdx, rsp {arg_8}
and     rsp, 0xfffffffffffffff0
push    rax {var_8}
push    rsp {var_8} {var_10}
mov     r8, __libc_csu_fini
mov     rcx, __libc_csu_init
mov     rdi, main
call    qword [rel __libc_start_main@GOT]
{ Does not return }
```

The first thing that runs before main and after _start is the `__libc_csu_init`, lets disassemble that

```asm
__libc_csu_init:
endbr64 
push    r15 {__saved_r15}
lea     r15, [rel __init_array_start]
push    r14 {__saved_r14}
mov     r14, rdx
push    r13 {__saved_r13}
mov     r13, rsi
push    r12 {__saved_r12}
mov     r12d, edi
push    rbp {__saved_rbp}
lea     rbp, [rel __init_array_end]
push    rbx {__saved_rbx}
sub     rbp, r15
sub     rsp, 0x8
call    _init
```

`__init_array_start` contains the list of constructors to be called and `__init_array_end` contains the list of destructors to be called.

Lets jump to __init_array_start, it only contains one entry, i.e there is only one constructor having the address 0x0c003f7e

Jumping to that address, we see a syscall being made and it is calling **PTRACE**, a standard anti-debugging trick.

```asm
mov     eax, 0x65
xor     rdi, rdi  {0x0}
xor     rsi, rsi  {0x0}
xor     r10, r10  {0x0}
xor     rdx, rdx
inc     rdx  {0x1}
jmp     0xc003f9e
syscall
```

If it determines that a debugger is attached, it will just exit, and never reach main. One can easily patch out this to never exit, but we dont care as we are just analysing it statically.

So all the constructor does it just check if a debugger is attached or not.

Lets check at the destructors which is present at 0xc003ef8.

Jumping there we see it clears out some registers and calls another function.

In this function, we see a syscall for mmap with the length as 0x2b4, which means some code might be placed there.

Then it loads the return address in r12, we can get the return address by going back one function and copying the address which is next to the call instruction
```asm
pop     r12 {__return_addr}
sub     r12, 0xc3
```

And using that it does some operations

```asm
0c003f4e  b060               mov     al, 0x60
0c003f50  4831d2             xor     rdx, rdx  {0x0}

0c003f53  eb02               jmp     0xc003f57

0c003f55                                                                 a0 cf                                                  ..

0c003f57  418a143c           mov     dl, byte [r12+rdi]
0c003f5b  4881ffc2000000     cmp     rdi, 0xc2
0c003f62  7606               jbe     0xc003f6a

0c003f64  eb02               jmp     0xc003f68

0c003f66                    df 34                                                                                .4

0c003f68  30c2               xor     dl, al

0c003f6a  88143b             mov     byte [rbx+rdi], dl
0c003f6d  48ffc7             inc     rdi
0c003f70  e2e1               loop    0xc003f53

0c003f72  4989df             mov     r15, rbx
0c003f75  4881c3c3000000     add     rbx, 0xc3
0c003f7c  ffe3               jmp     rbx
```

After analyzing the code above, all it does is copy the first 0xc2 bytes from r12 as it is, and after that it xors the bytes with 0x60.


We can write some simple python code to do that.

```py
r12 = 0x3fbb - 0xc3
rcx = 0x2b4

fp = open("0verney", "rb")
fp.seek(r12)

l = []
for i in range(rcx):
  rdx = ord(fp.read(1).decode('charmap'))
  if i > 0xc2:
    rdx = 0x60 ^ rdx
  l.append(chr(rdx).encode('charmap'))

print(l)

open("code", "wb").write(b''.join(l))
```
If you have the pro version on binary ninja, we can do this opertion in that itself without the need to write the code

So now we have the code in a file, we need to disassemble this. There are multiple ways of doing it
1. Using `ndisasm` using the command
`ndisasm -b64 code`

2. Disassembling using `distorm3`, a package for python

3. Using binary ninja

Lets use distorm3 to disassemble this code.

```py
import distorm3
data = open("code", "rb").read()

inst = distorm3.Decode(0, data, distorm3.Decode64Bits)

for i in inst:
  if 'DB' not in i[2]:    # removing instructions which are not disassmbled
      print(hex(i[0]), i[2])
```

Saving the output to a file `code.asm`

Looking at that code we find some ascii looking data as line 84

```asm
00000100  6842616421        push qword 0x21646142  ;Bad!
00000105  B801000000        mov eax,0x1
0000010A  BF01000000        mov edi,0x1
0000010F  4889E6            mov rsi,rsp
00000112  BA05000000        mov edx,0x5
00000117  0F05              syscall
00000119  EB19              jmp short 0x134
0000011B  6847303064        push qword 0x64303047  ;G00d
00000120  B801000000        mov eax,0x1
00000125  BF01000000        mov edi,0x1
0000012A  4889E6            mov rsi,rsp
0000012D  BA06000000        mov edx,0x6
00000132  0F05              syscall
```

Which means it is checking for something. Lets see how good is printed.

Just above this code, we find this
```asm
000000F6  B8D9483DAB        mov eax,0xab3d48d9
000000FB  AC                lodsb
000000FC  0000              add [rax],al
000000FE  741B              jz 0x11b    ;Good 
```

But the code doesnt make much sense. So I stopped here and opened the file in binary ninja.

We just need to set the architecute to be Linux 64bit.

Now looking at the disassembly

```asm
000100ec  b875af0000         mov     eax, 0xaf75
000100f1  4831d8             xor     rax, rbx
000100f4  eb02               jmp     0x100f8

000100f8  483dabac0000       cmp     rax, 0xacab
```

Now the code makes much more sense.

It loads 0xaf75 into rax, and xor of our input and rax should be equal to 0xacab

`rax ^ input == 0xacab
i.e. input = 0xacab ^ rax = 0xacab ^ 0xaf75`

Which gives us the correct `input = 990`

