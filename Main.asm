.MODEL SMALL

pula_linha MACRO proc               ;macro de pular linha
mov ah,02h
mov dl,10
int 21h    
endm

linha_vert macro proc               ;macro para fazer linha na vertical
mov ah,02h
mov dl,' '
int 21h
mov dl,0b3h
int 21h
mov dl,' '
int 21h
endm

push_reg macro proc                 ;macro de push de registradores
push ax
push bx
push cx
push dx
endm

pop_reg macro proc                  ;macro de pop de registradores
pop ax
pop bx
pop cx
pop dx
endm

barra macro proc                    ;faz barra na horizontal
mov cl,35

loop1:
cmp cl,0
je sai
mov ah,02h
mov dl,0c4h
int 21h
dec cl

jmp loop1
sai:
mov dl,10
int 21h
endm

barra2 macro proc                    ;faz barra na horizontal
mov cl,35

loop2:
cmp cl,0
je sai2
mov ah,02h
mov dl,0c4h
int 21h
dec cl

jmp loop2
sai2:
mov dl,10
int 21h
endm

.data
MATRIZ  db 34h,20h,20h,33h,20h,38h,20h,20h,36h
        db 32h,33h,20h,20h,36h,20h,34h,20h,20h
        db 20h,20h,39h,34h,20h,20h,37h,20h,20h
        db 38h,39h,20h,37h,20h,20h,20h,20h,20h
        db 35h,20h,20h,20h,20h,20h,39h,31h,20h
        db 20h,36h,20h,20h,20h,20h,20h,20h,37h
        db 20h,20h,38h,20h,31h,20h,20h,34h,33h
        db 20h,34h,31h,20h,20h,20h,20h,36h,20h
        db 20h,20h,20h,38h,20h,32h,20h,37h,20h


Matriz_resposta db 34h,31h,35h,33h,37h,38h,32h,39h,36h
                db 32h,33h,37h,31h,36h,39h,34h,38h,35h
                db 36h,38h,39h,34h,32h,35h,37h,33h,31h
                db 38h,39h,33h,37h,35h,31h,36h,32h,34h
                db 35h,37h,34h,32h,33h,36h,39h,31h,38h
                db 31h,36h,32h,39h,38h,34h,33h,35h,37h
                db 39h,32h,38h,36h,31h,37h,35h,34h,33h
                db 37h,34h,31h,35h,39h,33h,38h,36h,32h
                db 33h,35h,36h,38h,34h,32h,31h,37h,39h


msg1 db 10,'Qual coluna quer mudar:$'
msg2 db 10,'Qual linha quer mudar:$'
msg3 db 10,'Qual numero vai colocar:$'
msg4 db '(Depois de completar a matriz, aperte',10
     db 'a tecla ENTER para saber o resultado',10
     db 'do jogo)$'
     db ' ',10
msg5 db 10,'Matriz nao confere :(. Tente novamente!$'
     db ' ','$',10
msg6 db 10,'Matriz confere :). Parabens!!!!$',10
     db ' ',10
msg7 db 13,'JOGO SUDOKO',10
     db ' ',10
     db 'Informacoes iniciais sobre o jogo:',10
     db ' ',10
     db '   O objetivo do jogo e completar to-',10 
     db 'dos os quadrados utilizando numeros',10
     db 'de 1 a 9.',10 
     db '   Para completa-los nao pode haver ',10 
     db 'numeros repetidos nas linhas hori-',10
     db 'zontais e verticais.',10
     db 'Vamos comecar :D?',10
     db ' ',10
     db '(Clique na tecla enter para continuar)$'
msg8 db 'Desejo-lhe boa sorte amigo ;)!',10
     db ' ',10
     db '(Clique na tecla enter para comecar o jogo)$',10
aviso db 10,'Nao amigo, aperte a tecla enter para continuar',10
      db 'Tente novamente!$'
.stack 100h
.code

main proc

    mov ax,@data
    mov ds,ax                   ;inicializa ds
    mov es,ax                   ;inicializa es
    lea bx,MATRIZ               ;o vetor armazenado em bx



volta3:

    pula_linha
    mov ax,ax                   ;printa as informações do jogo
    mov ah,09h
    lea dx,msg7
    int 21h

    pula_linha

    mov ah,01h                  ;jogador digita ou aperta o enter
    int 21h
    cmp al,0Dh                  ;se ele não apertar, pula para um aviso
    je pula3

