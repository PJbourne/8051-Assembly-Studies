;Pablo Teodoro Monteiro
;02-02-2022
;
;Teclado + Display
;

        org     0000h
;------------------------------
        
        ;mov     p0,#0Fh        ;por alguma razao tive de desativar
        mov     p1,#00000000b
        mov     p2,#00000000b
        acall   delay0
        ajmp    start

;----timer varredura teclado----
        org     000bh
        acall   loop_keyboard
        mov     th0,#0FFh
        mov     tl0,#060h
        reti
;--FIM timer varredura teclado--

start:
        mov     ie,#10000010b   ;habilita TIMER0
        mov     ip,#00000010b   ;define prioridade
        mov     tcon,#00010000b  ;inicia TIMER0
        mov     tmod,#00000001b ;inc TIMER0 com ciclo de maquina/modo 16bits
        mov     th0,#0FFh
        mov     tl0,#060h       ;inicializa TIMER0 em 65376 (160*0,625=100us)
inicio:        

        
        nop        

        sjmp    inicio

;-------HERE YOUR CODE---------


;======varredura teclado=======
loop_keyboard:
;-----KEYBOARD COL SHIFT-------
       
        mov     p0,#00000001b
        acall   but0;
        mov     p0,#00000010b
        acall   but0;
        mov     p0,#00000100b
        acall   but0;
        mov     p0,#00001000b
        acall   but0;
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
        mov     r6,#0Fh
delay1:
        djnz    r6,delay1
        ret
;=======FIM rotina delay===========
        
        ajmp    $
        
        end