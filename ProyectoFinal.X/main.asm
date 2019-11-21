; Organizaci?n de Computadoras 2019
; Proyecto Final
; PIC16F887 Configuration Bit Settings
; Assembly source line config statements

#include "p16f887.inc"

; CONFIG1
; __config 0xE0F2
 __CONFIG _CONFIG1, _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFEFF
 __CONFIG _CONFIG2, _BOR4V_BOR21V & _WRT_OFF

cblock 0x20
    pot_l
endc     
    org 0x0000
    goto main
    
main
    banksel TRISD	;Selecciono el banco de memoria de TRISD
    clrf TRISD		;Hago un clear del registro TRISD. TRISD = 0x00
    
    banksel PORTD       ;Selecciono el banco de memoria de PORTD
    clrf PORTD          ;Hago un clear del registro PORTD (todos los leds apagados)
    
    call escribirEEPROM
    call leerEEPROM
        
_main_loop
    
    
    goto _main_loop


leerEEPROM
    BANKSEL EEADR ;
    MOVLW 0x00 ;
    MOVWF EEADR ;Data Memory
    ;Address to read
    BANKSEL EECON1 ;
    BCF EECON1, EEPGD ;Point to DATA memory
    BSF EECON1, RD ;EE Read
    BANKSEL EEDAT ;
    MOVF EEDAT, W ;W = EEDAT
    BANKSEL PORTD
    
    movwf PORTD
    return
    
escribirEEPROM
    BANKSEL EEADR	;Cambio al banco de memoria de EEADR
    movlw 0x00		;Seteo la direccion en la que se guardan los datos    
    movwf EEADR		;
    
    movlw b'11001100'	;Seteo el valor a guardar    
    movwf EEDAT		;Data Memory Value to write
    
    BANKSEL EECON1	;
    BCF EECON1, EEPGD	;
    BSF EECON1, WREN	;Habilito la escritura
    BCF INTCON, GIE	;Disable INTs.
    BTFSC INTCON, GIE	;SEE AN576
    GOTO $-2
    MOVLW 0x55 ;
    MOVWF EECON2 ;Write 55h
    MOVLW 0xAA ;
    MOVWF EECON2 ;Write AAh
    BSF EECON1, WR ;Set WR bit to begin write
    BSF INTCON, GIE ;Enable INTs.
    
    BCF EECON1, WREN ;Disable writes
    return
    
    
end









