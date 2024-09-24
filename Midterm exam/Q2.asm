%ifndef SYS_EQUAL
%define SYS_EQUAL
    sys_read     equ     0
    sys_write    equ     1
    sys_open     equ     2
    sys_close    equ     3
    
    sys_lseek    equ     8
    sys_create   equ     85
    sys_unlink   equ     87
      

    sys_mmap     equ     9
    sys_mumap    equ     11
    sys_brk      equ     12
    
     
    sys_exit     equ     60
    
    stdin        equ     0
    stdout       equ     1
    stderr       equ     3

 
 
    PROT_READ     equ   0x1
    PROT_WRITE    equ   0x2
    MAP_PRIVATE   equ   0x2
    MAP_ANONYMOUS equ   0x20
    
    ;access mode
    O_RDONLY    equ     0q000000
    O_WRONLY    equ     0q000001
    O_RDWR      equ     0q000002
    O_CREAT     equ     0q000100
    O_APPEND    equ     0q002000

    
; create permission mode
    sys_IRUSR     equ     0q400      ; user read permission
    sys_IWUSR     equ     0q200      ; user write permission

    NL            equ   0xA
    Space         equ   0x20

%endif

;----------------------------------------------------
newLine:
   push   rax
   mov    rax, NL
   call   putc
   pop    rax
   ret
;---------------------------------------------------------
putc:	

   push   rcx
   push   rdx
   push   rsi
   push   rdi 
   push   r11 

   push   ax

   mov    rsi, rsp    ; points to our char
   mov    rdx, 1      ; how many characters to print
   mov    rax, sys_write
   mov    rdi, stdout 
   syscall

   pop    ax

   pop    r11
   pop    rdi
   pop    rsi
   pop    rdx
   pop    rcx
   ret
;---------------------------------------------------------
writeNum:
   push   rax
   push   rbx
   push   rcx
   push   rdx

   sub    rdx, rdx
   mov    rbx, 10 
   sub    rcx, rcx
   cmp    rax, 0
   jge    wAgain
   push   rax 
   mov    al, '-'
   call   putc
   pop    rax
   neg    rax  

wAgain:
   cmp    rax, 9	
   jle    cEnd
   div    rbx
   push   rdx
   inc    rcx
   sub    rdx, rdx
   jmp    wAgain

cEnd:
   add    al, 0x30
   call   putc
   dec    rcx
   jl     wEnd
   pop    rax
   jmp    cEnd
wEnd:
   pop    rdx
   pop    rcx
   pop    rbx
   pop    rax
   ret

;---------------------------------------------------------
getc:
   push   rcx
   push   rdx
   push   rsi
   push   rdi 
   push   r11 


   sub    rsp, 1

   mov    rsi, rsp
   mov    rdx, 1
   mov    rax, sys_read
   mov    rdi, stdin
   syscall

   mov    al, [rsi]
   add    rsp, 1

   pop    r11
   pop    rdi
   pop    rsi
   pop    rdx
   pop    rcx

   ret
;---------------------------------------------------------

readNum:
   push   rcx
   push   rbx
   push   rdx

   mov    bl,0
   mov    rdx, 0
rAgain:
   xor    rax, rax
   call   getc
   cmp    al, '-'
   jne    sAgain
   mov    bl,1  
   jmp    rAgain
sAgain:
   cmp    al, NL
   je     rEnd
   cmp    al, ' ' ;Space
   je     rEnd
   sub    rax, 0x30
   imul   rdx, 10
   add    rdx,  rax
   xor    rax, rax
   call   getc
   jmp    sAgain
rEnd:
   mov    rax, rdx 
   cmp    bl, 0
   je     sEnd
   neg    rax 
sEnd:  
   pop    rdx
   pop    rbx
   pop    rcx
   ret

;-------------------------------------------
printString:
    push    rax
    push    rcx
    push    rsi
    push    rdx
    push    rdi

    mov     rdi, rsi
    call    GetStrlen
    mov     rax, sys_write  
    mov     rdi, stdout
    syscall 
    
    pop     rdi
    pop     rdx
    pop     rsi
    pop     rcx
    pop     rax
    ret
;-------------------------------------------
; rsi : zero terminated string start 
GetStrlen:
    push    rbx
    push    rcx
    push    rax  

    xor     rcx, rcx
    not     rcx
    xor     rax, rax
    cld
    repne   scasb
    not     rcx
    lea     rdx, [rcx -1]  ; length in rdx

    pop     rax
    pop     rcx
    pop     rbx
    ret
;-------------------------------------------

section .data
    Msg	db	'Hello World',	0

    c1 dq 0
    c2 dq 0

section .bss
      first resq 100
    sec resq 100 

section .text
inp : 
   mov rbx , 0 
   xor rcx , rcx
inpWhile: 

   call getc 
   ;and rax , 127



   cmp rax , 10
   je endInp

   sub    rax, 0x30

   mov [r8 + rbx*8] , rax 
   inc rbx
   inc rcx 

   jmp inpWhile

endInp:


   ret 



global _start



_start:
   mov r8 , first
   call inp 
   mov [c1] , rcx 



   mov r8 , sec
   call inp 
   mov [c2] , rcx 

xor rcx , rcx
mov r8 , [c1]



   mov rax ,[c1]


mov r9 , [c2]
mov r11 , -1
push r11



   mov rax , r9 








while:


   mov r10 ,r8
   add r10 , r9
   cmp r10 ,0
   je done



   cmp r8 , 0 
   jbe fz
   cmp r9 , 0 
   jbe sz

   dec r9 
   dec r8

   mov rax , [sec + r9*8 ]
   mov rbx , [first + r8*8]


   add rax , rcx
   add rax , rbx


   xor rcx ,rcx

   cmp rax , 10
   jb BTenb

   sub rax , 10 
   inc rcx

BTenb:
   push rax


   jmp while


fz:

   dec r9 
   mov rax , [sec + r9*8 ]
   add rax , rcx

   xor rcx ,rcx

   cmp rax , 10
   jb BTenf
   sub rax , 10 
   inc rcx

BTenf:


   push rax

   jmp while



sz: 
   dec r8
   mov rax , [first + r8*8 ]
   add rax , rcx

   xor rcx ,rcx

   cmp rax , 10
   jb BTens
   sub rax , 10 
   mov rcx , 1

BTens:


   push rax

   jmp while

done:

   cmp rcx , 0
   je prnt

   mov rax , rcx 
   call writeNum


prnt:
   pop rax 
   cmp rax , -1 
   je Exit 
   call writeNum
   jmp prnt


Exit:
   call newLine
    mov     rax,    sys_exit
    xor     rdi,    rdi
    syscall