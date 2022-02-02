;Pablo Teodoro Monteiro
;02-02-2022
;
;Teclado + Display
;

        v0      equ     p0.7
        rs      equ     p0.6
        rw      equ     p0.5
        en      equ     p0.4
        col0    equ     p0.0
        col1    equ     p0.1
        col2    equ     p0.2
        col3    equ     p0.3
        dat     equ     p2

        org     0000h
;------------------------------
        mov     p0,#00000000b
        mov     p2,#00000000b
        acall   delay0
        ajmp    lcd_init

;----timer varredura teclado----

        org     000bh
        acall   loop_keyboard
        mov     th0,#0FFh
        mov     tl0,#060h

        reti
;--FIM timer varredura teclado--
;------LCD INIT----------

lcd_init:
        mov     a,#00111100b    ;function set
        acall   config
        mov     a,#00001111b    ;disp on/off control
        acall   config
        mov     a,#00000001b    ;clear disp
        acall   config
        mov     r2,#0FFh
        mov     r3,#05h
        acall   wait1530us      ;1610us no total - 2577 ciclos no total
        mov     a,#00000111b    ;entry mode set
        acall   config
        ajmp    start
config:
        clr     en
        clr     rs
        clr     rw
        acall   wait39us
        mov     dat,a
        acall   wait39us
        setb    en
        acall   wait39us
        clr     en
        mov     p2,#00h
        ret
wait1530us:
        djnz    r2,wait1530us
        dec     r3
        cjne    r3,#00b,wait1530us
        ret
wait39us:
        mov     r2,#03Fh
w39s:
        djnz    r2,w39s
        ret
;------Fim INIT_LCD------

start:
        mov     ie,#10000010b   ;habilita TIMER0
        mov     ip,#00000010b   ;define prioridade
        mov     tcon,#00010000b  ;inicia TIMER0
        mov     tmod,#00000001b ;inc TIMER0 com ciclo de maquina/modo 16bits
        mov     th0,#0FFh
        mov     tl0,#060h       ;inicializa TIMER0 em 65376 (160*0,625=100us)
inicio:        
        
        nop

lcd_load_msg:

        sjmp    inicio

;-------HERE YOUR CODE---------


;======varredura teclado=======
loop_keyboard:
;-----KEYBOARD COL SHIFT------

        clr     col0
        clr     col1
        clr     col2
        clr     col3
        mov     16h,a           ;salva o ACC
        mov     a,p0
        add     a,#00000001b
        mov     p0,a
        acall   but0            ;
        mov     a,p0
        add     a,#00000001b
        mov     p0,a
        acall   but0            ;
        mov     a,p0
        add     a,#00000010b
        mov     p0,a
        acall   but0            ;
        mov     a,p0
        add     a,#00000100b
        mov     p0,a
        acall   but0            ;
        mov     a,16h           ;recupera o ACC
        ret

;---------SCAN KEYBOARD---------
but0:
        jnb     p1.0,but1
        setb    B.0
        acall   testButt0
but1:
        jnb     p1.1,but2
        setb    B.1
        acall   testButt1
but2:
        jnb     p1.2,but3
        setb    B.2
        acall   testButt2
but3:
        jnb     p1.3,but4
        setb    B.3
        acall   testButt3
but4:
        jnb     p1.4,but5
        setb    B.4
        acall   testButt4
but5:
        jnb     p1.5,but6
        setb    B.5
        acall   testButt5
but6:
        jnb     p1.6,fim_but
        setb    B.6
        acall   testButt6
fim_but:
        ret
;-------------------------------
;---------KEY ACTIVED-----------
testButt:

testButt0:
        jb      p1.0,$
        clr     B.0
        acall   lcd_init
        ret
testButt1:
        jb      p1.1,$
        clr     B.1
        ret
testButt2:
        jb      p1.2,$
        clr     B.2
        ret
testButt3:
        jb      p1.3,$
        clr     B.3
        ret
testButt4:
        jb      p1.4,$
        clr     B.4
        ret
testButt5:
        jb      p1.5,$
        clr     B.5
        ret
testButt6:
        jb      p1.6,$
        clr     B.6
        ret

;=======fim varredura teclado======
;=======rotina delay===============
delay0:
        mov     p1,#00000000b
        mov     r6,#0FFh
delay1:
        djnz    r6,delay1
        ret
;=======FIM rotina delay 324us===========
        
        ajmp    $
        
        end