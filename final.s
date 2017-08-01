@This Prints the uInput string other way around...

	.text



	.global main

main:
	sub sp,sp,#4				@ stro link register for further use
	str lr,[sp,#0]  


	ldr r0, =formatp1 
	bl printf

	@ 8 bytes from the stack is allocated first,and then 64 bit inputs scanned one by one
	@ and stored them in registers.
	@ same 8 bytes were used to scan the both inputs 
	
	sub sp,sp,#8

	
	ldr r0, =formats1
	mov r1,sp				@ 1st 64 bit part of the key
	bl scanf
	ldr r4,[sp,#4]      	@ stored in registers
	ldr r5,[sp,#0]      

	
	ldr r0, =formats1
	mov r1,sp				@ 2nd 64 bit part of the key
	bl scanf
	ldr r6,[sp,#4]       	@ stored in registers	
	ldr r7,[sp,#0]       


	ldr r0, =formatp2 
	bl printf

	
	ldr r0, =formats1			@ 1st part of the text
	mov r1,sp
	bl scanf
	ldr r8,[sp,#4]     			@ stored in registers
	ldr r9,[sp,#0]     


	ldr r0, =formats1
	mov r1,sp					@ 2nd part of the text
	bl scanf
	ldr r10,[sp,#4]        		@ stored in registers
	ldr r11,[sp,#0]        


	add sp,sp,#8				@ all the inputs were scanned. so freed the allocated space

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@@@@@@@@@@@@@ encrypt and round functions are implemented in the main method @@@@@@@@@@@@@@

	mov r0,r8
	mov r1,r9
	@mov r2,#8
	bl rightShift
	
	@@@@ x1-fist part of the text   y1-2nd part of the text
	@@@@ k1 - first part of the key  k2-2nd part of the key
	
	adds r1,r1,r11			@ least part are added first of the 1st part of the text 
	adc r0,r0,r10			@ x1 = x1 + y1,(will consider if there was a carry from the previous operation)
	
	eor r0,r0,r6			@ xor x1 and k1
	eor r1,r1,r7			@ xor x2 and k2
	mov r8,r0				@ do the changes to r0 and r1
	mov r9,r1
	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	mov r0,r10
	mov r1,r11
	@mov r2,#3
	bl leftShift
	eor r0,r0,r8
	eor r1,r1,r9
	mov r10,r0
	mov r11,r1
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	
	mov r3,#0
loop:
	cmp r3,#31
	bge exit

	mov r0,r4
	mov r1,r5
	@mov r2,#8
	bl rightShift
	@@@@@@@@@@@@@@@@@@@@		
	adds r1,r1,r7			
	adc r0,r0,r6			
	eor r1,r1,r3			@ here the xor part is done for only one part of the text because r3 is a 32 bit number
	mov r4,r0				@ so xor cannot be dne on r0
	mov r5,r1
	@@@@@@@@@@@@@@@@@@@		
	mov r0,r6
	mov r1,r7
	@mov r2,#3
	bl leftShift
	eor r1,r1,r5
	eor r0,r0,r4
	mov r6,r0			@ giving the news values to r4 and r5
	mov r7,r1

	
	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	mov r0,r8
	mov r1,r9
	@mov r2,#8
	bl rightShift
	
	adds r1,r1,r11			@ x2 = x2 + y2
	adc r0,r0,r10			@ x1 = x1 + y1,(will consider if there was a carry from the previous operation)
	
	eor r0,r0,r6			@ xor x1 and k1
	eor r1,r1,r7			@ xor x2 and k2
	mov r8,r0				@ do the changes to r0 and r1
	mov r9,r1
	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	mov r0,r10
	mov r1,r11
	@mov r2,#3
	bl leftShift
	eor r0,r0,r8
	eor r1,r1,r9
	mov r10,r0
	mov r11,r1

    add r3,r3,#1
    b loop
    
    
leftShift:

	@ x1 is in r0 , x2 is in r1, r is r2
	
	sub sp,sp,#32
	str r3,[sp,#0]
	str r4,[sp,#4]
	str r5,[sp,#8]
	str r6,[sp,#12]
	str r7,[sp,#16]
	str r8,[sp,#20]
	str r9,[sp,#24]
	str lr,[sp,#28]
	

	@mov r3,#32
	@sub r3,r3,r2 		@ 32 - r
	
	mov r4,r0, lsl #3		@ shift opearations on x1 , x1 << r)		
	mov r5,r1, lsl #3		@ shift operation on x2, x2 << r)
	
	mov r6,r0, lsr #29		@ shift opearations on x1 , x1 >> 32 - r)
	mov r7,r1, lsr #29		@ shift opearations on x2 , x2 >> 32 - r)
	
	orr r8,r4,r7		@ or operation on r4 and r7
	orr r9,r5,r6		@ or operation on r5 and r6	
	
	mov r0,r8
	mov r1,r9
	
	@mov r1,r8
	@mov r2,r9
	@ldr r0, =formatp4
	@bl printf
	
	
	ldr r3,[sp,#0]
	ldr r4,[sp,#4]
	ldr r5,[sp,#8]
	ldr r6,[sp,#12]
	ldr r7,[sp,#16]
	ldr r8,[sp,#20]
	ldr r9,[sp,#24]
	ldr lr,[sp,#28]
	add sp,sp,#32
	
	mov pc,lr
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


rightShift:
	@ x1 is in r0 , x2 is in r1, r is r2
	
	sub sp,sp,#32
	str r3,[sp,#0]
	str r4,[sp,#4]
	str r5,[sp,#8]
	str r6,[sp,#12]
	str r7,[sp,#16]
	str r8,[sp,#20]
	str r9,[sp,#24]
	str lr,[sp,#28]
	

	@mov r3,#32
	@sub r3,r3,r2 		@ 32 - r
	
	
	mov r4,r0,lsr #8		@ shift opearations on x1 , x1 << r)		
	mov r5,r1, lsr #8		@ shift operation on x2, x2 << r)
	
	mov r6,r0,lsl #24		@ shift opearations on x1 , x1 >> 32 - r)
	mov r7,r1,lsl #24		@ shift opearations on x2 , x2 >> 32 - r)
	
	orr r8,r4,r7		@ or operation on r4 and r7
	orr r9,r5,r6		@ or operation on r5 and r6	
	
	mov r0,r8
	mov r1,r9
	
	@mov r1,r8
	@mov r2,r9
	@ldr r0, =formatp4
	@bl printf
	
	
	ldr r3,[sp,#0]
	ldr r4,[sp,#4]
	ldr r5,[sp,#8]
	ldr r6,[sp,#12]
	ldr r7,[sp,#16]
	ldr r8,[sp,#20]
	ldr r9,[sp,#24]
	ldr lr,[sp,#28]
	add sp,sp,#32
	
	mov pc,lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    
    
    
    
    
    
    
    
    
exit:

	ldr r0,=formatp3
	bl printf
	
	ldr ro,=formatp4
	mov r1,r9       		@ print x
	mov r2,r8        
	bl printf
	

	ldr r0,=formats2
	mov r1,r11       
	mov r2,r10       		@ print y
	bl printf

	mov r0,#0        
	ldr lr,[sp,#0]
	add sp,sp,#4     
	mov pc,lr



	.data            @ data memory

formatp1: .asciz "Enter the key:\n"
formats1: .asciz "%llx"
formatp2: .asciz "Enter the plain text:\n"
formatp3: .asciz "Cipher text is:\n"
formatp4: .asciz"%llx "
formats2: .asciz "%llx\n"

