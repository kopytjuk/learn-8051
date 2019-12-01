# Learn 8051

A collection of 8051 EdSim51 programs used to understand the 8051 architecture.

![edsim.png](edsim.png)

## Understanding Stack Pointers

[understanding-stack.asm](understanding-stack.asm) shows the behaviour of 8051 stack pointer.

## Path from C file to 8051 byte code

First install `sdcc` (a small cross compiler for various microcontrollers, [http://sdcc.sourceforge.net/](http://sdcc.sourceforge.net/)) on your machine. For Windows 10, pre compiled binaries were used. Optionally, add SDCC to `PATH` in order to run `sdcc` from any arbitrary path on your machine.

Take a look of the [example](from-c-to-opcode\addition.c) `.c` file  - we will use its logic to examine the assembly and byte code on the 8051:

```C
// addition.c
#include <8051.h>

void main(void)
{   
    for (int i=0; i<3; i++){
        char x = P1;
        x = x - 5;
        P1 = x;
    }
}
```

Let's compile it:

```cmd
sdcc .\from-c-to-opcode\addition.c -o .\from-c-to-opcode\
```

After this command a lot of files are generated in the output folder. One of them is the assembly code derived from our logic in C.

Let's examine the [`addition.asm`](from-c-to-opcode\addition.asm) file. We ignore the various assembly assembly meta-commands and focus on the essentials for this tutorial:

```assembly
.org 0x0000

__interrupt_vect:
	ljmp	__sdcc_gsinit_startup

__sdcc_program_startup:
	ljmp	_main

;	.\from-c-to-opcode\addition.c:5: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	.\from-c-to-opcode\addition.c:7: for (int i=0; i<3; i++){
	mov	r6,#0x00
	mov	r7,#0x00
00103$:
	clr	c
	mov	a,r6
	subb	a,#0x03
	mov	a,r7
	xrl	a,#0x80
	subb	a,#0x80
	jnc	00105$
;	.\from-c-to-opcode\addition.c:8: char x = P1;
;	.\from-c-to-opcode\addition.c:9: x = x - 0x34;
	mov	a,_P1
	add	a,#0xfb
	mov	_P1,a
;	.\from-c-to-opcode\addition.c:7: for (int i=0; i<3; i++){
	inc	r6
	cjne	r6,#0x00,00103$
	inc	r7
	sjmp	00103$
00105$:
;	.\from-c-to-opcode\addition.c:12: }
	ret
```

Let's examine the code step for step.

First we take a look on the code within the loop:

```assembly
mov	a,_P1
add	a,#0xfb
mov	_P1,a
```

Instead of using the `subb` operation - we "misuse" the `add` operation and the fact how negative numbers are represented in most microcontrollers. Since Two's complement is used for representing negative numbers we can just rewrite to `x = -5 + x` or `x = 0xFB + x`.

Since those three operations presented above are located in code memory one after the other we can translate it into operation codes we find in the 8051 datasheet:

```
mov	a,_P1   -> 0xE5 0x90
add	a,#0xfb -> 0x24 0xFB
mov	_P1,a   -> 0xF5 0x90
```

or in one line:

```
E59024FBF590
```

We find this string in the [addition.ihx](from-c-to-opcode\addition.ihx#L4) hex file which is flashed to the ROM.

The address of `_P1` is `0x90`.

First, we need to initialize the iterator variable `i` in the `for` loop.