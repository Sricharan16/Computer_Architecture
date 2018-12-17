.main:
	movu r0,19687
	mov r1,0
	mov r2,0
	mov r3,r0 
	mov r4,0 @rem
	mov r5,0 @sum
	.loop2:@checking for the factorian number
		cmp r3,0
		beq .compi
		mod r4,r3,10
		div r3,r3,10
		mov r6, r4
		mov r7, 1
		mov r8, 1
		.loop:
			cmp r7, r6
			bgt .break
			mul r8, r8, r7
			add r7, r7, 1
			b .loop  
		.break:
		  add r5,r5,r8
	   	b .loop2
	.compi:
		cmp r5,r0
		beq .endini
		b .donei
	.endini:
		mov r1,1
	.donei: 
		mov r9,0
	mov r5,r0 
	mov r6,0 @rem
	mov r7,0 @sum
	.loop1:@checking for the dedundancy number r5,6,7,2,9
		cmp r5,0
		beq .comp
		mod r6,r5,10
		div r5,r5,10
		add r7,r7,r6
		b .loop1
	.comp:
		mov r6,1
		mul r6,r6,r7
		mul r6,r6,r7
		mul r6,r6,r7
		cmp r6,r0
		beq .endin
		b .done
	.endin:
		mov r2,1
	.done: 
		mov r9,0
.print r1
.print r2

	

