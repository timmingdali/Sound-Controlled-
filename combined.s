.equ ADDR_AUDIODACFIFO, 0xFF203040
.equ KEYBOARD_ADDRESS, 0xFF200100
.equ LEDS, 0xFF200000
.equ BUTTONS, 0xFF200050
.equ TIMER, 0xFF202000
.equ TIMER2, 0xFF202020
.equ TIMERPERIOD, 20000000 								#1/10 seconds
.equ TIMER2PERIOD, 10000000									#.1 second




.data
	win: .word 0
	start_picture_check: .word 1
	pause_check: .word 0
	game_over_check: .word 0
	can_we_plunge_check: .word 0
	acceleration_determination: .word 0
	sample_number: .word 0
	number: .word 0
	xstate: .word 0
	state: .word 0											#initially set to zero to disable jumping
	ycoord: .word 0
	y: .word 180	
	x: .word 20
	f1: .incbin "f1.bmp" , 70
	f2: .incbin "f2.bmp" , 70
	f3: .incbin "f3.bmp" , 70
	GameOver: .incbin "Game_Over.bmp" , 70
	Lava: .incbin "sting.bmp" , 70
	Song: .incbin "game_song.wav",44
.global SongPointer
	SongPointer: .word Song
	currentFrame: .word 0
	ylower: .word 148
	yupper: .word 0

	
.global buffer2
	buffer2: .skip 246784

.global fft_reserve
	fft_reserve: .skip 1024									#reserve for 256 samplex (integer) * 4 byte (each integer 4 bytes) = 1024 bytes
.global audio_sample_reserver
	audio_sample_reserver: .skip 19200						#reserve for 4800 sampes (integer) * 4 bytes = 19200 bytes
	
	
.text

.global main
#############################################################      MAIN		############################################################
main:
	movia r10,0xFF203024
	movia r11,buffer2
	stwio r11,0(r10)
	movia r10,0xFF203020
	movia r11,1
	stwio r11,0(r10)
	
	reloop:
	movia r16,0xFF20302C
	ldwio r16,0(r16)
	andi r16,r16,0x01
	bne r0,r16,reloop
	
	movia r10,0xFF203024
	movia r11,0x08000000
	stwio r11,0(r10)
	
	
	movia r10,game_over_check
	ldw r0,0(r10)
	
	movia r10,x
	movi r11,20
	stw r11,0(r10)
	
	movia r10,y
	movi r11,100
	stw r11,0(r10)

	
	movia r10,currentLevel
	movia r11,start_picture
	stw r11,0(r10)
	
	
	movia r10,levelCount
	movia r11,0
	stw r11,0(r10)

	movia r10,start_picture_check
	movia r11,1
	stw r11,0(r10)
	
	movia r10,pause_check
	movia r11,0
	stw r11,0(r10)
	
	movia r10,win
	movia r11,0
	stw r11,0(r10)
	
	
	
	call Initiate_Timer
	call Initiate_Audio_In
	call Initialize_Keyboard
	
	movi r10,0b011000101										#prepare to enable IRQ0, IRQ2,IRQ6, and IRQ7 for Timer 1, Timer 2, Audio Codec and PS2 respectively
	movi r11,0b01
	wrctl ctl3,r10 													
	wrctl ctl0,r11 											#write 1 to enable PIE. Interrupts can now occur

	
	
	subi sp,sp, 32											
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	
	call clear_character_buffer
	
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32 											#stack back to where it was	
	
	subi sp,sp, 32											
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	
	call clear_pixel_buffer 
	
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32 											#stack back to where it was	
	
	
	movi r16,1
	movia r17,0xFF203020
	stw r16,0(r17)
	
	subi sp,sp, 32											
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	
	call clear_character_buffer
	
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32 											#stack back to where it was	
	
	subi sp,sp, 32											
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	
	call clear_pixel_buffer 
	
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32 											#stack back to where it was	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
Loop:
	br Loop


	



