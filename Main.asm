.MODEL SMALL

pula_linha MACRO proc
mov ah,02h
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

mov ah,02h
mov ch,9 ;contador para linha

inicio:
mov cl,9 ;contador para coluna
xor si,si ;será a linha

mover:
mov dl, [bx][si]
int 21h
inc si ;exibindo a linha primeira linha da matriz
dec cl ;vai pulando de colunas 9 vezes
jnz mover

pula_linha

add bx, 9 ;contador de coluna
dec ch ;decrementa linha
jnz inicio

mov ah,4ch
int 21h

main endp

end main
