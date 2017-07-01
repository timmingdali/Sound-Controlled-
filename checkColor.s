.global check_y
check_y:
	addi sp,sp,-32 
 	stw r16,0(sp) 
 	stw r17,4(sp) 
 	stw r18,8(sp) 
	stw r19,12(sp) 
	stw r20,16(sp) 
	stw r21,20(sp) 
	stw r22,24(sp) 
	stw r23,28(sp) 
	
	mov r16,r0 #incremant counter set to 0
	mov r17,r0 #initial black spot count set to 0
	movi r18,36 #all 36 base points
	
	
	
	movia r19,0xFFFF #white colour
	
	
	
	movia r20,0xFF203024 #addess of backbuffer
	ldwio r20,0(r20)
	mov r21,r5							#y coordinate
	addi r21,r21,50						#now r21 points to bottom ys'
	mov r22,r4							#now r22 is the leftest x cooridinate
checkYLoop:
	muli r15,r22,2				
	muli r14,r21,1024 
	add r15,r15,r14 
 	add r13,r15,r20
	ldhio r12,0(r13)
	andi r12,r12,0x0FFFF
	
	
	beq r12,r0,return1					#if black beneath, return 1
	beq r12,r19,return0
	br Fail
	

Fail:	
	movi r2,3
	br leaveCheckY

return1:
	movi r2,1
	br leaveCheckY
return0:
	movi r2,0
	br leaveCheckY
	
	
leaveCheckY:	
	ldw r16,0(sp) 
 	ldw r17,4(sp) 
 	ldw r18,8(sp) 
	ldw r19,12(sp) 
 	ldw r20,16(sp) 
 	ldw r21,20(sp) 
	ldw r22,24(sp) 
 	ldw r23,28(sp) 
 	addi sp,sp,32
	ret
	