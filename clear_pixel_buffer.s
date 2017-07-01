 ################ 
 # Caller Saved: 
 # r8: pixel address 
 # r10: x-pos 
 # r11: y-pos 
 # r12: x loop condition 
 # Callee Saved: 
 # r16: internal computation 
 # r17: internal computation 
 # r18: internal computation 
 ################ 
 # x starts from zero 
 # y starts from 239 and decrease to zero 
 # 2*x + 1024 * y 
 
 
 .data
.global start_picture
 start_picture: .incbin "start.bmp" , 70
 backg1: .incbin "level1.bmp" , 70
 backg2: .incbin "backg.bmp" , 70
 backg3: .incbin "level3.bmp",70
 win: .incbin "you_win.bmp",70
 .global levelchoice
 levelchoice: .word start_picture, backg1, backg2,backg3,win
 .global currentLevel
 currentLevel: .word start_picture
 .global levelCount
 levelCount: .word 0
 .section .text 
 
 
 .equ PIX_ADDR,0x08000000 
 
 
 .global clear_pixel_buffer 
 
 
clear_pixel_buffer: 


	
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
	
	movia r14, 0xFF203024
	ldwio r8,0(r14)

	
	
	movia r9,currentLevel
	ldw r9,0(r9)
 	#movia r9, backg 					# initialize the pixel pointer 
 	movi r10, 0  				# initial x coordinate 
 	movi r11, 0			        # initial y coordinate 
 	movi r22, 0  				# initial x coordinate 
 	movi r23, 0			        # initial y coordinate 
 	addi r12,r10,320
	addi r20,r11,240
 
	
 
 Loop:
	ldhio r13,0(r9)
	muli r16,r10,2				#however many x coordinate offset
	muli r17,r11,1024 
	add r16,r16,r17 
 	add r18,r16,r8
	sthio r13,0(r18)       # store pixel information into buffer
	addi r10,r10,1
	addi r9,r9,2
	blt r10,r12,Loop 
 	mov r10,r22   				# reset x to inital x 
 	addi r11,r11,1  			# y coordinate decrement 
	blt r11,r20,Loop 			# outter y loop 
	
	
	
	#movi r16,1
	#movia r17,buffer
	#stw r16,0(r17)
	

 
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