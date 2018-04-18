PUBLIC	PR_Out16
EXTRN	PR_NewLine:NEAR

Data	SEGMENT	PUBLIC
	simbols	DB	'0123456789ABCDEF'
Data	ENDS




Code	SEGMENT	PUBLIC
	ASSUME CS:Code, DS:Data
;--------------------------------------------------------------------------------------
;�������� ����������, ���������� ����� ����, ��� ����������������� ����� ��� ����� (15 ��� F, -15 ��� FFF1)
;--------------------------------------------------------------------------------------
PR_Out16	PROC	NEAR
	PUSH	BP								;�������� ��������
	MOV		BP,SP
	PUSH	AX								;���������� ��� �������
	PUSH	DX
	PUSH	BX

	MOV		AX,[BP+4]					;�������� � �� �����, ������� ���� �����������
	MOV		BX,16							;������ ����� �� 16; BX ������� ����� ���������
													;������� �������� ����� (� �� ��������� ������������)

	;� ������, �������� ���������: ����������� � �� ����� ����������������� A1C, ����� ������� �� ������� ����� ��� ��� �����,
	;�� ���� > ___ , � ����� ����� �������� �� ������� �����: > __C , > _1C , > A1C

	PUSH	AX								;�������� ��, ������ ��� ��� ��� ��� ���� ��������

;� ���� ����� ����� �������� ����������� ���������� ���������
LO16_Div1:
		MOV		DX,0
		DIV		BX							;AX ����� �� BX(���������), ������� ����� ������ � DX
		PUSH	AX							;�������� �������� AX (����� �����)
		MOV		AH,2						;�������� �������
		MOV		DL,'a'
		INT		21h
		POP		AX							;��������������� �����
		CMP		AX,0						;���� ��� �� ����
		JNE		LO16_Div1				;�� ����

		MOV	AH,2
		MOV DL,8							;������ ���� ����� �����
		INT 21h

		POP		AX							;��������������� ����������� �����

LO16_Div2:
		MOV		DX,0
		DIV		BX							;AX ����� �� BX(���������), ������� ����� ������ � DX
		PUSH	AX							;�������� �������� AX (����� �����)

		;CMP		DL,9						;���������� � 9
		;JA		LO16_AddA				;���� ���� ����(������?)(��������� �������� �� ������� "�", � �� �� "0")
		;ADD		DL,'0'					;�������� �������� DX (�������)

		PUSH	BX
		MOV   BX, OFFSET simbols
		MOV		AL, DL
		XLAT
		MOV		DL, AL
		POP 	BX
		MOV		AH,2
		JMP		LO16_Add0

LO16_AddA:
		ADD		DL,'A'
		SUB		DL,10

LO16_Add0:
		INT		21h							;������������ � ��������, ������ �������
		MOV		DL,8						;��������� ����� ������
		INT		21h
		INT		21h
		POP		AX							;��������������� ���������� �����
		CMP		AX,0						;���� ����� ��� �� ����
		JNE		LO16_Div2				;�� ����


	POP		BX
	POP		DX
	POP		AX
	POP		BP
	RET

	RET
PR_Out16	ENDP
;--------------------------------------------------------------------------------------
Code	ENDS

END