TITLE  Fibonacci Numbers   (fib_sequence.asm)

; Author: Luwey Hon
; Description: This program first includes a heading and afterwards presents instructions
; to do a fibonacci sequence. It will store their number and present their sequence
; in columns of 5. The program will repeat until the user request to quit and displays some
; stuff in color. It also shows their sum of their fibonnaci sequence and the total sum 
; of all their fibonacci atempts if there is no overflow.
; The program concludes with a farewell address.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
; heading variables
	program_title		BYTE	"Fibonacci Numbers", 0
	heading				BYTE	"Programmed by Luwey Hon", 0
	spacing_ec			BYTE	"**EC: Prints out even spacing", 0
	do_amazing			BYTE	"**EC: Something Amazing!: ",0
	ec_repeat			BYTE	"    1) Repeats Fib sequence until user quit",0
	ec_color			BYTE	"    2) Added color",0
	ec_current_sum		BYTE	"    3) Caclulate current sum of fib sequences (in yellow)",0
	ec_all_sum			BYTE	"    4) Calculate sum of all fib sequence tries(sum of all yellow in green)",0
	note_reminder		BYTE	" NOTE: ", 0
	ec_note				BYTE	"To see EC sum, please exit and retry with small fib number (no overflow).",0
	ec_note_2			BYTE	"       Also must say YES to see incredible (if you want to see it).", 0
										

; variables that we get info from user
	user_name			BYTE	33 DUP(0)		; this will hold the user name
	fib_amount			DWORD	?			; How far in the fibonacci sequence they requested
	re_do				DWORD	?			; will ask if they would like to do the fib sequence again
	incredible			DWORD	?			; will ask to see if they would like to see something incredible
	total_all_sum		DWORD	?				; total sum for fib sequence of all tries
	total_current_sum	DWORD	?				; total sum for most current fib sequence

; variables for printing purposes 
	name_prompt			BYTE	"What's your name? ",0
	hello				BYTE	"Hello, ",0
	fib_prompt_1		BYTE	"Enter the number of Fibonacci terms to be displayed.",0
	fib_prompt_2		BYTE	"Give the number as an integer in the range [1 .. 46].", 0
	ask_fib_num			BYTE	"How many Fibonacci terms do you want? ",0
	fib_out_range		BYTE	"Out of range. Enter a number between 1 through 46", 0 
	small_range			BYTE	"Number is too small. Please enter a number in [1 .. 46].",0
	big_range			BYTE	"Number is too big. Please enter a number in [1 .. 46].",0
	spacing				BYTE	"           ",0    ; 11 spaces
	add_space			BYTE	" ", 0   ; 1 space ( will increment every space later)
	ask_repeat			BYTE	"Would you like to do the fibonacci sequence again? (0 for no. >=1 for yes): ",0
	ask_incredible		BYTE	"Would you like to see something incredible? (0 for no. >= 1 for yes): ", 0
	total_current		BYTE	"Total sum: ",0
	total_all			BYTE	"Total sum of all Fibonacci attempts (total numbers in yellow): ",0
	overflow_note		BYTE	"   Note: Calculation are correct if there is no overflow.",0
	overflow_note_2		BYTE	"      Please exit and retry again if overflows happen.",0

			
; variables for calculating fib number
	first_fib_num		DWORD	1			; it initalizes at 1
	second_fib_num		DWORD	1			; it initializes at 1
	length_count		DWORD	?			; counts the length of the integer
	counter				DWORD	0		; this will count the term in fib sequence

; farewell variables
	conclusion			BYTE	"Results certified by Luwey Hon", 0
	goodbye				BYTE	"Goodbye, ", 0

; (insert variable definitions here)

.code
main PROC

;introduction

	;displaying the heading. This section is just all printing and color
		mov		eax,cyan + (black * 16)
		call	SetTextColor						; main heading in cyan
		mov		edx, OFFSET program_title
		call	WriteString
		call	CrLf
		mov		edx, OFFSET heading
		call	WriteString
		call	CrLf
		call	CrLf
		mov		eax, lightCyan + (black * 16)
		call	SetTextColor						; extra credit instruction in light cyan
		mov		edx, OFFSET spacing_ec
		call	WriteString
		call	CrLf
		mov		edx, OFFSET do_amazing
		call	WriteString
		call	CrLf
		mov		edx, OFFSET ec_repeat
		call	WriteString
		call	CrLf
		mov		edx, OFFSET ec_color
		call	WriteString
		call	CrLf
		mov		edx, OFFSET ec_current_sum
		call	WriteString
		call	CrLf
		mov		edx, OFFSET ec_all_sum
		call	WriteString
		call	CrLf
		mov		eax, lightRed + (black * 16)			; make note in light red
		call	SetTextColor
		mov		edx, OFFSET note_reminder				
		call	WriteString
		mov		eax, lightCyan + (black * 16)			; extra credit back to light cyan
		call	SetTextColor
		mov		edx, OFFSET ec_note
		call	WriteString
		call	CrLf
		mov		edx, OFFSET ec_note_2
		call	WriteString
		mov		eax, white + (black * 16)			; back to black and white
		call	SetTextColor
		call	CrLf
		call	CrLf


	;getting the user's name
		mov		edx, OFFSET name_prompt
		call	WriteString
		mov		edx, OFFSET user_name			
		mov		ecx, 32
		call	ReadString						; stores the user name

	;saying hello to user
		mov		edx, OFFSET hello
		call	WriteString
		mov		edx, OFFSET user_name
		call	WriteString
		call	CrLf


