DELTA = 0x9E3779B9
.global encrypt, decrypt
.section .note.GNU-stack,"",@progbits
.text

encrypt:

	# reserve the space for these registers
	push	%r12
	push	%r13
	push	%r14
	push	%r15

	# %rdi points to buf
	movl	0(%rdi), %r8d		# y (text[0]) 0-3 bytes
	movl	4(%rdi), %r9d		# z (text[1]) 4-7 bytes

	# %rsi points to key
	movl	0(%rsi), %r10d	# k[0]	0-3 bytes
	movl	4(%rsi), %r11d	# k[1]	4-7 bytes
	movl	8(%rsi), %r12d	# k[2]	8-11 bytes
	movl	12(%rsi), %r13d	# k[3]	11-15 bytes

	# loop variables
	movl	$0, %r14d		# total sum
	movl	$0, %r15d	# n = 0

	L1_loop:
		# sum += delta;
		addl	DELTA, %r14d

		# y += ((z << 4) + k[0]) ^ (z+sum) ^ ((z >> 5) + k[1]);
		# (z << 4) + k[0]
		movl	%r9d, %ebx
		shll	$4, %ebx
		addl	%r10d, %ebx

		# (z+sum)
		movl	%r9d, %ecx
		addl	%r14d, %ecx

		xorl	%ecx, %ebx

		# (z >> 5) + k[1]]
		movl	%r9d, %edx
		shrl	$5, %edx
		addl	%r11d, %edx

		xorl	%edx, %ebx

		addl	%ebx, %r8d

		# z += ((y << 4) + k[2]) ^ (y+sum) ^ ((y >> 5) + k[3]);
		# (y << 4) + k[2]
		movl	%r8d, %ebx
		shll	$4, %ebx
		addl	%r12d, %ebx

		# (y+sum)
		movl	%r8d, %ecx
		addl	%r14d, %ecx

		xorl	%ecx, %ebx

		# (y >> 5) + k[3]]
		movl	%r8d, %edx
		shrl	$5, %edx
		addl	%r13d, %edx

		xorl	%edx, %ebx

		addl	%ebx, %r9d

		# loop comparison
		incl	%r15d
		cmpl	$32, %r15d
		jb		L1_loop

	# text[0] = y; text[1] = z;
	movl	%r8d, 0(%rdi)
	movl	%r9d, 4(%rdi)

	# free space for registers
	pop		%r15
	pop		%r14
	pop		%r13
	pop		%r12

	retq



decrypt:

	# reserve the space for these registers
	push	%r12
	push	%r13
	push	%r14
	push	%r15

	# %rdi points to buf
	movl	0(%rdi), %r8d		# y (text[0]) 0-3 bytes
	movl	4(%rdi), %r9d		# z (text[1]) 4-7 bytes

	# %rsi points to key
	movl	0(%rsi), %r10d	# k[0]	0-3 bytes
	movl	4(%rsi), %r11d	# k[1]	4-7 bytes
	movl	8(%rsi), %r12d	# k[2]	8-11 bytes
	movl	12(%rsi), %r13d	# k[3]	11-15 bytes

	# loop variables
	movl	DELTA, %r14d		# total sum
	shll	$5, %r14d				# delta << 5
	movl	$0, %r15d				# n = 0

	L2_loop:
		# z -= ((y << 4) + k[2]) ^ (y+sum) ^ ((y >> 5) + k[3]);
		# (y << 4) + k[2]
		movl	%r8d, %ebx
		shll	$4, %ebx
		addl	%r12d, %ebx

		# (y+sum)
		movl	%r8d, %ecx
		addl	%r14d, %ecx

		xorl	%ecx, %ebx

		# (y >> 5) + k[3]]
		movl	%r8d, %edx
		shrl	$5, %edx
		addl	%r13d, %edx

		xorl	%edx, %ebx

		subl	%ebx, %r9d

		# y -= ((z << 4) + k[0]) ^ (z+sum) ^ ((z >> 5) + k[1]);
		# (z << 4) + k[0]
		movl	%r9d, %ebx
		shll	$4, %ebx
		addl	%r10d, %ebx

		# (z+sum)
		movl	%r9d, %ecx
		addl	%r14d, %ecx

		xorl	%ecx, %ebx

		# (z >> 5) + k[1]]
		movl	%r9d, %edx
		shrl	$5, %edx
		addl	%r11d, %edx

		xorl	%edx, %ebx

		subl	%ebx, %r8d

		# sum -= delta;
		subl	DELTA, %r14d

		# loop comparison
		incl	%r15d
		cmpl	$32, %r15d
		jb		L2_loop

	# text[0] = y; text[1] = z;
	movl	%r8d, 0(%rdi)
	movl	%r9d, 4(%rdi)

	# free space for registers
	pop		%r15
	pop		%r14
	pop		%r13
	pop		%r12

	retq

