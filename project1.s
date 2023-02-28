; loading and opening file
; exiting to error message if file not found
; copying file handle to r2

File: ; Open file section
mov r1,#0
ldr r0, =MyFile
swi 0x66
bcs ErrNoFile
mov r2,r0

; grabs first int (i)
; exits to error if nextInt() cant find any i.e. file is empty
; starts integer count
; starts count for i
; copies first int to register for smallest int

First: ; First int section
swi 0x6c
bcs ErrEmptyFile
mov r7,#1
mov r4,#1
mov r3,r0
mov r6,r3


; grabs next int
; increments int count
; checks if equal
; checks if less than
; checks for smallest int
; loops till empty

ReadInt: ; start of readInt() loop
mov r0,r2
swi 0x6c
bcs NoMore ; readInt cant find anymore ints
add r7,r7,#1
cmp r3,r0
addeq r4,r4,#1
cmp r0,r3
addlt r5,r5,#1
cmp r0,r6
movlt r6,r0
b ReadInt ; jumping to beginning of loop


NoMore: ; post loop - no more ints
mov r0,r2
swi 0x68 ; close file
bcs ErrCantClose

; prints first int (i), count of i, lowest int, and count of ints
; prints spaces in between each
; prints using print int and print string commands
Print: ; start of Print section
mov r0,#1
mov r1,r3
swi 0x6b
bcs ErrCantPrint

mov r0,#' 
swi 0x00 
bcs ErrCantPrint

mov r0,#1
mov r1,r4
swi 0x6b
bcs ErrCantPrint

ldr r1,=BLANK
swi 0x69
bcs ErrCantPrint

mov r0,#1
mov r1,r5
swi 0x6b
bcs ErrCantPrint

ldr r1,=BLANK
swi 0x69
bcs ErrCantPrint

mov r0,#1
mov r1,r6
swi 0x6b
bcs ErrCantPrint

ldr r1,=BLANK
swi 0x69
bcs ErrCantPrint

mov r0,#1
mov r1,r7
swi 0x6b
bcs ErrCantPrint
b Exit


ErrNoFile: ; no file found section
mov r0,#1
ldr r1,=NoFile
swi 0x69 ; print String in r1
b Exit

ErrEmptyFile: ;no int in file section
mov r0,#1
ldr r1,=EmptyFile
swi 0x69
b Exit

ErrCantClose: ; cant close file
mov r0,#1
ldr r1,=CantClose
swi 0x69
b Exit

ErrCantPrint: ; command fails to print
mov r0,#1
ldr r1,=CantPrint
swi 0x69


Exit: ; exit section
swi 0x11 ; exit program


.data

MyFile: .asciz "integers.dat"
BLANK:  .asciz " "
NoFile: .asciz "No file found"
EmptyFile: .asciz "Empty file"
CantClose: .asciz "Cannot Close File"
CantPrint: .asciz "Command failed to print"