#	209215490	Bar Tawil

.section .rodata

.align 8 # Align address to multiple of 8
.L0:
	.quad .L1 # Case 50/60
	.quad .L6 # Case 51 - goto defult
	.quad .L2 # Case 52
	.quad .L3 # Case 53
	.quad .L4 # Case 54
	.quad .L5 # Case 55
	.quad .L6 # Case defult

format_invalid:  .string "invalid input!\n"
format_defult:   .string "invalid option!\n"
format_check1:   .string "50/60=%lu\n"
format_check2:   .string "52=%lu\n"
format_check3:   .string "53=%lu\n"
format_check4:   .string "54=%lu\n"
format_check5:   .string "55=%lu\n"

format_1:	.string	"first pstring length: %lu, second pstring length: %lu\n"
format_2:	.string	"old char: %c, new char: %c, first string: %s, second string: %s\n"
format_3:	.string "length: %d, string: %s\n"
format_5:	.string "compare result: %d\n"

format_char:	.string " %c"
format_index:	.string "%d"

.text
# run_func:
#	send the user to the option case function by jump table.
#	input - option, ps1, ps2
#	output - calls the option in the menu
.globl run_func
	.type run_func,@function
run_func:
	#stack frame
	push	%rbp 
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rsi, -8(%rbp) #ps1
	movq	%rdx, -16(%rbp) #ps2

	leaq -50(%rdi), %rsi #assert that the array start from 0

	cmpq $10, %rsi #check if opt is 60
	je .L1 # jump to the first case

	cmpq $5, %rsi #check if opt is invalid
	ja .L6 # go to default

	jmp *.L0(,%rsi,8) #sets array

	# if option is 50 or 60 send to pstrlen function
	.L1:
		#first ps len
	    movq	-8(%rbp), %rdi #send the first ps to pstrlen
		call	pstrlen
		movq	%rax, -8(%rbp) #save the len val in the stack

		#second ps len
	 	movq	-16(%rbp), %rdi #send the second ps to pstrlen
		call	pstrlen
		movq	%rax, -16(%rbp) #save the len val in the stack

		#print 
	    movq	$format_1, %rdi
		movq	-8(%rbp), %rsi #ps1 len
		movq	-16(%rbp), %rdx #ps2 len
		movq    $0, %rax
    	call    printf
	    jmp .L10

	# if option is 52 send to replace_char function
	.L2:
		subq	$32, %rsp
		
		#old char
	    movq    $format_char, %rdi
	    leaq    -24(%rbp), %rsi
	    movq    $0, %rax
	    call    scanf

	    #new char
	    movq    $format_char, %rdi
	    leaq    -32(%rbp), %rsi
	    movq    $0, %rax
	    call    scanf

	    #first ps replace
	    movq	-8(%rbp), %rdi #send the first ps to replaceChar
	    movq	-24(%rbp), %rsi
	    movq	-32(%rbp), %rdx
		call	replaceChar
		movq	%rax, -8(%rbp) #save the new ps in the stack

		#second ps replace
	    movq	-16(%rbp), %rdi #send the second ps to replaceChar
	    movq	-24(%rbp), %rsi
	    movq	-32(%rbp), %rdx
		call	replaceChar
		movq	%rax, -16(%rbp) #save the new ps in the stack

		#print 
	    movq	$format_2, %rdi
		movq	-24(%rbp), %rsi #old char
		movq	-32(%rbp), %rdx #new char
		movq	-8(%rbp), %rcx #new ps1
		incq	%rcx #jump the poiter over len val in ps1
		movq	-16(%rbp), %r8 #new ps2
		incq	%r8 #jump the pointer over len val in ps2
		movq    $0, %rax
    	call    printf
	    jmp .L10

	# if option is 53 send to pstrijcpy function
	.L3:
		subq	$48, %rsp

		#check the dst length
	    movq	-8(%rbp), %rdi #send the first ps to pstrlen
		call	pstrlen
		movq	%rax, -40(%rbp) #save the len val in the stack

		#check the src length
	    movq	-16(%rbp), %rdi #send the second ps to pstrlen
		call	pstrlen
		movq	%rax, -48(%rbp) #save the len val in the stack

		#char i
	    movq    $format_index, %rdi
	    leaq    -24(%rbp), %rsi
	    movq    $0, %rax
	    call    scanf

	    #char j
	    movq    $format_index, %rdi
	    leaq    -32(%rbp), %rsi
	    movq    $0, %rax
	    call    scanf

	    #send to pstrijcpy
	    movq	-8(%rbp), %rdi
	    movq	-16(%rbp), %rsi
	    movq	-24(%rbp), %rdx
	    movq	-32(%rbp), %rcx
	    call	pstrijcpy
	    movq	%rax, -8(%rbp) #new dst

	    #print new dst
	    movq	$format_3, %rdi
	    movq	-40(%rbp), %rsi
	    movq	-8(%rbp), %rdx
	    incq	%rdx
	    movq    $0, %rax
	    call	printf

	    #print prv dst
	    movq	$format_3, %rdi
	    movq	-48(%rbp), %rsi
	    movq	-16(%rbp), %rdx
	    incq	%rdx
	    movq    $0, %rax
	    call	printf
	    jmp .L10

	# if option is 54 send to swapCase function
	.L4:
		subq	$32, %rsp

		#check the ps1 length
	    movq	-8(%rbp), %rdi #send the first ps to pstrlen
		call	pstrlen
		movq	%rax, -24(%rbp) #save the len val in the stack

		#check the ps2 length
	    movq	-16(%rbp), %rdi #send the second ps to pstrlen
		call	pstrlen
		movq	%rax, -32(%rbp) #save the len val in the stack

	    #swap one
	    movq	-8(%rbp), %rdi
	    call	swapCase
	    movq	%rax, -8(%rbp)

	    #swap two
	    movq	-16(%rbp), %rdi
	    call	swapCase
	    movq	%rax, -16(%rbp)

	    #print new ps1
	    movq	$format_3, %rdi
	    movq	-24(%rbp), %rsi
	    movq	-8(%rbp), %rdx
	    incq 	%rdx
	    movq    $0, %rax
	    call	printf

	    #print new ps2
	    movq	$format_3, %rdi
	    movq	-32(%rbp), %rsi
	    movq	-16(%rbp), %rdx
	    incq	%rdx
	    movq    $0, %rax
	    call	printf	
	    jmp .L10

	# if option is 55 send to pstrijcmp
	.L5:
	    subq	$48, %rsp

		#check the src length
	    movq	-8(%rbp), %rdi #send the first ps to pstrlen
		call	pstrlen
		movq	%rax, -40(%rbp) #save the len val in the stack

		#check the dst length
	    movq	-16(%rbp), %rdi #send the second ps to pstrlen
		call	pstrlen
		movq	%rax, -48(%rbp) #save the len val in the stack
		
		#char i
	    movq    $format_index, %rdi
	    leaq    -24(%rbp), %rsi
	    movq    $0, %rax
	    call    scanf
	    
	    #char j
	    movq    $format_index, %rdi
	    leaq    -32(%rbp), %rsi
	    movq    $0, %rax
	    call    scanf
	    
	    #send to pstrijcmp
	    movq	-8(%rbp), %rdi
	    movq	-16(%rbp), %rsi
	    movq	-24(%rbp), %rdx
	    movq	-32(%rbp), %rcx
	    call	pstrijcmp
	    movq	%rax, -8(%rbp)
	    
	    #print new dst
	    movq	$format_5, %rdi
	    movq	-8(%rbp), %rsi
	    movq    $0, %rax
	    call	printf
	    jmp .L10

	# defult case if option is invalid
	.L6:
		movq    $format_defult, %rdi
		movq    $0, %rax
	    call    printf
	    jmp .L10

	# END lable
	.L10:
		movq	%rbp, %rsp
		pop		%rbp
		ret
		
