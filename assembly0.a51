;Pablo T. Monteiro
;Estudos em Assembly
;25-01-2021
;ciclo e clock, direcionamento, registrador de uso geral
;19.200 MHz/ 12 = 1.6 MHz - clock
;1 / 1.600.000 = 625us - ciclo de maquina

                org             0000h

inicio:
                
                mov             20h,#0bbh       ; direcionamento imediato
                mov             23h,20h         ; move conteudo da RAM para endereco RAM
                mov             a,P2            ; move conteudo port2 para ACC
                add             a,23h           ; a = a + 23h

;direcionamento indireto
                
                mov             r1,#23h         ; r1 ponteiro para RAM 23h
                mov             a,@r1           ; ACC recebe conteudo de r1

;registradores de uso geral (r0 a r7)

                 
;aritmerica de reg e mem

                mov             a,#0ah          ; a recebe 0ah
                mov             b,#03h          ; b recebe 3h
                mov             23h,#60h        ; move 6h para RAM 23h
                mov             20h,#0fh        ; move fh para RAM 20h
                add             a,23h           ; a = a + M[23h] (M[23h] = 06h
                subb            a,20h           ; a = a - M[20h]
                mov             a,#0ch          ; a recebe 0ch
                mov             b,#08h          ; b recebe 08h
                mul             ab              ; a*b (b+significat, a-significat)
                mov             a,#45h          ;
                mov             b,#7            ;
                div             ab              ; a = div, b =  resto

;instrucoes logicas

                mov             a,#01010011b    ;
                mov             b,#00101001b    ;
                anl             a,b             ; a = a AND b
                cpl             a               ; a = NOT a
                orl             a,b             ; a = a OR b
                xrl             a,b             ; a = a XOR b
                rr              a               ; a = a deslocadoa direita (so o acc pode)
                rl              a               ; a = a deslocado a esquerda (so o acc pode)
                swap            a               ; swap dos nibles (i.e. 1010 1011 -> 1011 1010)

;desvios e pulos condicional e incondicional

                clr             a               ; limpa o ACC (a = 0000h)
                cpl             a               ; a = NOT a
                mov             p0,a            ;
;                jmp             inicio          ; pulo para 'inicio'

;INCONDICIONAIS:
; ajmp absolute jump    - trancar codigo numa linha
; ljmp long jump        - para saltos grandes
; sjmp short jump       - para saltos curtos
; jmp                   - saltos simples
                

;                jz              aux             ; desvia se ACC = 0 (aux e uma label declarada em algum lugar)
;                jnz             aux1            ; desvia se ACC =! 0 ( jump not zero)
                nop                             ; sem operacao (para atrasar ciclo de maquina                
aux:
                mov             p0,#0bbh        ;
aux1:
                mov             p0,#0aah        ;
                mov             a,p0            ;
;                jmp             inicio          ;


;decremento e teste


                mov             r0,#05d         ;
start:
                mov             p1,r0           ;
                djnz            r0,start        ; r0 = r0 - 1 se r0 =! 0, pula para label start
                
                mov             r0,#0d          ;Move a constante 8 para r0
                mov             dptr,#banco     ;Move um dos dados do banco para dptr
 
 ; --- Rotina Principal ---
princ:
                mov             a,r0            ;Move o conteúdo de r0 para o acc
                movc            a,@a+dptr       ;Move o byte relativo de dptr somado
                                 ;com o valor de acc para o acc
                mov             p0,a            ;Move o conteúdo de acc para Port0
                inc             r0              ;Incrementa r0
;                cjne            r0,#8d,princ    ;Compara r0 com 0 e pula se não for igual
;                ajmp    $               ;Segura o código nesta linha
 
 ; --- Banco ---


;STACK POINTER - salvando em pilha
         
continuacao:
                mov             a,#10h
                mov             b,#02h
                acall           mult            ; chama subrotina mult
                acall           divi            ; chama subrotina
                ajmp            $

mult:

                push            a               ; salva ACC na pilha
                push            b               ; salva B na pilha
                mul             ab              ; a*b
                mov             23h,a           ;
                mov             24h,b           ;
                pop             b               ; recupera da pilha
                pop             a               ; recuprera da pilha
                ret                             ; retorna para rotina principal

divi:
                push            a               ; salva ACC na pilha
                push            b               ; salva B na pilha
                div             ab              ; a/b = a [b]
                mov             25h,a           ;
                mov             26h,b           ;
                pop             b               ; recupera da pilha
                pop             a               ; recuprera da pilha
                ret                             ; retorna para rotina princip

banco:
                db              01h             ; 00000001b
                db              02h             ; 00000010b
                db              04h             ; 00000100b
                db              08h             ; 00001000b
                db              10h             ; 00010000b
                db              20h             ; 00100000b
                db              40h             ; 01000000b
                db              80h             ; 10000000b

;fim

fim:


                end