#############################################################      Initiations		############################################################
	
	
Initiate_Timer:
	movia r10,TIMER2 										#set base address
	movi r11,%hi(TIMER2PERIOD) #set timer period
	stwio r11,12(r10)
	movi r11,%lo(TIMER2PERIOD)
	stwio r11,8(r10)
	stwio r0,0(r10)										    #clear “timeout” bit, just in case
	movi r11,0b111 											#start timer, continuous, interrupt enabled
	stwio r11,4(r10) 										#note: Other initialization, any order, but this should be last

	movia r10,TIMER 										#set base address
	movi r11,%hi(TIMERPERIOD) #set timer period
	stwio r11,12(r10)
	movi r11,%lo(TIMERPERIOD)
	stwio r11,8(r10)
	stwio r0,0(r10) 										#clear “timeout” bit, just in case
	movi r11,0b111 											#start timer, continuous, interrupt enabled
	stwio r11,4(r10) 										#note: Other initialization, any order, but this should be last
	ret

Initiate_Audio_In:

	movia r10, ADDR_AUDIODACFIFO 							#set audio base address
	movi r11, 0b0011										#enable read interrupt, clear both left and right read FIFOs
	stwio r11, 0(r10)
	ret
	
Initialize_Keyboard:

	movia r16, KEYBOARD_ADDRESS
	movi r17, 0b01											#initialize read interrupt for PS2 keyboard
	stwio r17, 4(r16)
	ret


	
#############################################################      ITimer2		############################################################
	
	#Timer2 updates every 0.1 seconds to change the current moving state of our character: is it flying? is it simply moving forward?
	#It is Timer1 who checks the state which Timer2 writes and visualize the corresponding VGA visuals.
	#So only change state here.
	
	
ITimer2:
	call PollAudio7
	movia et,TIMER2
	stwio r0,0(et) 					   						# ack the interrupt / clear the timer

#CHECK IF GAME OVER
		subi sp,sp, 32											
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	call PollAudio7
	call clear_pixel_buffer 
	
	
	
	
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32 											#stack back to where it was	
	
	movia r4,x
	ldw r4,0(r4)
	movia r5,y
	ldw r5,0(r5)
	movia r6,buffer2
	subi sp,sp, 32											
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	call PollAudio7
	call check_y											#Checks if it is black beneath us
	
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32 											#stack back to where it was	

	movi r8,1
	beq r2, r8, Black_Beneath								#If it is "1", which means it is colour black beneath us, then we simply draw the character without plunging down
	beq r2, r0, White_Beneath
	br Game_Over
	

Black_Beneath:

	movia r8, can_we_plunge_check
	stw r0, 0(r8)											# we cannot plunge down 
	br Continue_Sample

White_Beneath:

	movia r8, can_we_plunge_check
	movi r9, 1
	stw r9, 0(r8)											# we can plunge down 
	br Continue_Sample

Game_Over:



	movia r8, game_over_check
	movi r9, 1
	stw r9, 0(r8)											# time to say bye-bye 
	
	
	br Continue_Sample
	
	
	
	
	
	
	
	
	
	
Continue_Sample:	
	
	movia r4, audio_sample_reserver
	
	subi sp,sp, 32											
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	
	call averageCalculator
	
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32 
	
	beq r2, r0, Stand_Still
	movi r16, 1
	beq r2, r16, Slow_Walk
	movi r16, 2
	beq r2, r16, Fast_Walk
	movi r16, 3
	beq r2, r16, Slow_Fly
	movi r16, 4
	beq r2, r16, Fast_Fly

Fast_Fly:

	movia r16, state
	movi r17, 2
	stw r17, 0(r16)											#state is now 2, enabling it to fly quickly
	movia r16, xstate
	movi r17, 2
	stw r17, 0(r16)											#xstate is also 2, enabling it to move forward quickly while flying
		
	br Clear_Samples_Recorded	
	
Slow_Fly:

	movia r16, state
	movi r17, 1
	stw r17, 0(r16)											#state is now 1, enabling it to fly slowly
	movia r16, xstate
	movi r17, 2
	stw r17, 0(r16)
	
	br Clear_Samples_Recorded
	
Fast_Walk:

	movia r16, xstate
	movi r17, 2
	stw r17, 0(r16)											#xstate is now 2, enabling it to walk quickly
	
	br Clear_Samples_Recorded
	
Slow_Walk:

	movia r16, xstate
	movi r17, 1
	stw r17, 0(r16)											#xstate is now 1, enabling it to walk slowly
	
	br Clear_Samples_Recorded
	
