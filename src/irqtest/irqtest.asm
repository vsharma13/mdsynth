* 6809
* IRQ Test
*
	NAM IRQTEST
	OPT l
	PAGE
		
VDU	EQU	$E030
MACIA	EQU	$E010

IRQ	EQU	$7FC8


	ORG	$0F00
STACK	EQU	*
CURX	RMB	1
CURY	RMB	1
		
	ORG	$1000
	LDS	#STACK

	LDA	#0
	STA	CURX
	STA	CURY
	BSR	MOVECUR

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
	BRA	*

IRQH	LDY	#MACIA
	LDA	0,Y
	BITA	#$80
	BEQ	IRQH1
	LDX	#MSG
	BSR	PRINTS
	LDA	1,Y
IRQH1	RTI

MOVECUR	PSHS	A,Y
	LDY	#VDU
	LDA	CURX
	STA	2,Y
	LDA	CURY
	STA	3,Y
	PULS	A,Y
	RTS
	
PRINTS	PSHS	A,Y	
	LDY	#VDU
PRINTS0	LDA	,X+
	CMPA	#0
	BEQ	PRINTS1
	STA	,Y
	LDA	CURX
	INCA
	STA	2,Y
	STA	CURX
	JMP PRINTS0
PRINTS1	PULS	A,Y
	RTS

MSG	FCC	'[IRQ]'
	FCB	0
	END
