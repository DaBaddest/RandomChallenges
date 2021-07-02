# Part1
base = 0x400000
r12 = 0x3fbb - 0xc3
rcx = 0x2b4
rdi = 0xc2
rdi = 0
rax = 0x60

fp = open("0verney", "rb")
fp.seek(r12)

l = []
for i in range(rcx):
  rdx = ord(fp.read(1).decode('charmap'))
  if rdi > 0xc2:
    rdx = rax ^ rdx
  rdi += 1
  l.append(chr(rdx).encode('charmap'))

print(l)

open("shellcode", "wb").write(b''.join(l))

# Part2
import distorm3
data = open("shellcode", "rb").read()

inst = distorm3.Decode(0, data, distorm3.Decode64Bits)

for i in inst:
  if 'DB' not in i[2]:
    print(hex(i[0]), i[2])
