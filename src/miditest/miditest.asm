*
*    Adaptation of the micro-C driver under FLEX
*
*	   12-Dec-81  M.Ohta,H.Tezuka
*
	
	OPT	l
	ORG	$100

_00001	PSHS	D,X,Y		multiply
	
	LDA	,S
	LDB	3,S
	MUL
	STB	4,S
	
	LDD	1,S
	MUL
	STB	5,S
	
	LDA	1,S
	LDB	3,S
	MUL
	ADDA	4,S
	ADDA	5,S
	
	LEAS	6,S
	RTS
*
_00002	CLR	,-S		signed divide
	
	CMPX	#0
	BPL	_02000
	
	COM	,S
	
	EXG	D,X
	LBSR	_00020
	EXG	D,X

_02000	TSTA
	BPL	_02001
	
	COM	,S
	
	LBSR	_00020
	
_02001	LBSR	_00010
	TFR	X,D
	TST	,S+
	BPL	_02002
	
	LBSR	_00020
	
_02002	RTS
*
_00003	LBSR	_00010		unsigned divide
	TFR	X,D
	RTS
*
_00004	CLR	,-S		signed modulous
	
	CMPX	#0
	BPL	_04000
	
	EXG	D,X
	BSR	_00020
	EXG	D,X

_04000	TSTA
	BPL	_04001
	
	COM	,S
	BSR	_00020
	
_04001	BSR	_00010
	
	TST	,S+
	BPL	_04002
	
	BSR	_00020
	
_04002	RTS
*
_00005	BSR	_00010		unsigned modulous

	RTS
*
_00006	CMPX	#0		signed left shift
	BMI	_06001
 
_06000	BEQ	_06009
	LSLB
	ROLA
	LEAX	-1,X
	BRA	_06000
	
_06001	BEQ	_06009
	ASRA
	RORB
	LEAX	1,X
	BRA	_06001
	
_06009	RTS
*
_00007	CMPX	#0		unsined left shift
	BMI	_07001
	
_07000	BEQ	_07009
	LSLB
	ROLA
	LEAX	-1,X
	BRA	_07000
	
_07001	BEQ	_07009
	LSRA
	RORB
	LEAX	1,X
	BRA	_07001
	
_07009	RTS
*
_00008	CMPX	#0		sined right shift
	BMI	_08001
	
_08000	BEQ	_08009
	ASRA
	RORB
	LEAX	-1,X
	BRA	_08000
	
_08001	BEQ	_08009
	LSLB
	ROLA
	LEAX	1,X
	BRA	_08001
	
_08009	RTS
*
_00009	CMPX	#0		unsined right shift
	BMI	_09001
	
_09000	BEQ	_09009
	LSRA
	RORB
	LEAX	-1,X
	BRA	_09000
	
_09001	BEQ	_09009
	LSLB
	ROLA
	LEAX	1,X
	BRA	_09001
	
_09009	RTS
*
_00020	NEGA			negate D reg
	NEGB
	SBCA	#0
	RTS
*
_00010	PSHS	D,X		divide subroutine
	
	CLRA
	CLRB
	
	LDX	#17
	
_00011	SUBD	2,S
	BCC	_00012
	
	ADDD	2,S
	
_00012	ROL	1,S
	ROL	,S
	ROLB
	ROLA
	
	LEAX	-1,X
	BNE	_00011
	
	RORA
	RORB
	
	COM	1,S
	COM	,S
	PULS	X
	
	LEAS	2,S
	RTS

	ORG	$0F00
STACK	EQU	*
		
	ORG	$1000
	LDS	#STACK
	JSR	_INITIALIZE
	JSR	main
	BRA	*
curx	EQU	0
cury	EQU	1
printc
	PSHS	U
	LEAU	,S
	LDD	#57395
	TFR	D,X
	LDB	1,Y
	SEX
	STB	0,X
	LDD	#57394
	TFR	D,X
	LDB	0,Y
	SEX
	STB	0,X
	LDD	#57392
	TFR	D,X
	LDB	5,U
	SEX
	STB	0,X
	LEAX	0,Y
	LDB	,X
	INC	,X
	SEX
	LDB	0,Y
	SEX
	SUBD	#80
	LBLE	_2
	CLRA
	CLRB
	STB	0,Y
	LEAX	1,Y
	LDB	,X
	INC	,X
	SEX
_2
	LDB	1,Y
	SEX
	SUBD	#24
	LBLE	_3
	CLRA
	CLRB
	STB	1,Y
_3
	LDD	#57395
	TFR	D,X
	LDB	1,Y
	SEX
	STB	0,X
	LDD	#57394
	TFR	D,X
	LDB	0,Y
	SEX
	STB	0,X
	PULS	U,PC
