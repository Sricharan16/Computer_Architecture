.main:
 mov r0,123   /*we can change our input here*/
 mov r3,r0
 mov r1,0
 mov r9,0
 mov r5,0
 b .calculate   /*calculating the sum*/
   .calculate:
     mod r2,r0,10
     mov r6,1
     mov r7,r2
     b .power     /*for calculating power*/
        .power:
        mul r6,r6,r2
        sub r7,r7,1
        cmp r7,0
        bgt .power
     
     add r5,r5,r6
     div r0,r0,10
     cmp r0,r9
     bgt .calculate
 
  .print r5
  cmp r5,r3
  beq .result 
  b .end
  .result:
     mov r1,1
  .end:                /*printing the final value*/
     .print r1