Stand_Still:

	movia r16, state
	stw r0, 0(r16)											#now state is 0
	movia r16, xstate
	stw r0, 0(r16)

Clear_Samples_Recorded:

	movia r10, sample_number
	
	stw r0, 0(r10)
	
	br Iexit
	
	

#############################################################      ITimer1		############################################################	
	
	
	#Timer 1 is responsible for drawing out images onto the VGA, it updates every 1/60 second
	#numbers such as state and xstate are checked to determin if the character should walk or fly

	
Stand_Still_Timer1:

	movia r16, state
	stw r0, 0(r16)											#now state is 0
	movia r16, xstate
	stw r0, 0(r16)	
	movia r16, Black_Beneath
	movi r15, 1
	stw r15, 0(r16)
	movia r16, can_we_plunge_check
	stw r0, 0(r16)
	
	
	#######Pool2
	PoolAudio2:
	ldw r20,4(r23)
	movia r17,0xFFFF0000
	and r20,r20,r17
	beq r20,r0,skip2
	movia r23,ADDR_AUDIODACFIFO
	movia r20,SongPointer
	ldw r21,0(r20) #song pointer in r21
	ldw r22,0(r21) #now 8 bits we want in r22
	stwio r22,8(r23)
	stwio r22,12(r23)
	addi r21,r21,4
	movia r16,currentFrame
	bne r16,r21,NotEndOfSong2
	movia r21,Song
	NotEndOfSong2:
	stw r21,0(r20)
	br PoolAudio2
	skip2:
	
	
	br Pause_Draw_Continue
	
ITimer1:


	movia et,TIMER
	stwio r0,0(et) 					    					# ack the interrupt / clear the timer

	subi sp,sp, 32											
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	
	
	
	#######Pool1
	PoolAudio1:
	ldw r20,4(r23)
	movia r17,0xFFFF0000
	and r20,r20,r17
	beq r20,r0,skip1
	movia r23,ADDR_AUDIODACFIFO
	movia r20,SongPointer
	ldw r21,0(r20) #song pointer in r21
	ldw r22,0(r21) #now 8 bits we want in r22
	stwio r22,8(r23)
	stwio r22,12(r23)
	addi r21,r21,4
	movia r16,currentFrame
	bne r16,r21,NotEndOfSong1
	movia r21,Song
	NotEndOfSong1:
	stw r21,0(r20)
	br PoolAudio1
	skip1:
	
	
	call clear_character_buffer
	
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32 											#stack back to where it was	
	
	subi sp,sp, 32											
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	
	call clear_pixel_buffer 
	
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32 											#stack back to where it was	

	call PollAudio7
	movia r16, win
	ldw r16, 0(r16)
	bne r16, r0, Switch_Buffer_For_Start_Picture			#only draw the win picture
	
	movia r16, start_picture_check
	ldw r16, 0(r16)											#if start picture check is 1, then we are still at start picture
	bne r16, r0, Switch_Buffer_For_Start_Picture			#if start picture is not zero (which is 1), then we continue drawing the starting picture
	
	movia r16, pause_check
	ldw r16, 0(r16)
	bne r0, r16, Stand_Still_Timer1							#if not zero, then game should be paused 
	
Pause_Draw_Continue:	
	call PollAudio7
	movia r16, game_over_check
	ldw r16, 0(r16)
	bne r0, r16, Game_Over_Picture
	
	movia r17, state										#"state" determines if we should fly 
	ldw r17, 0(r17)
	beq r17, r0, Potential_Plunge_Down					

Potential_Rise_Up:	
call PollAudio7
	movia r17, yupper
	ldw r17, 0(r17)
	movia et, y
	ldw et, 0(et)
	blt et, r17, Draw
	
	movia r17, state
	ldw r17, 0(r17)
	movi r16, 1												#if state is "1", only has to normally rise up
	beq r17, r16, Rise_Up
	br Quickly_Rise_Up
	
Potential_Plunge_Down:
	call PollAudio7
	movia r17, can_we_plunge_check
	ldw r17, 0(r17)
	beq r0, r17, Draw										#if it is zero, then cannot plunge down
										
	
	br Plunge_Down

