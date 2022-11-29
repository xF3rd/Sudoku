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

.data
MATRIZ db 9 dup (31h,32h,33h,34h,35h,36h,37h,38h,39h)
msg1 db 'Qual coluna quer mudar:$'
msg2 db 'Qual linha quer mudar:$'
msg3 db 'Qual numero vai colocar:$'

.stack 100h
.code

main proc

    mov ax,@data
    mov ds,ax                   ;inicializa ds
    mov es,ax                   ;inicializa es
    lea bx,MATRIZ               ;o vetor armazenado em bx

    
    call troca_numero
    call imprime_matriz

    mov ah,4ch
    int 21h

main endp

imprime_matriz proc

    xor bx,bx
    xor si,si               ;limpa reg

    mov ah,02h
    mov ch,9                ;contador para linha

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

    ret
imprime_matriz endp

troca_numero proc

    xor si,si
    xor bx,bx

    mov dl,offset msg1
    mov ah,09
    int 21h
    mov ah,01
    int 21h
    sub al,30h
    mov bx,ax

    mov dl,offset msg2
    mov ah,09
    int 21h
    mov ah,01
    int 21h
    sub al,30h
    mov si,ax

    mov dl,offset msg3
    mov ah,09
    int 21h
    mov ah,01
    int 21h
    mov matriz[bx][si],al

    
    ret
troca_numero endp

end main
