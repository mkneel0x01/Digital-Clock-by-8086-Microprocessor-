explain this code 

.model small
.stack 100h

.data
    hrs     db 0
    mins    db 0
    secs    db 0
    newline db 13,10,'$'
    label   db 'Digital Clock: $'

.code
main:
    mov ax, @data
    mov ds, ax

start:
    call print_time
    call delay
    call update_time
    jmp start

;-----------------------------------
; Print Time in HH:MM:SS Format
;-----------------------------------
print_time:
    mov ah, 09h
    lea dx, newline
    int 21h
    lea dx, label
    int 21h

    ; Print Hours
    mov al, hrs
    call print_two_digits

    mov dl, ':'
    mov ah, 02h
    int 21h

    ; Print Minutes
    mov al, mins
    call print_two_digits

    mov dl, ':'
    mov ah, 02h
    int 21h

    ; Print Seconds
    mov al, secs
    call print_two_digits

    ret

;-----------------------------------
; Convert and Print 2 Digits from AL
;-----------------------------------
print_two_digits:
    aam             ; Split into tens and units
    add ax, 3030h   ; Convert to ASCII
    mov dl, ah
    mov ah, 02h
    int 21h
    mov dl, al
    int 21h
    ret

;-----------------------------------
; Update Time Logic
;-----------------------------------
update_time:
    inc secs
    cmp secs, 60
    jl ret_update
    mov secs, 0
    inc mins
    cmp mins, 60
    jl ret_update
    mov mins, 0
    inc hrs
    cmp hrs, 24
    jl ret_update
    mov hrs, 0
ret_update:
    ret

;-----------------------------------
; Delay Loop (Approximate)
;-----------------------------------
delay:
    mov cx, 0FFFFh
delay_loop:
    nop
    loop delay_loop
    ret

end main