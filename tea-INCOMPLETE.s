DELTA = 0x9E3779B9
.global encrypt, decrypt
.section .note.GNU-stack,"",@progbits
.text
############################# tea ###################################
encrypt:
						# %rdi points to buf
						# %rsi points to key


	retq
############################# detea ###################################	
decrypt:
	
						# %rdi points to buf
						# %rsi points to key
						
						
	retq
	

