#	209215490	Bar Tawil

.section .rodata

format_invalid:   .string "invalid input!\n"

.text
# pstring - Library functions

# first func:
#	 input - pstring
#	 output - lenght of the pstring
.globl pstrlen
	.type pstrlen,@function
pstrlen:
	movzbq	(%rdi), %rax #moves the first byte of the ps that represent th lenght
	ret

#second func:
# Using the replaceChar function, replace with both pstrings each instance of oldChar in newChar.
# After replacement, the two pstrings should be printed in print format
#	input - pstring, char i, char j
#	output - new pstring with the replaced chars
.globl replaceChar
	.type replaceChar,@function
replaceChar:
		push	%rbp
		movq 	%rsp, %rbp
		subq 	$32, %rsp
		movq 	%rdi, -8(%rbp) #ps
		movq 	%rsi, -16(%rbp) #oldChar
		movq 	%rdx, -24(%rbp) #newChar
		movq 	$1, %r12 # loop index

		#check the ps lenght
		movq 	-8(%rbp), %rdi
		call	pstrlen
		movq 	%rax, -32(%rbp) #str lenght
		movq 	-8(%rbp), %r13 #ps
		movq 	-16(%rbp), %r14 #oldChar 
		movq 	-24(%rbp), %r15 #newChar
		jmp		.loop

	# loop over the ps and send the old char to replacment
	.loop:
		cmpq	%r12, -32(%rbp) # strlen - loop index < 0
		jb		.done
		cmpb	(%r13, %r12, 1), %r14b
		je		.replacement
		incq	%r12
		jmp		.loop

	# replace an old char with new char
	.replacement:
		movb 	%r15b, (%r13, %r12, 1) #newchar >> str[i]
		jmp		.loop

	# return the new ps
	.done:
		movq 	%r13, %rax
		movq	%rbp, %rsp
		pop		%rbp
		ret

#third func:
# receive from the user two integers the first number will be the start index and the second
# End index.
#	input - ps dst, ps src, char i, char j
#	output - new pstring with the replaced sub-string
.globl pstrijcpy
	.type pstrijcpy,@function
pstrijcpy:
		push	%rbp
		movq 	%rsp, %rbp
		subq	$48, %rsp
		movq 	%rdi, -8(%rbp) #dst
		movq 	%rsi, -16(%rbp) #src
		movq 	%rdx, -24(%rbp) #idx i
		movq 	%rcx, -32(%rbp) #idx j

		#check the ps lenght
		movq 	-8(%rbp), %rdi
		call	pstrlen
		movq 	%rax, -40(%rbp) #dst lenght

		movq 	-16(%rbp), %rdi
		call 	pstrlen
		movq 	%rax, -48(%rbp) #src lenght

		#insert loop
		movq 	$0, %r12 # loop index
		movq 	-8(%rbp), %r13 #dst
		movq 	-16(%rbp), %r14 #src
		movq 	-24(%rbp), %r10 #idx i
		movzbq	%r10b, %r10
		movq 	-32(%rbp), %r11 #idx j
		movzbq	%r11b, %r11
		
		#check if indexs valid
		cmpq	%r10, -40(%rbp) #check if i bigger then ps1
		jb		.invalid_3
		cmpq	%r10, -48(%rbp) #check if i bigger then ps2
		jb		.invalid_3
		cmpq	%r11, -40(%rbp) #check if j bigger then ps1
		jb		.invalid_3
		je		.invalid_3
		cmpq	%r11, -48(%rbp) #check if j bigger then ps2
		jb		.invalid_3
		je		.invalid_3
		jmp 	.loop_third

	# print that input was invalid and not change the ps
	.invalid_3:
		movq    $format_invalid, %rdi
		movq    $0, %rax
	    call    printf
		jmp		.done_third

	# go over the ps and search for sub-string char to replace them
	.loop_third:
		cmpq 	%r12, %r11 #if [i,j] is finished
		jb		.done_third
		cmpq	%r12, -40(%rbp) # strlen - loop index < 0
		jb		.done_third
		cmpq 	%r10, %r12 #assert index >= i
		incq	%r12
		jb		.loop_third
		movq 	(%r14, %r12, 1), %r15
		movb 	%r15b, (%r13, %r12, 1) #newchar >> dst[i]
		jmp		.loop_third

	# return the new dst ps
	.done_third:
		movq 	%r13, %rax
		movq	%rbp, %rsp
		pop		%rbp
		ret

#four func:
# replace each uppercase English capital letter (Z-A)
# with the same string small English (z-a).
#	input - pstring
#	output - new pstring with different char-case
.globl swapCase
	.type swapCase,@function
