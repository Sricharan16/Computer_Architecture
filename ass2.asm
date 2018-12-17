assign:
mov r2,r4
ret 
.main:
mov r3, 6 @ r3 stores the array size
@begin array element initialization up to the array size
mov r1, 13
st r1, 0[r0] @element 1
mov r1, 2
st r1, 4[r0] @element 2
mov r1, 32
st r1, 8[r0] @element 3
mov r1, 4
st r1, 12[r0] @element 4
mov r1, 0
st r1, 16[r0] @element 5
mov r1, 16
st r1, 20[r0] @element 6
ld r1,20[r0]
.print r1
ld r2,0[r0]
mov r5,4
b .loop
  .loop:
  ld r4,4[r0]
  sub r3,r3,1
  cmp r4,r2
  bgt .assign
  add r0,r0,4
  cmp r3,0
  bgt .loop
.print r2
  