javiso:

    mov ah,09h
    lea dx,aviso
    int 21h
    pula_linha
    mov ah,01h                  ;jogador digita ou aperta o enter
    int 21h
    cmp al,0Dh                  ;se ele não apertar, pula para um aviso
    je pula3
    jmp javiso

pula3:
    mov ah,09h                  ;mensagem para iniciar o jogo
    lea dx,msg8
    int 21h
    pula_linha
    mov ah,01h                  ;jogador digita ou aperta o enter
    int 21h
    cmp al,0Dh                  ;se ele não apertar, pula para um aviso
    je novamente

javiso2:
    mov ah,09h
    lea dx,aviso
    int 21h
    pula_linha
    mov ah,01h                  ;jogador digita ou aperta o enter
    int 21h
    cmp al,0Dh                  ;se ele não apertar, pula para um aviso
    jne javiso2

novamente:
continua:
    call imprime_matriz
    call troca_numero

    cmp ch,1                ;ve se usuario quer continuar
    jne continua

    call verifica_matriz
    cmp bx,81
    je certo
    jmp errado

certo:
    xor dx,dx
    mov dx,offset msg6      
    mov ah,09             
    int 21h
    jmp fim

errado:
    xor dx,dx
    mov dx,offset msg5      
    mov ah,09               
    int 21h
    jmp novamente
fim:
    mov ah,4ch
    int 21h

main endp

imprime_matriz proc
    xor bx,bx
    xor si,si               ;limpa reg

    mov ah,02h
    mov ch,9                ;contador para linha
    
    pula_linha

    inicio:
    barra
    mov cl,9                ;contador para coluna
    xor si,si               ;será a linha

mover:
    mov dl,MATRIZ[bx][si]
    int 21h
    linha_vert
    inc si                  ;exibindo a linha primeira linha da matriz
    dec cl                  ;vai pulando de colunas 9 vezes
    jnz mover

    pula_linha

    add bx,9                ;contador de coluna
    dec ch                  ;decrementa linha
    jnz inicio
    barra2
    ret
imprime_matriz endp

troca_numero proc
    
    xor si,si               ;zera o registrador de linha
    xor bx,bx               ;zera o registrador da coluna
    xor dx,dx               ;zerar o registrador dx p/ imprimir mensagem sem poluição
    

    pula_linha
    
    mov dl,offset msg4      
    mov ah,09               
    int 21h
    
    mov dl,offset msg1      
    mov ah,09               
    int 21h

    mov ah,01                              
    int 21h                 ;recebe o caracter da coluna
    
    cmp al,13
    je pula

    sub al,30h              ;inverte o caracter para binário
    mov bl,al               ;valor recebido vai ser armazenado em bx
    dec bl                  ;ajusta valor recebido para entrar na matriz
    
    mov dl,offset msg2      
    mov ah,09               
    int 21h

    mov ah,01               
    int 21h                 ;recebe o caracter da linha

    cmp al,13
    je pula

    sub al,30h              ;inverte o caracter para binário
    xor ah,ah               ;limpa parte alta de ax
    dec al                  ;ajusta valor para entrar na matriz
    mov ch,9
    mul ch                  ;multiplica o valor recebido para achar a linha certa 
    xor ah,ah
    mov si,ax               ;coloca em si
    
    mov dl,offset msg3      
    mov ah,09               
    int 21h

    mov ah,01               ;recebe o caracter da substituição
    int 21h
    
    cmp al,13
    je pula

    mov dh,al               ;guarda valor
    
    pula_linha                 
    
    mov MATRIZ[bx][si],dh   ;substituição do caracter na matriz 


    jmp pula2
    
pula:
    xor cx,cx
    inc ch
pula2:
    ret
troca_numero endp

verifica_matriz proc
xor bx,bx
xor cx,cx
xor dx,dx
mov cx,81
volta:

    cld
    lea si,MATRIZ
    lea di,Matriz_resposta
    cmpsb

    jnz certo1

continua2:
    dec cx
    cmp cx,0
    jnz volta
    jmp fim1

    certo1:
    inc bx
    jmp continua2
fim1:    
ret
verifica_matriz endp


end main