#GAME OVER
Game_Over_Picture:

		#######Pool3
	PoolAudio3:
	ldw r20,4(r23)
	movia r17,0xFFFF0000
	and r20,r20,r17
	beq r20,r0,skip3
	movia r23,ADDR_AUDIODACFIFO
	movia r20,SongPointer
	ldw r21,0(r20) #song pointer in r21
	ldw r22,0(r21) #now 8 bits we want in r22
	stwio r22,8(r23)
	stwio r22,12(r23)
	addi r21,r21,4
	movia r16,currentFrame
	bne r16,r21,NotEndOfSong3
	movia r21,Song
	NotEndOfSong3:
	stw r21,0(r20)
	br PoolAudio3
	skip3:
	
	subi sp,sp, 32											
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	call PollAudio7
	movia r4,GameOver
	movi r6,0
	movi r5,0
	movi r7,320
	addi sp,sp,-4 
	movia r10,240
	stw r10,0(sp)
	call draw_image
	addi sp,sp,4
	
	
	movi r16,1
	movia r17,0xFF203020
	stw r16,0(r17)
	
	call PollAudio7
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32 
	
	br Switch_Buffer_For_Start_Picture
	
Rise_Up:
	movia et, y
	ldw r10,0(et)
	subi r10,r10,1
	stw r10,0(et)
	movia et, x
	ldw r10,0(et)
	addi r10,r10,2
	stw r10,0(et)
	br Draw
	
Quickly_Rise_Up:
	movia et, y
	ldw r10,0(et)
	subi r10,r10,2
	stw r10,0(et)
	movia et, x
	ldw r10,0(et)
	addi r10,r10,2
	stw r10,0(et)
	br Draw		
	
Plunge_Down:
	
	movia et, y												#help both x and y drop quickly
	ldw r10,0(et)											
	addi r10,r10,2											#y coordinate drops by 2
	stw r10,0(et)

	
	movia et, x
	ldw r10,0(et)
	addi r10,r10,2
	stw r10,0(et)
	br Draw

Draw:
	call PollAudio7
	
#LAVA
	################################################DRAW HARZARD########################################################################
	movia et,currentFrame
	ldw r10,0(et)
	beq r0,r10,fram1
	movi r20,1
	beq r20,r10,fram2
	movi r20,2
	beq r20,r10,fram3
	br fram4
	

fram4:
	stw r0,0(et)
	movia r4,f2
	br Draw2


fram3:
	movi r20,3
	stw r20,0(et)
	movia r4,f3
	br Draw2

fram2:
	movi r20,2
	stw r20,0(et)
	movia r4,f2
	br Draw2

fram1:
	movi r20,1
	stw r20,0(et)
	movia r4,f1
	br Draw2
	
Draw2:	

	subi sp,sp, 32											#little person is drawn here						
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)

	movia et, y
	ldw r6, 0(et)
	movia et, x
	ldw r5, 0(et)
	
	movi r15, 320
	mov r16, r5
	addi r16, r16, 37
	blt r16, r15, Do_Not_Move_Character
	
exceedLimit:
	call PollAudio7
	movi r5, 5												#make the character appear on the left side of the screen now
	stw r5, 0(et)
	
	
	movia r8,levelCount										
	ldw r9,0(r8)
	addi r9,r9,1
	movi r10,4
	bne r10,r9,continueLevel
	
	movia r18, win
	movi r19, 1
	stw r19, 0(r18)											#now we win
												
	
	
continueLevel:	

	stw r9,0(r8)											#now the next level picture is about to be loaded
	movia r8,levelchoice
	add	r9, r9, r9         
    add r9, r9, r9         
    add r8, r8, r9
	ldw r8, 0(r8)
	movia r9,currentLevel
	stw r8,0(r9)
	
	movia r18, win
	ldw r18, 0(r18)
	bne r18, r0, Iexit
	
	
Do_Not_Move_Character:	
	
	movi r7,18
	addi sp,sp,-4 
	movia r10,25
	stw r10,0(sp)
	call draw_image
	addi sp,sp,4
	
	
	
	movi r16,1
	movia r17,0xFF203020
	stw r16,0(r17)

	call PollAudio7
	
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32
	
	br Iexit
	
	
