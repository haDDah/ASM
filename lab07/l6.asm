EXTRN	PR_PrintMenu:NEAR
EXTRN	PR_InputInt:NEAR
;EXTRN	PR_Out2:NEAR
;EXTRN	PR_Out2S:NEAR
;EXTRN	PR_Out10:NEAR
;EXTRN	PR_Out10S:NEAR
;EXTRN	PR_Out16:NEAR
;EXTRN	PR_Out16S:NEAR
EXTRN	PR_NullFunc:NEAR
PUBLIC	PR_NewLine, sEnter


Data	SEGMENT	PUBLIC
	Funcs		DW	PR_PrintMenu, PR_InputInt, PR_NullFunc, PR_NullFunc, PR_NullFunc, PR_NullFunc, PR_NullFunc, PR_NullFunc;, PR_Out2, PR_Out2S, PR_Out10, PR_Out10S, PR_Out16, PR_Out16s
	X			DW	8
	sEnter		DB	'> ', '$'
Data	ENDS





Code	SEGMENT	PUBLIC
	ASSUME CS:Code, DS:Data, SS:Stack
	
PR_NewLine	PROC	NEAR
	PUSH	AX
	PUSH	DX
	
	MOV		AH,2
	MOV		DL,10
	INT		21h
	MOV		DL,13
	INT		21h
	
	POP		DX
	POP		AX
	RET
PR_NewLine	ENDP




START:
	MOV		AX,Data
	MOV		DS,AX
	
	CALL	Funcs	;�������� ���� ��� �������
	
	LEnter_Loop:
		;CALL	PR_NewLine	;�������� �����������
		CALL	PR_NewLine	;�������� �����������
		MOV		AH,9
		LEA		DX,sEnter
		INT		21h
		
		
		MOV		AH,8		;���� ������� ��� ���
		INT		21h
		CMP		AL,'8'
		JA		LEnter_Loop	;������� ������ �����, ���� >8!
		CMP		AL,'0'
		JB		LEnter_Loop	;������� ������ �����, ���� <0!
		MOV		AH,2		;�������� ��������� �����
		MOV		DL,AL
		INT		21h
		CALL	PR_NewLine
		
		MOV		BL,AL
		SUB		BL,'0'
		
		CMP		BL,8	;�������, ����� ����� ��� ����
		JE		LEnd	;���� 8 - �� ������� ����
		
		ADD		BL,BL	; ��������� �����, ������ ��� ����� ������������
		MOV		BH,0
		
		CMP		BL,2		;���� ���� �������� ������ �, �� ��������� � ����� ���� � �������
		JBE		LSkip_Push
			PUSH	X
		LSkip_Push:
		
		CALL	Funcs[BX]	;�������� ������ ������� �� �������
		
		CMP		BL,2		;���� ���� ���������� ������ �, �� �������� ����
		JBE		LSkip_Pop
			ADD		SP,2
		LSkip_Pop:
		
		CMP		BL,2		;���� ���� ������ �����
		JNE		LEnter_Loop	;�� �������� ��� ����� � ������
			MOV		X,AX
		
		
	JMP		LEnter_Loop
	
	; ����� ~~~~~~~~~~~~~~~~~~
	LEnd:
	MOV		AH,4Ch
	MOV		AL,0
	INT		21h

Code	ENDS




Stack	SEGMENT STACK
	DW	128h DUP (?)
Stack	ENDS

	END START