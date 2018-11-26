	AREA	Sets, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
	LDR R0, =AElems		; adrA = address AElems
	LDR R5, [R0]		; ElemA = memory.word(adrA)
	LDR R1, =BElems		; adrB = address BElems
	LDR R6, [R1]		; ElemB = memory.word(adrB)
	LDR R2, =CElems     ; adrC = address CElems
	LDR R7, [R2]		; ElemC = memory.word(adrC)
	
	LDR R3, =ASize		; SizeA = address ASize
	LDR R3, [R3]		;       = memory.word(sizeA)
	LDR R4, =BSize		; SizeB = address BSize
	LDR R4, [R4]		;       = memory.word(sizeB)
	LDR R10, =CSize		; SizeC = address CSize 
	LDR R12, [R10]      ;       = memory.word(sizeC)
	
	LDR R8, =1			; countA = 1
	LDR R9, =1			; countB = 1
	LDR R11, =0			; trial counter = 0

whA
	CMP R5, R6			;while(AElems != BElems)
	BEQ else			;}
	ADD R1, R1, #4		; BElems =+ 4
	LDR R6, [R1]		; ElemB = memory.word(adrB) (next B value)
						;}
	ADD R8, R8, #1		; countA++
	CMP R8, R4          ; if(countA == BSize)
	BEQ endif			; {
	B   whA
		
endif					; if there is no match...	
	MOV R7, R5			; CElems =+ AElems
	STR R7, [R2]		; store CElem value in memory
	ADD R2, R2, #4		; change address
	ADD R12, R12, #1	; CSize =+ 1
	STR R12, [R10]		; storing size in memory...
	ADD R0, R0, #4		; AElems + 4
	LDR R5, [R0]		; ElemA = memory.word(adrA) (next A value)
	MOV R8, #1  		; countA = 1
	ADD R11, R11, #1	; trial counter++
	CMP R11, R3         ; if(trialCounter == ASize) {
	BEQ	endwhA          ; endloop }
	LDR R1, =BElems		;
	LDR R6, [R1]        ; resetting the address for BElems to the first value...
	B   whA				;}
	
else 					; if there is a match...
	ADD R0, R0, #4		; AElems =+ 4
	LDR R5, [R0]		; ElemA = memory.word(adrA) (next A vlaue...)
	LDR R1, =BElems		;
	LDR R6, [R1]		; resetting the adr for BElems to the first value... 
	
	ADD R11, R11, #1	; trial counter ++
	CMP R11, R3			; if(trialCounter == ASize) {
	BEQ endwhA			; end loop
	B   whA				;}  

endwhA

	LDR R0, =AElems		; reset back to first element in A
	LDR R5, [R0]
	LDR R1, =BElems     ; reset back to first element in B
	LDR R6, [R1]
	MOV R11, #0         ; reset trialCounter = 0

whB
	CMP R6, R5			;while(BElem != AElem)
	BEQ elseB			;{
	ADD R0, R0, #4		; AElems =+ 4
	LDR R5, [R0]        ; ElemA = memory.word(adrA) (next B value...)
						;
	ADD R9, R9,#1		; countB++
	CMP R9, R3          ; if(countB == sizeA)
  	BEQ endifB			; {
	B   whB             ;

endifB					; if there is no match...
    MOV R7, R6			; CElems =+ BElems
	STR R7, [R2]		; store CElem value in memory
	ADD R2, R2, #4		; change address
	ADD R12, R12, #1    ; CSize++
	STR R12, [R10]		; store size in memory
	ADD R1, R1, #4		; addrA++
	LDR R6, [R1]        ; next A value loaded 
	MOV R9, #1          ; reset countB
	ADD R11, R11, #1    ; trialCounter++
	CMP R11, R4         ; if(trialCounter == BSize){
	BEQ endwhB			; end loop }
	LDR R0, =AElems		;
	LDR R5, [R0]		; reset address to first element in A 
	B   whB				; 
	
elseB   				; if there is a match
	ADD R1, R1, #4      ; BElems =+ 4
	LDR R6, [R1]		; ElemB = memory.word(addrB) (next B value...)
	LDR R0, =AElems		; 
	LDR R5, [R0]		; resetting AElems to the first value
	
	ADD R11, R11, #1	; trialCounter++
	CMP R11, R4         ; if(trialCounter == BSize){
	BEQ endwhB          ; end loop} 
	B   whB				;
	
endwhB

; size stored in R10 in memory...
; Elems stored in R2 in memory...
	
	
stop	B	stop


	AREA	TestData, DATA, READWRITE
	
ASize	DCD	8			; Number of elements in A
AElems	DCD	4,6,2,13,19,7,1,3	; Elements of A

BSize	DCD	6			; Number of elements in B
BElems	DCD	13,9,1,9,5,8		; Elements of B

CSize	DCD	0			; Number of elements in C
CElems	SPACE 56			; Elements of C

	END	
