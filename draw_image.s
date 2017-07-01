 ################ 
 # Input Argument: 
 # r4: pointer to image to display 
 # r5: starting x-pos
 # r6: starting y-pos
 # r7; x-size
 # stack 0 = ysize
 # Caller Saved: 
 # r8: pixel address 
 # r9: pixel pointer 
 # r10: x-pos 
 # r11: y-pos 
 # r12: x loop condition 
 # r13: pixel data 
 # r14: inital buffer address
 # Callee Saved: 
 # r16: internal computation 
 # r17: internal computation 
 # r18: internal computation 
 # r20: yLoop condition
 # r21: ysize 
 # r22: starting x-pos 
 # r23: starting y-pos 
.data

 
 .section .text 
 
 .equ buffer, 0xFF203020
 .equ PIX_ADDR,0x08000000 
 
 
 .global draw_image 
 
 
 draw_image: 
 
	
	
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
	
	
	
reloop:
	movia r16,0xFF20302C
	ldwio r16,0(r16)
	andi r16,r16,0x01
	bne r0,r16,reloop

	
	
	ldw r21,44(sp)				#important, not a mistake
	
	movia r14, 0xFF203024
	ldw r8,0(r14)
	
 	#movia r8, PIX_ADDR 			# initialize the pixel buffer address 
 	mov r9, r4 					# initialize the pixel pointer 
 	mov r10, r5  				# initial x coordinate 
 	mov r11, r6			        # initial y coordinate 
 	mov r22, r5  				# initial x coordinate 
 	mov r23, r6			        # initial y coordinate 
 	add r12,r10,r7
	add r20,r11,r21
	movia r6,0x0FFFF
	andi r6,r6,0x0FFFF
 
 Loop:
	ldhio r13,0(r9)
	andi r13,r13,0x0FFFF
	beq r13,r6,Increment
	muli r16,r10,2				#however many x coordinate offset
	muli r17,r11,1024 
	add r16,r16,r17 
 	add r18,r16,r8
	sthio r13,0(r18)       # store pixel information into buffer
Increment:
	addi r10,r10,1
	addi r9,r9,2
	blt r10,r12,Loop 
 	mov r10,r22   				# reset x to inital x 
 	addi r11,r11,1  			# y coordinate decrement 
	blt r11,r20,Loop 			# outter y loop 
	
	
	

	

 
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