Switch_Buffer_For_Start_Picture:
	call PollAudio7
	movi r16,1
	movia r17,0xFF203020
	stw r16,0(r17)
	
	br Iexit

#############################################################      Keyboard		############################################################	
	
PS2:
	movia r16, KEYBOARD_ADDRESS
	ldwio r15, 0(r16)										#load stuff out of PS2
	andi r15, r15, 0x0FF									#bitwise and the values
	
	movia r16, pause_check
	ldw r15, 0(r16)											#load pause check parameter
	xori r15, r15, 0xFFFF										#value is inverted everytime, so in the beginning it is zero and now it is FFFF, back and force
	stw r15, 0(r16)

	movia r16, start_picture_check
	ldw r15, 0(r16)											#start picture check is 0 now, so we no longer at the starting picture
	beq r15, r0, Skip_Change_Start							
	
	stw r0, 0(r16)					
	
	movia r8,levelCount										
	movi r9, 1

		
	stw r9,0(r8)											#now the level 1 picture is ready to be loaded
	movia r8,levelchoice
	
	movi r9, 4					
	
    add r8, r8, r9											#now level choice is pointing at level 1 picture as well
	ldw r8, 0(r8)
	movia r9,currentLevel
	stw r8,0(r9)

Skip_Change_Start:
	 
	br Iexit
##################################################Audio Out Section#################################################################
Audio_Out:
	movia r23,ADDR_AUDIODACFIFO
	movia r20,SongPointer
	ldw r21,0(r20) #song pointer in r21
	ldw r22,0(r21) #now 8 bits we want in r22
	stwio r22,8(r23)
	stwio r22,12(r23)
	addi r21,r21,4
	movia r16,currentFrame
	bne r16,r21,NotEndOfSong
	movia r21,Song
	NotEndOfSong:
	stw r21,0(r20)
	ldw r20,4(r23)
	movia r17,0xFFFF0000
	and r20,r20,r17
	bne r20,r0,Audio_Out
	br Iexit
	
#######################POLL SOUND
	PollAudio7:
	ldw r20,4(r23)
	movia r17,0xFFFF0000
	and r20,r20,r17
	beq r20,r0,skip7
	movia r23,ADDR_AUDIODACFIFO
	movia r20,SongPointer
	ldw r21,0(r20) #song pointer in r21
	ldw r22,0(r21) #now 8 bits we want in r22
	stwio r22,8(r23)
	stwio r22,12(r23)
	addi r21,r21,4
	movia r16,currentFrame
	bne r16,r21,NotEndOfSong7
	movia r21,Song
	NotEndOfSong7:
	stw r21,0(r20)
	br PollAudio7
	skip7:
	ret
#############################################################      EXCEPTIONS		############################################################

.section .exceptions, "ax"

IHANDLER:

	#Here, this is already been done: ctl1 = ctl0 control 1 save control 0b01
	#Moreover, ctl0 is automatically turned to zero to avoid other interrupts 
	#to happen here
	#r29(ea) = PC + 4, so at the end of the interrupt handler, minus 4 from it

	
	subi sp,sp, 36											
	stw r8,0(sp)
	stw r9, 4(sp)
	stw r10, 8(sp)
	stw r11, 12(sp)
	stw r12, 16(sp)
	stw r13, 20(sp)
	stw r14, 24(sp)
	stw r15, 28(sp)
	stw ra, 32(sp)
	
	subi sp,sp, 16 											#we need to use a second register, so we save r10 and will use it
	stw r10,0(sp)
	stw r20, 4(sp)
	stw r16, 8(sp)
	stw r17, 12(sp)

	
			#######Pool4
	PoolAudio4:
	ldw r20,4(r23)
	movia r17,0xFFFF0000
	and r20,r20,r17
	beq r20,r0,skip4
	movia r23,ADDR_AUDIODACFIFO
	movia r20,SongPointer
	ldw r21,0(r20) #song pointer in r21
	ldw r22,0(r21) #now 8 bits we want in r22
	stwio r22,8(r23)
	stwio r22,12(r23)
	addi r21,r21,4
	movia r16,currentFrame
	bne r16,r21,NotEndOfSong4
	movia r21,Song
	NotEndOfSong4:
	stw r21,0(r20)
	br PoolAudio4
	skip4:
	
	
	
	
	
	rdctl  et,ctl4											#read status register and see which device interrupted
	mov r10, et	
	andi et, et, 0b01										#is it Timer 0? 
	bne et, r0, ITimer1										#If not zero, then timer 1
	mov et, r10
	andi et, et, 0b00000100									#is it Timer 2?
	bne et, r0, ITimer2										#If not zero, then timer 20
	mov et, r10
	andi et, et, 0b010000000
	bne et, r0, PS2
	