swapCase:
		push	%rbp
		movq 	%rsp, %rbp
		subq	$16, %rsp
		movq 	%rdi, -8(%rbp) #ps

		#check ps lenght
		movq 	-8(%rbp), %rdi
		call	pstrlen
		movq 	%rax, -16(%rbp) #ps lenght

		#insert loop
		movq 	$0, %r12 # loop index
		movq 	-8(%rbp), %r13 #ps
		jmp 	.loop_four

	# go over the string and change the letters char case
	.loop_four:
		cmpq	%r12, -16(%rbp) # strlen - loop index < 0
		jb		.done_four
		#if 65 < r14 < 90
		#jmp lower
		#if 97 < r14 < 122
		#jmp upper
		incq	%r12
		movq 	(%r13, %r12, 1), %r14 #str[i]
		movzbq	%r14b, %r14
		cmpq	$65, %r14
		jb		.loop_four
		cmpq 	$91, %r14
		jb		.to_lower
		cmpq	$97, %r14
		jb		.loop_four
		cmpq	$123, %r14
		jb 		.to_upper	
		jmp		.loop_four

	# change to capital latters
	.to_upper:
		subq	$32, %r14
		movb 	%r14b, (%r13, %r12, 1)
		jmp		.loop_four

	# change to small latters
	.to_lower:
		addq	$32, %r14
		movb 	%r14b, (%r13, %r12, 1)
		jmp		.loop_four

	# return new pstring
	.done_four:
		movq 	%r13, %rax
		movq	%rbp, %rsp
		pop		%rbp
		ret

#func five:
#	input - ps1, ps2, char i, char j
# 	output - 1 if ps1 > ps2 lexicographically
#			-1 if ps1 < ps2 lexicographically
#			 0 if ps1 = ps2 lexicographically
#			-2 if input is invalid
.globl pstrijcmp
	.type pstrijcmp,@function
pstrijcmp:
		push	%rbp
		movq 	%rsp, %rbp
		subq	$48, %rsp
		movq 	%rdi, -8(%rbp) #ps1
		movq 	%rsi, -16(%rbp) #ps2
		movq 	%rdx, -24(%rbp) #idx i
		movq 	%rcx, -32(%rbp) #idx j

		#check the ps lenght
		movq 	-8(%rbp), %rdi
		call	pstrlen
		movq 	%rax, -40(%rbp) #ps1 lenght

		movq 	-16(%rbp), %rdi
		call 	pstrlen
		movq 	%rax, -48(%rbp) #ps2 lenght

		#check if indexs valid
	    movq	-24(%rbp), %r11 
		movzbq	%r11b, %r11
		cmpq	%r11, -40(%rbp) #check if i bigger then ps1
		jb		.invalid

		movq	-24(%rbp), %r11 
		movzbq	%r11b, %r11
		cmpq	%r11, -48(%rbp) #check if i bigger then ps2
		jb		.invalid

		movq	$0, %r12
		movq	-32(%rbp), %r12 
		movzbq	%r12b, %r12
		cmpq	%r12, -40(%rbp) #check if j bigger then ps1
		jb		.invalid
		je		.invalid

		movq	-32(%rbp), %r12 
		movzbq	%r12b, %r12
		cmpq	%r12, -48(%rbp) #check if j bigger then ps2
		jb		.invalid
		je		.invalid

		#insert loop
		movq 	$0, %r12 # loop index
		movq 	-8(%rbp), %r13 #ps1
		movq 	-16(%rbp), %r14 #ps2
		movq 	-24(%rbp), %r10 #idx i
		movzbq	%r10b, %r10
		movq 	-32(%rbp), %r11 #idx j
		movzbq	%r11b, %r11
		jmp 	.loop_five

	# go over the ps's and chack the lexicographic diffrent between them
	.loop_five:
		cmpq 	%r12, %r11 #if [i,j] is finished
		movq 	$0, %rax
		jb		.done_five
		cmpq	%r12, -40(%rbp) # strlen - loop index < 0
		jb		.done_five
		cmpq 	%r10, %r12 #assert index >= i
		incq	%r12
		jb		.loop_five
		movq 	(%r13, %r12, 1), %r8 #p1[i]
		movq 	(%r14, %r12, 1), %r9 #p2[i]
		cmpb 	%r9b, %r8b
		ja		.case_big
		jb 		.case_little
		jmp		.loop_five

	# if ps1 > ps2
	.case_big:
		movq 	$1, %rax
		jmp		.done_five

	# if ps1 < ps2
	.case_little:
		movq 	$0, %rax
		subq 	$1, %rax
		jmp 	.done_five

	# if input is invalid
	.invalid:
		movq    $format_invalid, %rdi
		movq    $0, %rax
	    call    printf
	    movq 	$0, %rax
	    subq	$2, %rax
		jmp		.done_five

	# return the lexicographic diffrent
	.done_five:
		movq	%rbp, %rsp
		pop		%rbp
		ret
		
