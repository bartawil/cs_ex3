#	209215490	Bar Tawil

.section .rodata

format_len: 	.string "%d\n"
format_str: 	.string "%s\n"
format_opt: 	.string "%d"

.text

# main func:
# 	input - receives from the user two strings,Their lengths and menu option.
# 	output - Builds two pstrings according to the strings and lengths received and 
# 	sends them to func_run.
.globl run_main
	.type run_main,@function
run_main:
	push	%rbp
	movq 	%rsp, %rbp
	subq 	$528, %rsp

	#scan first ps length
	movq 	$format_len, %rdi
	leaq 	(%rsp), %rsi
	movq 	$0, %rax
	call 	scanf

	#scan first ps string
	movq 	$format_str, %rdi
	leaq	1(%rsp), %rsi
	movq 	$0, %rax
	call 	scanf

	#scan second ps length
	movq 	$format_len, %rdi
	leaq 	256(%rsp), %rsi
	movq 	$0, %rax
	call 	scanf

	#scan second ps string
	movq 	$format_str, %rdi
	leaq	257(%rsp), %rsi
	movq 	$0, %rax
	call 	scanf

	#scan opt
	movq 	$format_opt, %rdi
	leaq	512(%rsp), %rsi
	movq 	$0, %rax
	call 	scanf

	#send opt, ps1 and ps2 to run_func
	movq 	$0, %rdi
	movq 	512(%rsp), %rdi #opt
	leaq	(%rsp), %rsi #ps1
	leaq	256(%rsp), %rdx #ps2
	call 	run_func
	movq	%rbp, %rsp
	pop		%rbp
	ret
	