Audio_in:
		
	movia r20, ADDR_AUDIODACFIFO
	
	ldw r21,0(r20)
	
	andi r21,r21,0b01000000000
	
	bne r21,r0,Audio_Out
	
	
	movia r20, ADDR_AUDIODACFIFO
	
	ldwio r16, 8(r20)
									
	blt r16, r0, Iexit										#anything below zero wouldn't be considered
	
	movia r17, audio_sample_reserver						#ready to store value into audio sample reserver
	
	movia r10, sample_number
	
	ldw et, 0(r10)
	
	muli r20,et,4
	
	add r17, r17, r20
	
	stw r16, 0(r17)											#store the appropriate sample value into the appropriate address
	
	addi et, et, 1
	
	stw et, 0(r10)											#one more sample recorded
	
	br Iexit
	
	
Iexit:

	# now restore the registers we saved
	ldw r10,0(sp)
	ldw r20, 4(sp)
	ldw r16, 8(sp)
	ldw r17, 12(sp)
	addi sp,sp,16 											#stack back to where it was

	ldw ra, 32(sp)
	ldw r15,28(sp)
	ldw r14,24(sp)
	ldw r13,20(sp)
	ldw r12,16(sp)
	ldw r11,12(sp)
	ldw r10, 8(sp)
	ldw r9, 4(sp)
	ldw r8, 0(sp)
	addi sp,sp,32
	
	subi ea,ea,4 											#now ea is the actual PC address that we are supposed to return back to
	eret 													#the instruction restores ctl0 from ctl1 and PC from register r29 (ea)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/*
	movia r20, ADDR_AUDIODACFIFO
	
	ldwio r16,8(r20)	 									#load the value inside the audio input FIFO
	
	movia r17, fft_reserve									#load the address of the fft_reserve
	
	movia r10, sample_number

	ldw et, 0(r10)
	
	movi r20, 256
	
	beq et, r20, Fast_Fourier_Transform
	
	muli r20,et,4											#however many samplex by 4 into r10, i.e. if no samples yet, then r10 is 0
	
	add r17, r17, r20										#decide which memory address to input the sample_number
	
	movi r20, 50
	
	blt r16, r20, Potential_Add_Zero

Normal_Add:
	
	stw r16, 0(r17)
	
	addi et, et, 1
	
	stw et, 0(r10)											#one more sample is inputted
	
	br Iexit	
	
Potential_Add_Zero:

	movi r20, -50
	
	bgt r16, r20, Add_Zero
	
	br Normal_Add
	
Add_Zero:
	
	stw r0, 0(r17)
	
	addi et, et, 1
	
	stw et, 0(r10)											#one more sample is inputted
	
	br Iexit
	
	
	*/
	
	/*
	
Fast_Fourier_Transform:										#256 samples have been put into the memory, ready for fast fourier to be started

	movia r4, fft_reserve
	
	call fft
###############	
	mov r4, r2		
	
	call printNum											#check to see if correct frequencies are obtained
###############
	movia r16, acceleration_determination
	
	stw r2, 0(r16)											#what ever supposed accelration state is stored
	
	movia r16, sample_number
	
	stw r0, 0(r16)											#clear sample number to 0, such that the next round of replacement can be executed
	
	br Iexit
	
	*/
	
	
	/*
	movia r20, ADDR_AUDIODACFIFO
  
	ldwio r16,8(r20)	 									#load the value inside the audio input FIFO
	movia r17, 4000
	bgt r16, r17, Iexit
	movia r17, -4000
	blt r16, r17, Iexit
  
	movia r17, number
	ldw r16, 0(r17)											#load "number" into r16
	addi r16, r16, 1						
	stw r16, 0(r17)											#add "number"  by 1 and load back to "number"
	*/






	
	
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
  
  