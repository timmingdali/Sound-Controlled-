 .section .text 
 
 
 .equ CHAR_ADDR,0x09000000  
 
 .global writeChar 
 
 
 writeChar: 
 	subi sp,sp,44 
 	stw r16,0(sp) 
 	stw r17,4(sp)
	stw r18,8(sp)
	stw r19,12(sp)
	stw r20,16(sp)
	stw r21,20(sp)
	stw r22,24(sp)
	stw r23,28(sp)
	stw r26,32(sp)
	stw r27,36(sp)
	stw r28,40(sp)
 
  	movia r8, CHAR_ADDR 			# initialize the pixel buffer address 
 	movi r18, 77  					# initialize x coordinate 
 	movi r11, 0 					# initialize y coordinate 
 	movui r12, 80 					# end inner loop condition 
 	movui r13,0  					# outter loop condition 
 

 Loop: 
 	muli r16,r11,128 
 	add r16,r18,r16 
 	add r17,r16,r8 
	movi r20,57
 	stbio r20,0(r17) 
 
 
 	#increment 
 	addi r18,r18,1   				# x coordinate increment 
 	blt r18,r12,Loop 				# inner x loop 
 
 
 	mov r18,r0 						# reset x position 
 	addi r11,r11,1  				# y coordinate decrement 
 	blt r11,r13,Loop 				# outter y loop 
 
 
 Exit: 
 	ldw r16,0(sp) 
 	ldw r17,4(sp) 
	ldw r18,8(sp)
	ldw r19,12(sp)
	ldw r20,16(sp)
	ldw r21,20(sp)
	ldw r22,24(sp)
	ldw r23,28(sp)
	ldw r26,32(sp)
	ldw r27,36(sp)
	ldw r28,40(sp)
 	addi sp,sp,44 
 	ret 