prints
	PSHS	U
	LEAU	,S
	LDD	#57395
	TFR	D,X
	LDB	1,Y
	SEX
	STB	0,X
_5
	LDB	[4,U]
	SEX
	LBEQ	_4
	LDD	#57394
	TFR	D,X
	LDB	0,Y
	SEX
	STB	0,X
	LDB	[4,U]
	SEX
	PSHS	D
	LDD	#57392
	TFR	D,X
	PULS	D
	STB	0,X
	LEAX	0,Y
	LDB	,X
	INC	,X
	SEX
	LDD	4,U
	ADDD	#1
	STD	4,U
	SUBD	#1
	LBRA	_5
_4
	LDD	#57394
	TFR	D,X
	LDB	0,Y
	SEX
	STB	0,X
	PULS	U,PC
moveto
	PSHS	U
	LEAU	,S
	LDB	5,U
	SEX
	STB	0,Y
	LDB	7,U
	SEX
	STB	1,Y
	LDD	#57394
	TFR	D,X
	LDB	0,Y
	SEX
	STB	0,X
	LDD	#57395
	TFR	D,X
	LDB	1,Y
	SEX
	STB	0,X
	PULS	U,PC
clearscr
	PSHS	U
	LEAU	,S
	LEAS	-2,S
	CLRA
	CLRB
	STB	-2,U
_7
	LDB	-2,U
	SEX
	SUBD	#25
	LBGE	_6
	LDD	#57395
	TFR	D,X
	LDB	-2,U
	SEX
	STB	0,X
	CLRA
	CLRB
	STB	-1,U
_10
	LDB	-1,U
	SEX
	SUBD	#80
	LBGE	_9
	LDD	#57394
	TFR	D,X
	LDB	-1,U
	SEX
	STB	0,X
	LDD	#57392
	TFR	D,X
	LDD	#32
	STB	0,X
_11
	LEAX	-1,U
	LDB	,X
	INC	,X
	SEX
	LBRA	_10
_9
_8
	LEAX	-2,U
	LDB	,X
	INC	,X
	SEX
	LBRA	_7
_6
	PULS	D,U,PC
printh4
	PSHS	U
	LEAU	,S
	LDD	4,U
	ANDA	#0
	ANDB	#15
	STD	4,U
	LDD	4,U
	SUBD	#9
	LBLS	_12
	LDD	4,U
	SUBD	#10
	ADDD	#65
	PSHS	D
	LBSR	printc
	LEAS	2,S
	LBRA	_13
_12
	LDD	4,U
	ADDD	#48
	PSHS	D
	LBSR	printc
	LEAS	2,S
_13
	PULS	U,PC
printh8
	PSHS	U
	LEAU	,S
	LDD	4,U
	ANDA	#0
	ANDB	#255
	STD	4,U
	LDD	#4
	PSHS	D
	LDD	4,U
	PULS	X
	LBSR	_00009
	PSHS	D
	LBSR	printh4
	LEAS	2,S
	LDD	4,U
	PSHS	D
	LBSR	printh4
	LEAS	2,S
	PULS	U,PC
printh16
	PSHS	U
	LEAU	,S
	LDD	#8
	PSHS	D
	LDD	4,U
	PULS	X
	LBSR	_00009
	PSHS	D
	LBSR	printh8
	LEAS	2,S
	LDD	4,U
	PSHS	D
	LBSR	printh8
	LEAS	2,S
	PULS	U,PC
checkch
	PSHS	U
	LEAU	,S
	LDD	#57376
	TFR	D,X
	LDB	0,X
	SEX
	ANDA	#0
	ANDB	#1
	SUBD	#0
	LBEQ	_14
	LDD	#-1
	PULS	U,PC
_14
	CLRA
	CLRB
	PULS	U,PC
getch
	PSHS	U
	LEAU	,S
	LEAS	-2,S
_16
	LDD	#57376
	TFR	D,X
	LDB	0,X
	SEX
	ANDA	#0
	ANDB	#1
	SUBD	#0
	LBEQ	_16
_15
	LDD	#57377
	TFR	D,X
	LDB	0,X
	SEX
	STD	-2,U
	LDD	-2,U
	ANDA	#0
	ANDB	#255
	PULS	X,U,PC
scheckch
	PSHS	U
	LEAU	,S
	LDD	#57344
	TFR	D,X
	LDB	0,X
	SEX
	ANDA	#0
	ANDB	#1
	SUBD	#0
	LBEQ	_17
	LDD	#-1
	PULS	U,PC
_17
	CLRA
	CLRB
	PULS	U,PC
sgetch
	PSHS	U
	LEAU	,S
	LEAS	-2,S
