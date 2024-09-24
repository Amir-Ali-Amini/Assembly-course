section .data
  Yes dq "YES"
  No dq "NO"
section .bss
    inp resq 100
    inpNoSpace resq 100

section .text
    global _start

_start:
  ; mov rax, 0 
  ; mov rdi, 0
  ; mov rsi, inp
  ; mov rdx ,100
  ; syscall


  xor rbx ,rbx
  getItem:
    mov rax,0
    call getc
    cmp rax,10  
    je endInp
    cmp rax,32  
    je getItem

    mov [inpNoSpace+rbx*8], rax
    add rbx,1
    jmp getItem
 endInp:   
 dec rbx
    
;   mov rcx, 0 ; inp pointer
;   mov rbx, 0 ; inpNoSpace pointer and them count of it
; while1: ; removing the spaceses
;   cmp rcx,100
;   je outWhile1
;   push rax
;   mov al , [inp+rcx] 
;   cmp al , 32
;   je isSpace
;   mov al , [inp+rcx] 
;   cmp al , 0
;   je isSpace
;   mov al , [inp+rcx] 
;   cmp al , 10
;   je outWhile1
;   mov al,[inp+rcx]
;   mov [inpNoSpace+rbx],al
;   pop rax
;   inc rbx
; isSpace:
;   inc rcx
;   jmp while1
  
  

outWhile1:
  mov rsi , inpNoSpace 
  mov rdi , inpNoSpace
  push rdi
  push rcx
  push rax 
  mov rax , rbx 
  mov rcx , 8
  mul rcx
  mov rbx ,rax
  pop rax 
  pop rcx
  pop rdi
  add rdi , rbx
  ; dec rdi
  ;   mov rax, 1
  ; mov rdi, 1
  ; mov rdx ,rbx-1
  ; syscall
  
  
while2:
  mov rax , [rsi]
  mov rbx , [rdi]
  add rsi ,8
  sub rdi , 8
  cmp rax , rbx
  jne NO
  cmp rsi , rdi
  jae YES
  jmp while2
  

YES:
  mov rsi , Yes
  jmp outPut
NO:
  mov rax , rbx 
  mov rsi , No
outPut:
  call printString
  call newLine


Exit:
    mov     rax, sys_exit
    xor rdi, rdi
    syscall






%ifndef SYS_EQUAL
%define SYS_EQUAL

    sys_read     equ     0
    sys_write    equ     1
    sys_open     equ     2
    sys_close    equ     3
    
    sys_lseek    equ     8
    sys_create   equ     85
    sys_unlink   equ     87
      

    sys_mkdir       equ 83
    sys_makenewdir  equ 0q777


    sys_mmap     equ     9
    sys_mumap    equ     11
    sys_brk      equ     12
    
     
    sys_exit     equ     60
    
    stdin        equ     0
    stdout       equ     1
    stderr       equ     3

 
 PROT_NONE   equ   0x0
    PROT_READ     equ   0x1
    PROT_WRITE    equ   0x2
    MAP_PRIVATE   equ   0x2
    MAP_ANONYMOUS equ   0x20
    
    ;access mode
    O_DIRECTORY equ     0q0200000
    O_RDONLY    equ     0q000000
    O_WRONLY    equ     0q000001
    O_RDWR      equ     0q000002
    O_CREAT     equ     0q000100
    O_APPEND    equ     0q002000


    BEG_FILE_POS    equ     0
    CURR_POS        equ     1
    END_FILE_POS    equ     2
    
; create permission mode
    sys_IRUSR     equ     0q400      ; user read permission
    sys_IWUSR     equ     0q200      ; user write permission

    NL            equ   0xA
    Space         equ   0x20

%endif


  %ifndef NOWZARI_IN_OUT
%define NOWZARI_IN_OUT


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
; rdi : zero terminated string start 
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

%endif