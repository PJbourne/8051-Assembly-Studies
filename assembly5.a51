;Pablo Teodoro Monteiro
;26-01-2022
;
;PSW e banco de registradores
;

        org     0000h
;------------------------------
;        mov     r1,#05h
;        mov     r2,#02h
;        mov     52h,#04h
;start:
;        mov     a,r1
;        add     a,r2
;        add     a,52h
;        mov     psw,#08h
;        mov     r6,a
;------------------------------
        mov     a,#00001111b
        mov     p0,a
        mov     p1,#10000000b
        ajmp    start

start:

;-------HERE YOUR CODE---------

loop:
;-----KEYBOARD COL SHIFT-------
        mov     p0,#00000001b
        acall   but0;
        mov     p0,#00000010b
        acall   but0;
        mov     p0,#00000100b
        acall   but0;
        mov     p0,#00001000b
        acall   but0;

;---------SCAN KEYBOARD---------
but0:
        jnb     p1.0,but1
        setb    B.0
        sjmp    testButt0
but1:
        jnb     p1.1,but2
        setb    B.1
        sjmp    testButt1
but2:
        jnb     p1.2,but3
        setb    B.2
        sjmp    testButt2
but3:
        jnb     p1.3,but4
        setb    B.3
        sjmp    testButt3
but4:
        jnb     p1.4,but5
        setb    B.4
        sjmp    testButt4
but5:
        jnb     p1.5,but6
        setb    B.5
        sjmp    testButt5
but6:
        jnb     p1.6,testButt0
        setb    B.6
        sjmp    testButt6
;-------------------------------
;---------KEY ACTIVED-----------
testButt0:
        jb      p1.0,$
        clr     B.0
testButt1:
        jb      p1.1,$
        clr     B.1
testButt2:
        jb      p1.2,$
        clr     B.2
testButt3:
        jb      p1.3,$
        clr     B.3
testButt4:
        jb      p1.4,$
        clr     B.4
testButt5:
        jb      p1.5,$
        clr     B.5
testButt6:
        jb      p1.6,$
        clr     B.6
        ret
;-------------------------------
        ajmp    $
        
        end