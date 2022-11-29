.MODEL SMALL

pula_linha MACRO proc
mov ah,02h
mov dl,10
int 21h    
endm

linha_vert macro proc
mov ah,02h
mov dl,' '
int 21h
mov dl,'|'
int 21h
mov dl,' '
int 21h
endm

push_reg macro proc
push ax
push bx
push cx
push dx
endm

pop_reg macro proc
pop ax
pop bx
pop cx
pop dx
endm

barra macro proc
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

.stack 100h
.code

main proc

    mov ax,@data
    mov ds,ax
    lea bx,MATRIZ ;o vetor armazenado em bx

    call imprime_matriz
    call troca_numero

    mov ah,4ch
    int 21h

main endp

imprime_matriz proc

    mov ah,02h
    mov ch,9 ;contador para linha

    inicio:
    barra
    mov cl,9 ;contador para coluna
    xor si,si ;será a linha

    mover:
    mov dl, [bx][si]
    int 21h
    linha_vert
    inc si ;exibindo a linha primeira linha da matriz
    dec cl ;vai pulando de colunas 9 vezes
    jnz mover

    pula_linha

    add bx, 9 ;contador de coluna
    dec ch ;decrementa linha
    jnz inicio

    ret
imprime_matriz endp

troca_numero proc
    
    mov bx,bx ;coluna 8
    xor si,si ;linha 0

    mov MATRIZ[bx][si],'?'

    ret
troca_numero endp

end main
