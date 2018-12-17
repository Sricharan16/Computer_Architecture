	mov r3,r0 
	mov r4,0 @rem
	mov r5,0 @sum
	.loop1:@checking for the dedundancy number
		cmp r3,0
		beq .comp
		mod r4,r3,10
		div r3,r3,10
		mov r6, r4
		mov r7, 1
		mov r8, 1
		.loop:
			cmp r8, r6
			bgt .break
			mul r7, r7, r8
			add r8, r8, 1
			b .loop  
		.break:
		  nop
		add r5,r5,r7
		b .loop1
	.comp:
		cmp r5,r0
		beq .endin
		b .done
	.endin:
		mov r1,1
	.done: 
		mov r9,0