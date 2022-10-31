; Autor reseni: Josef Kuchar xkucha28

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64
; r0, r4, r5, r7, r15, r29

; DATA SEGMENT
                .data
login:          .asciiz "xkucha28"  ; sem doplnte vas login
cipher:         .space  17  ; misto pro zapis sifrovaneho loginu

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize "funkce" print_string)
key:            .asciiz "ku"

; CODE SEGMENT
                .text

                ; ZDE NAHRADTE KOD VASIM RESENIM
main:
                loop:
                    lb r29, login(r5)  ; Load char from login
                    daddi r7, r0, 96   ; 'a' - 1
                    slt r15, r7, r29   ; Check if char is lower than 'a'
                    beqz r15, loop_end ; If yes, break
                    andi r15, r5, 1    ; Check if index is odd
                    beqz r15, odd      ; If yes, jump to odd

                    ; Even index
                    even:
                        daddi r7, r0, 1         ; 1
                        lb r7, key(r7)          ; Load second key char
                        daddi r29, r29, 96      ; Add 'a' - 1
                        dsub r29, r29, r7       ; Subtract key char from login
                        daddi r7, r0, 97        ; 'a'
                        slt r15, r29, r7        ; r15 = [0] < [1] ? 1 : 0
                        beqz r15, even_odd_end  ; Char is bigger than 'a' so skip addition
                        daddi r29, r29, 26      ; Roll over

                    ; Odd index
                    b even_odd_end
                    odd:
                        lb r7, key(r0)           ; Load first key char
                        dadd r29, r29, r7        ; Add key char to char from login
                        daddi r29, r29, -96      ; Subtract 'a' - 1
                        daddi r7, r0, 122        ; 'z'
                        slt r15, r7, r29         ; r15 = [0] < [1] ? 1 : 0
                        beqz r15, even_odd_end   ; Char is smaller or equal to 'z' so skip subtraction
                        daddi r29, r29, -26      ; Roll over

                    ; Print char
                    even_odd_end:
                    sb r29, cipher(r5)  ; Store char to cipher
                    daddi r5, r5, 1     ; Increment index
                    b loop              ; Jump back to loop
                loop_end:

                daddi   r4, r0, cipher
                jal     print_string

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
