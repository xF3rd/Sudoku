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
mov dl,'|'
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
mov dl,'-'
int 21h
dec cl

jmp loop1
sai:
mov dl,10
int 21h
endm

imprime_matriz macro proc
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

    add bx, 9               ;contador de coluna
    dec ch                  ;decrementa linha
    jnz inicio
endm

comp_enter macro proc
    pula:

    pula_linha

    mov ah,09h
    lea dx,aviso
    int 21h

    pula_linha

    mov ah,01h                  ;jogador digita ou aperta o enter
    int 21h
    cmp al,0Dh                  ;se ele não apertar, pula para um aviso
    jne pula
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


msg1 db 'Qual coluna quer mudar:$',10
msg2 db 'Qual linha quer mudar:$',10
msg3 db 'Qual numero vai colocar:$',10
msg4 db 'Digite:',10,'1-Continuar a troca de numero',10,'2-Terminar a matriz','$'
msg5 db 'Resposta errada!!!!$'
msg6 db 'Resposta certa$',10,'Parabens!!!!$'
msg7 db 13,'JOGO SUDOKO',10
     db ' ',10
     db 'Informacoes iniciais sobre o jogo:',10
     db 13,'O objetivo do jogo e completar todos os quadrados',10 
     db 'utilizando numeros de 1 a 9. Para completa-los',10
     db 'nao pode haver numeros repetidos nas linhas',10 
     db 'horizontais e verticais.',10
     db ' ',10
     db '(Clique na tecla enter para continuar)','$'
msg8 db 'Desejo-lhe boa sorte amigo ;)!',10
     db ' ',10
     db '(Clique na tecla enter para começar o jogo)',10,'$'
aviso db 10,13,'Nao amigo, aperte a tecla enter para comecar a jogar :(','$'
fimjogo db ' ',10
        db 'FIM DE JOGO!',10
        db ' ',10
        db '(Aperte a tecla enter para reiniciar o jogo)','$'
.stack 100h
.code

main proc

    mov ax,@data
    mov ds,ax                   ;inicializa ds
    mov es,ax                   ;inicializa es
    lea bx,MATRIZ               ;o vetor armazenado em bx

novamente:
    call info_jogo
    call troca_numero
    call verifica_matriz
    cmp bx,81
    je certo
    jmp errado

certo:
    pula_linha
    xor dx,dx
    mov dx,offset msg6      
    mov ah,09               
    int 21h
    jmp fim

errado:
    pula_linha
    xor dx,dx
    mov dx,offset msg5      
    mov ah,09               
    int 21h

fim:
    pula_linha
    lea dx,fimjogo
    mov ah,09               
    int 21h
    
    pula_linha
    mov ah,01h
    int 21h
    cmp al,0Dh
    je novamente

    call compara_enter
    jmp novamente

main endp

compara_enter proc
     pula:

    pula_linha

    mov ah,09h
    lea dx,aviso
    int 21h

    pula_linha

    mov ah,01h                  ;jogador digita ou aperta o enter
    int 21h
    cmp al,0Dh                  ;se ele não apertar, pula para um aviso
    jne pula

    ret
compara_enter endp

info_jogo proc

    pula_linha
    mov ax,ax                   ;printa as informações do jogo
    mov ah,09h
    lea dx,msg7
    int 21h

    pula_linha

    mov ah,01h                  ;jogador digita ou aperta o enter
    int 21h
    cmp al,0Dh                  ;se ele não apertar, pula para um aviso
    jne pula

    pula_linha

    mov ah,09h
    lea dx,msg8
    int 21h

    mov ah,01h                  ;jogador digita ou aperta o enter
    int 21h
    cmp al,0Dh                  ;se ele não apertar, pula para um aviso
    jne pula
    
    ret                         ;vai para o precedimento de impressão de matriz

    pula_linha

    call compara_enter
    
    ret                         ;vai para o precedimento de impressão de matriz

info_jogo endp

troca_numero proc
    continua3:
    imprime_matriz          ;macro de impressão de matriz

    xor si,si               ;zera o registrador de linha
    xor bx,bx               ;zera o registrador da coluna
    xor dx,dx               ;zerar o registrador dx p/ imprimir mensagem sem poluição
    pula_linha
    
    mov dl,offset msg1      
    mov ah,09               
    int 21h                 
    mov ah,01                              
    int 21h                 ;recebe o caracter da coluna                
    sub al,30h              ;inverte o caracter para binário
    mov bl,al               ;valor recebido vai ser armazenado em bx
    dec bl                  ;ajusta valor recebido para entrar na matriz
    pula_linha
    jmp continua4

    continua:
    jmp continua3

    continua4:
    mov dl,offset msg2      
    mov ah,09               
    int 21h                 
    mov ah,01               
    int 21h                 ;recebe o caracter da linha
    sub al,30h              ;inverte o caracter para binário
    xor ah,ah               ;limpa parte alta de ax
    dec al                  ;ajusta valor para entrar na matriz
    mov ch,9
    mul ch                  ;multiplica o valor recebido para achar a linha certa 
    xor ah,ah
    mov si,ax               ;coloca em si
    pula_linha
    

    mov dl,offset msg3      
    mov ah,09               
    int 21h                 
    mov ah,01               ;recebe o caracter da substituição
    int 21h
    mov dh,al               ;guarda valor
    
    
    pula_linha                 
    mov MATRIZ[bx][si],dh   ;substituição do caracter na matriz

    pula_linha
    xor dx,dx
    mov dl,offset msg4      
    mov ah,09               
    int 21h
    pula_linha
    mov ah,01               ;recebe resposta
    int 21h

    mov dh,al
    sub dh,30h
    cmp dh,1                ;ve se usuario quer continuar
    je continua
    
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

