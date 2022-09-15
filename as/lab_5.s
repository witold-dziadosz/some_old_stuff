#----------------------------------------------------------------
# Program lab_5.s - Architektury Komputerów
#----------------------------------------------------------------
#
#  To compile&link: gcc -no-pie -o lab_5 lab_5.s
#  To run:     ./lab_5
#
#----------------------------------------------------------------


	.data
	
fmt_1:
	.asciz	"Value = %d\n"		# format string
val_1:
	.long	6			# long number
fmt_2:
	.string	"GCD(%d, %d) = %d\n"	# another format string
var_a:
	.long	3084			# first number
var_b:
	.long	1424			# second number
fmt_3:
	.string "%d %d"			# format string for scanf
fmt_4:
	.string "A=%d, B=%d\n"		# yet another format string
fmt_lf:
	.string "\n"			# just "\n"
ok_num:
	.long	0			# scanf result
argc:
	.long	0			# number of arguments
argc_tmp:
	.long	0			# number of arguments
argv:
	.quad	0			# address of argv[]
env:
	.quad	0			# address of env[]
fmt_argc:
	.string	"Argc=%d\n"		# format for argc
fmt_argv:
	.string "Argv[%d]=%s\n"		# format for argv
fmt_env:
	.string "Env[%d]=%s\n"		# format for env

#----------------------------------------------------------------

	.text
	.global main

#----------------------------------------------------------------
	
main:
	push %rbp

	mov %edi, argc
	mov %edi, argc_tmp
	mov %rsi, argv
	mov %rdx, env

	mov val_1, %rsi		# printf( char *fmt, long num ) - second argument to %rsi;
	mov $fmt_1, %rdi	# printf( char *fmt, long num ) - first argument to %rdi;
	xor %rax, %rax		# printf( char *fmt, long num ) - number of vector registers to %al 
	call printf

again:

	mov $fmt_3, %rdi
	mov $var_a, %rsi
	mov $var_b, %rdx
	mov $0, %al
	call scanf
	mov %eax, ok_num

	mov $fmt_lf, %rdi	# printf( fmt ) - first argument to %rdi;
	xor %rax, %rax		# printf( fmt ) - number of vector registers to %al 
	call printf

	cmp $2, ok_num
	jnz no_more_numbers	

	mov var_b, %rdx		# printf( fmt, num1, num2 ) - third argument to %rdx;
	mov var_a, %rsi		# printf( fmt, num1, num2 ) - second argument to %rsi;
	mov $fmt_4, %rdi	# printf( fmt, num1, num2 ) - first argument to %rdi;
	xor %rax, %rax		# printf( fmt, long num ) - number of vector registers to %al 
	call printf

	mov var_a, %edi		# nwd( long num1, long num2 ) - first argument to %rdi
	mov var_b, %esi		# nwd( long num1, long num2 ) - second argument to %rsi
	call gcd

	mov %rax, %rcx		# printf( fmt, num1, num2, result ) - fourth argument to %rcx
	mov var_b, %rdx		# printf( fmt, num1, num2, result ) - third argument to %rdx
	mov var_a, %rsi		# printf( fmt, num1, num2, result ) - second argument to %rsi
	mov $fmt_2, %rdi	# printf( fmt, num1, num2, result ) - first argument to %rdi
	mov $0, %al		# printf( fmt, num1, num2, result ) - number of vector registers to %al
	call printf

	jmp again


no_more_numbers:

	mov argc, %rsi		# printf( fmt, num ) - second argument to %rsi;
	mov $fmt_argc, %rdi	# printf( fmt, num ) - first argument to %rdi;
	xor %rax, %rax		# printf( fmt, num ) - number of vector registers to %al 
	call printf


	mov argv, %rbp		# %rbp = argv;

next_argv:
	mov (%rbp), %rdx	# printf( fmt, num, str ) - third argument to %rdx;
	mov argc, %esi
	sub argc_tmp, %esi	# printf( fmt, num, str ) - second argument to %rsi;
	mov $fmt_argv, %rdi	# printf( fmt, num, str ) - first argument to %rdi;
	xor %rax, %rax		# printf( fmt, num ) - number of vector registers to %al 
	call printf
	
	add $8, %rbp		# next argv
	decl argc_tmp		# argc_tmp--;
	jnz next_argv		# 


	mov env, %rbp		# %rbp = env;

next_env:
	cmp $0,(%rbp)		# while( env[i] != NULL )
	jz no_more_env
	mov (%rbp), %rdx	# printf( fmt, num, str ) - third argument to %rdx;
	mov argc_tmp, %esi	# printf( fmt, num, str ) - second argument to %rsi;
	mov $fmt_env, %rdi	# printf( fmt, num, str ) - first argument to %rdi;
	xor %rax, %rax		# printf( fmt, num ) - number of vector registers to %al 
	call printf
	
	add $8, %rbp		# next env
	incl argc_tmp		# argc_tmp++;
	jmp next_env

no_more_env:

	xor %rdi, %rdi		# exit( code ) - first argument to %rdi
	call exit
 
	pop %rbp

	ret

#----------------------------------------------------------------
# gcd - computes greatest common divisor
#	Arguments:	%rdi - first number
#			%rsi - second number
#	Returns:	%rax - gcd value
#----------------------------------------------------------------

	.type gcd, @function

gcd:
	cmp %rdi, %rsi		# (a==b)?
	jz computed		# yes
	jb b_below_a		# if(b < a) goto b_below_a
	sub %rdi, %rsi		# else b=b-a
	jmp gcd
b_below_a:
	sub %rsi, %rdi		# a=a-b
	jmp gcd		
computed:
	mov %rdi, %rax		# result (a==b)
	ret