_19
	LDD	#57344
	TFR	D,X
	LDB	0,X
	SEX
	ANDA	#0
	ANDB	#1
	SUBD	#0
	LBEQ	_19
_18
	LDD	#57345
	TFR	D,X
	LDB	0,X
	SEX
	STD	-2,U
	LDD	-2,U
	ANDA	#0
	ANDB	#255
	PULS	X,U,PC
mbuf	EQU	2
mbufwi	EQU	18
mbufri	EQU	20
mbufc	EQU	22
mcheckch
	PSHS	U
	LEAU	,S
	LDD	22,Y
	SUBD	#0
	LBLS	_20
	LDD	#-1
	PULS	U,PC
_20
	CLRA
	CLRB
	PULS	U,PC
mgetch
	PSHS	U
	LEAU	,S
	LEAS	-2,S
_22
	LDD	22,Y
	SUBD	#0
	LBEQ	_22
_21
	LDD	20,Y
	LEAX	2,Y
	LDB	D,X
	SEX
	STD	-2,U
	LDD	20,Y
	ADDD	#1
	STD	20,Y
	SUBD	#1
	LDD	20,Y
	SUBD	#16
	LBLO	_23
	CLRA
	CLRB
	STD	20,Y
_23
	LDD	22,Y
	ADDD	#-1
	STD	22,Y
	SUBD	#-1
	LDD	-2,U
	ANDA	#0
	ANDB	#255
	PULS	X,U,PC
mirqh
	PSHS	U
	LEAU	,S
	LEAS	-2,S
	LDD	#57360
	TFR	D,X
	LDB	0,X
	SEX
	ANDA	#0
	ANDB	#128
	SUBD	#0
	LBEQ	_24
	LDD	#57361
	TFR	D,X
	LDB	0,X
	SEX
	STD	-2,U
	LDD	22,Y
	SUBD	#16
	LBHS	_25
	LDD	18,Y
	LEAX	2,Y
	LEAX	D,X
	LDD	-2,U
	STB	0,X
	LDD	18,Y
	ADDD	#1
	STD	18,Y
	SUBD	#1
	LDD	18,Y
	SUBD	#16
	LBLO	_26
	CLRA
	CLRB
	STD	18,Y
_26
	LDD	22,Y
	ADDD	#1
	STD	22,Y
	SUBD	#1
_25
_24
	PULS	D,U,PC
MACIA	EQU	$E010
IRQ	EQU	$7FC8

IRQH	LBSR	mirqh
	RTI

* Initialize the MIDI port with interrupts

_minit

* We set the interrupt handler
	LDX	#IRQ
	LDD	#IRQH
	STD	,X

* We configure the MIDI ACIA
	LDX	#MACIA
	LDA	#$D5
	STA	,X

* We enable the interrupts
	ANDCC	#$EF

	RTS
minit
	PSHS	U
	LEAU	,S
	CLRA
	CLRB
	STD	18,Y
	CLRA
	CLRB
	STD	20,Y
	CLRA
	CLRB
	STD	22,Y
	LBSR	_minit
	PULS	U,PC
main
	PSHS	U
	LEAU	,S
	LEAS	-2,S
	LBSR	clearscr
	CLRA
	CLRB
	PSHS	D
	CLRA
	CLRB
	PSHS	D
	LBSR	moveto
	LEAS	4,S
	LEAX	2,PC
	BRA	_27
	FCB	77,73,68,73,32,84,101,115
	FCB	116,0
_27
	PSHS	X
	LBSR	prints
	LEAS	2,S
	LBSR	minit
	LDD	#1
	PSHS	D
	CLRA
	CLRB
	PSHS	D
	LBSR	moveto
	LEAS	4,S
	LBSR	mgetch
	STD	-2,U
_29
	LBSR	mgetch
	STD	-2,U
	LDD	-2,U
	SUBD	#144
	LBEQ	_30
	LDD	-2,U
	SUBD	#128
	LBEQ	_30
	LEAX	2,PC
	BRA	_31
	FCB	42,42,69,82,82,79,82,58
	FCB	0
_31
	PSHS	X
	LBSR	prints
	LEAS	2,S
_30
	LDD	-2,U
	PSHS	D
	LBSR	printh8
	LEAS	2,S
	LBSR	mgetch
	STD	-2,U
	LDD	-2,U
	PSHS	D
	LBSR	printh8
	LEAS	2,S
	LBSR	mgetch
	STD	-2,U
	LDD	-2,U
	PSHS	D
	LBSR	printh8
	LEAS	2,S
	LBRA	_29
_28
	CLRA
	CLRB
	PULS	X,U,PC
_1	RTS
_INITIALIZE	EQU	_1
_GLOBALS	EQU	24
	END
