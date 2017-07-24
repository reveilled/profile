#! /bin/bash
echo BITS 64 > t.asm
echo $@ >> t.asm
nasm t.asm -O0
xxd t
#rm t.asm t