; display user's instructions
	mov		eax, lightBlue + (black * 16)
	call	SetTextColor						; make instructions light blue
	mov		edx, OFFSET fib_prompt_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET fib_prompt_2
	call	WriteString
	mov		eax, white + (black * 16)			; back to black and white
	call	SetTextColor
	call	CrLf
	call	CrLf


; get user's data
	re_validate:			; jumping back here to re_validate numbers. 
							; Also use this label when to repeat program (this is for later)

	;getting the amount of fibonacci terms requested
		mov		edx, OFFSET	ask_fib_num
		call	WriteString
		call	ReadInt				
		mov		fib_amount, eax			; storing their fib amount
		call	CrLf

	;validating the correct range
		mov		eax, fib_amount
		cmp		eax, 1
		jl		too_small			; if fib_amount < 1
		cmp		eax, 46
		ja		too_big				; if fib_amount > 46
		jmp		correct_validation		; passed validation test


	; when fib num requested is too small
	too_small:
		mov		eax, lightRed + (black * 16)		; turn error message light red
		call	SetTextColor
		mov		edx, OFFSET small_range			; print error message
		call	WriteString
		mov		eax, white + (black * 16)		; back to normal color
		call	SetTextColor
		call	CrLf
		call	CrLf
		jmp		re_validate				; jump to revalidate if user's input is < 1

	; when fib number requested is too big
	too_big:
		mov		eax, lightRed + (black * 16)		; turn error message light red
		call	SetTextColor
		mov		edx, OFFSET big_range			; print error message
		call	WriteString
		mov		eax, white + (black * 16)		; back to normal color
		call	SetTextColor
		call	CrLf
		call	CrLf
		jmp		re_validate				; jump to revalidate if user input's is > 46

correct_validation:			; successfully passed validation

;checking the fib numbers	
	mov		eax, fib_amount
	cmp		eax, 2
	jle		fib_1_or_2				; when fib_amount = 1 or 2
	jg		fib_sequence			; when fib_amount > 2

;if fib sequence = 1 or 2
	fib_1_or_2:
		call	Fib_1_or_2			; to print out fib 1 or fib 2

;if fib sequence > 2
	fib_sequence:
	
	;printing fib 1 and fib 2 which equal 1
		mov		eax, 1
		call	WriteDec
		mov		edx, OFFSET spacing
		call	WriteString
		mov		eax, 1					; printing out the first 2 fib sequence which is 1 and 1
		call	WriteDec
		mov		edx, OFFSET spacing
		call	WriteString

	;initialize the loop
		mov		ecx, fib_amount
		sub		ecx, 2				; to make sequence start at 3 since first two numbers are = 1
		mov		eax, first_fib_num		; move 1 to first fib number
		mov		ebx, second_fib_num		; move 1 to second fib number
		add		total_all_sum, 2		; add 2 to current fib sum (for extra credit)
		add		total_current_sum, 2		; add 2 for all fib sequence sum (for extra credit)


	;looping for the fib sequence
		fib_pattern:
			add		eax, ebx
			add		total_all_sum, eax			; calculating the total of all fib sequence tries
			add		total_current_sum, eax			; calculat total sum of current fib sequence
			call	WriteDec					; print the new fib num (first fib num + second fib num)
			call	Length_of_int					; finds length of int (to help find even spacing)
			call	even_spacing					; printing out even spacing (for extra credit)
			inc		counter					; increase the count for fib sequence
			call	NewLine						; calls NewLine procedure to test if it needs a new line
			mov		edx, eax				; need an empty register to store value of first fib num
			mov		eax, ebx				; first fib num becomes second fib num
			mov		ebx, edx				; second fib num becomes new fib num
			loop	fib_pattern

finish_fib_sequence::				; for when fib 1 or fib 2 call procedure is done

; printing out the sum of the fibonacci sequence
	call	CrLf
	mov		edx, OFFSET total_current
	call	WriteString
	mov		eax, yellow + (black * 16)		; highlights the total current sum
	call	SetTextColor
	mov		eax, total_current_sum
	call	WriteDec
	mov		eax, white + (black * 16)		; changes color back to normal
	call	SetTextColor


