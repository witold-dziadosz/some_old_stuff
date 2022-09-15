	# Fibonacci
	.data
format:	.ascii "N = %d"
newline:	 .ascii ""
	.global main
	.text	
main:
	push %rbx # ma być zachowany

	mov $8, %ecx
	xor %rax, %rax
	xor %rbx, %rbx
	inc %rbx

print:
	push %rax
	push %rcx

	mov $format, %rdi
	mov %rax, %rsi

	xor %rax, %rax
	call printf
	mov $newline, %rdi
	xor %rax, %rax
	call puts

	pop %rcx
	pop %rax

	mov  %rax, %rdx
	mov  %rbx, %rax
	add  %rdx, %rbx

	dec %ecx
	jnz print

	pop %rbx
	ret
	
