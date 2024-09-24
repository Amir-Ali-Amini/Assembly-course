section .data
    Notfound dq "NaN"
section .bss
    array resq 1000000
    listSize resq 1
section .text
    global _start

  

;---------------------------------------
_start:
  call readNum  ; number of lists
  mov rcx , rax 
  xor rbx , rbx
  mov [listSize], rcx 
  mov r11,0
  cmp rcx , 0 
  je printNewLine
  
  
inputLists:
  xor rcx , rcx
whileInputLists:
    cmp rcx  , [listSize]
    jae printNewLine
    call readNum
    mov rbx , rax
    inc rcx
    cmp rbx , 0
    jle nextListEmpty
    
    mov rax , 1
    whileInputList:
      inc r11
      cmp rbx , 0
      jle nextList
      dec rbx
      push rax 
      call readNum 
      mov r8, rax 
      pop rax 
      imul r8
  
      jmp whileInputList
      
    nextList:
      call writeNum
      call newLine
    nextListEmpty:
      jmp whileInputLists

      
    jmp Exit
  
  
printNewLine:
  cmp r11 , 0
  ja Exit
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
getqw:
   push   rcx
   push   rdx
   push   rsi
   push   rdi 
   push   r11 

   sub    rsp, 8
   mov    rsi, rsp
   mov    rdx, 8
   mov    rax, sys_read
   mov    rdi, stdin
   syscall
   mov    rax, [rsi]
   add    rsp, 8

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

getArrayNumber:
  push    rax
  push    rbx
  push    rcx
  push    rsi
  push    rdx
  push    rdi
  mov rbx , array
  
  getItemNumber:
      call readNum
      mov [rbx], rax
      add rbx,8
      cmp rcx,10
      jne getItemNumber
  
  pop     rdi
  pop     rdx
  pop     rsi
  pop     rcx
  pop     rbx
  pop     rax
  
  ret
  
  ;-------------------------------------------

getArrayChar:
  push    rax
  push    rbx
  push    rcx
  push    rsi
  push    rdx
  push    rdi
  mov rbx , array
  
  getItemChar:
      call getc
      mov [rbx], al
      add rbx,8

      cmp rax,10
      je endGetArrayChar
      
      cmp rax , 0
      ja getItemChar
  
endGetArrayChar:
      
  pop     rdi
  pop     rdx
  pop     rsi
  pop     rcx
  pop     rbx
  pop     rax
  
  ret
    ;-------------------------------------------

getArrayQuadWord:
  pop r8
  push    rax
  push    rbx
  push    rcx
  push    rsi
  push    rdx
  push    rdi
  mov rbx , r8
  
  getItemQW:
      call getqw
      mov [rbx], rax
      add rbx,8
      cmp rax,10
      jne getItemQW
  
  pop     rdi
  pop     rdx
  pop     rsi
  pop     rcx
  pop     rbx
  pop     rax
  
  ret
  ;----------------------------------------
printArray:
  push    rax
  push    rbx
  push    rcx
  push    rsi
  push    rdx
  push    rdi
  mov rbx , array
  
  printItem:
      mov rax, [rbx]
      ; call writeNum
      add rbx,8
      dec rcx
      cmp rcx,0
      ja printItem
  
  pop     rdi
  pop     rdx
  pop     rsi
  pop     rcx
  pop     rbx
  pop     rax
  
  ret


%endif