; asking if they want to re do the fib sequence
	call	CrLf
	call	CrLf
	mov		edx, OFFSET ask_repeat
	call	WriteString
	call	ReadInt
	mov		re_do, eax
	cmp     re_do, 0
	mov		counter, 0					; reset counter in case they want to redo
	mov		total_current_sum, 0		; reset current sum to 0 in case they repeat program
	jg		re_validate					; if > 0, jumps to redo fib sequence again
	
;asking to see incredible
	call	CrLf
	mov		edx, OFFSET ask_incredible
	call	WriteString
	call	ReadInt
	mov		incredible, eax
	cmp		incredible, 0
	jle		say_good_bye				; do not want to see incredible

;seeing something incredible! It prints the total of all their fib sequence
	mov		edx, OFFSET total_all
	call	WriteString
	mov		eax, green + (black * 16)		; make it green
	call	SetTextColor
	mov		eax, total_all_sum
	call	WriteDec
	mov		eax, lightRed + (black * 16)		; turn it back to black and white
	call	SetTextColor
	call	CrLf
	mov		edx, OFFSET overflow_note
	call	WriteString
	call	CrLf
	mov		edx, OFFSET overflow_note_2
	call	WriteString

	
		
say_good_bye:
	
			
;farewell
	mov		eax, cyan + (black * 16)		; make it cyan
	call	SetTextColor
	call	CrLf
	call	CrLf
	mov		edx, OFFSET conclusion
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET user_name
	call	WriteString
	call	CrLf
	mov		eax, white + (black * 16)
	call	SetTextColor

	exit	; exit to operating system
main ENDP


;This procedure is for when we have Fib 1 or Fib 2
	fib_1_or_2 PROC USES eax
		push	fib_amount
		cmp		fib_amount, 1
		je		fib_1				; if fib amount = 1

	;when fib amount = 2, prints two 1
		mov		eax, 1
		call	WriteDec
		mov		edx, offset spacing
		inc		total_current_sum			; to calculate the sum of  current fib sequence (extra credit)
		inc		total_all_sum				; to caclulate the sum of all fib sequence (extra credit)
		call	writestring

	;when fib_amount = 1, prints one 1
		fib_1:
			mov		eax, 1
			inc		total_current_sum		; calculating sum for extra credit
			inc		total_all_sum
			call	WriteDec
	
		jmp	finish_fib_sequence		; jump to where the fib sequence is done
		ret

	fib_1_or_2 ENDP

;procedure to checking the length of an integer
	length_of_int PROC
		mov  length_count, 0	; initialize at 0 for future loops
		push eax

		cmp eax, 9					; comparing the fib number to actual sizes of numbers
		jle	one_digit					; this has 1 digit
		cmp eax, 99
		jle two_digit					; this has 2 digits 
		cmp eax, 999
		jle three_digit					; this has 3 digit and the pattern continues
		cmp eax, 9999
		jle four_digit
		cmp eax, 99999
		jle five_digit
		cmp eax, 999999
		jle six_digit
		cmp eax, 9999999
		jle seven_digit
		cmp eax, 99999999
		jle eight_digit
		cmp eax, 999999999
		jle nine_digit
		cmp eax, 4294967294			;  the maximum size of DWORD 
		jle ten_digit

		
		; increases the length for every digit
		ten_digit:						; 10 digits adds 1 ten times
			inc length_count			
		nine_digit:
			inc length_count
		eight_digit:
			inc length_count
		seven_digit:
			inc length_count
		six_digit:
			inc length_count
		five_digit:
			inc length_count
		four_digit:
			inc length_count
		three_digit:
			inc length_count
		two_digit:
			inc length_count
		one_digit:						; 1 digit only adds one 1
			inc length_count			
	
		pop eax
		ret

	length_of_int ENDP

; prints out even spacing
	even_spacing PROC uses ecx edx
		
	;initialize the loop
		mov		ecx, 12					; total spacing between integer
		sub		ecx, length_count		; decrease total spacing depending on length of integer

	; loops and prints 1 space a time
		print_spacing:
			mov		edx, OFFSET add_space
			call	WriteString				; prints 1 space
			loop	print_spacing			; continues looping
																				
		ret
	even_spacing ENDP

; Testing to see if we need to print to next line
	NewLine PROC USES eax ebx ecx edx
		push	counter
		add		counter, 2		; since the first two fib numbers are already printed (need this for allignment)
		mov		eax, counter
		cdq
		mov		ebx, 5
		div		ebx			; dividing the counter by 5
		cmp		edx, 0			; comparing the remainder to 0
		jne		no_call_line		; if remainder != 0, don't call a new line (not divisible by 5)
		
		call CrLf				; when it is divisible by 5 it calls a new line		
	
		no_call_line:				; when it is not divisble by 5, it does not call a new line
			pop counter			; restore the counter
			ret				; back to main function

	NewLine ENDP


END main
