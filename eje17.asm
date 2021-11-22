Data Segment    ;Indica el inicio del segmento de datos

    mensaje1    db 0dh,0ah,"Longitud del arreglo: $"
    mensaje2    db 0dh,0ah,"Ingrese un numero: $"
    saltoLinea  db 0dh,0ah," $"
    mensaje3    db 0dh,0ah,"El minimo es: $"
    longitud    db ?
    resultado   db ?

Data ends

Code Segment    ;Inicia el segmento de codigo
    assume CS:Code,DS:Data

    Inicio:

        ;Codigo para imprimir el mensaje1
        mov ax,Data
        mov DS,ax

        mov dx,offset mensaje1    ; Direccion del texto a imprimir
        mov ah,09h  ;Escribir cadena a STDOUT
        int 21h     ;Activar Interrupcion 0x21
        ;Fin
        
        ;Codigo para leer un numero de dos digitos
        call LeerEntrada    ;llamar al procedimiento

        mov longitud,bl     ;Guardar los digitos como la longitud del arreglo
        mov cl,bl
        mov ch,00h
        mov di,1000h
 
        ;Bucle para realizar la lectura del arreglo
        LeerArreglo: 
            mov dx,offset mensaje2    ; Direccion del texto a imprimir
            mov ah,09h  ;Escribir cadena a STDOUT
            int 21h     ;Activar Interrupcion 0x21
            call LeerEntrada

            mov [di],bl
            inc di     ;incrementa el valor del indice del destino
        loop LeerArreglo; al llegar aqui saltara a la etiqueta LeerArreglo hasta que (CX == 0)

        mov di,1000h
        mov cl,longitud
        mov ch,00h

        mov dx,offset saltoLinea   ; Direccion del texto a imprimir
        mov ah,09h  ;Escribir cadena a STDOUT
        int 21h    ;Activar Interrupcion 0x21

        mov al,[di] 
        mov resultado,al

        ;Codigo para buscar el numero menor dentro del arreglo
        BuscarMenor: 
            mov bl,resultado   ;copiamos el contenido almacenado en resultado en bl
            mov al,[di]   ;copiamos el contenido almacenado en arreglo[posicion] en al
            cmp bl,al   ;número actual > número anterior entonces SI C=1

            jc a    ;Si(C==1) Ir a
                mov resultado,al
                jmp b   ;Siempre saltar a "b"

            a: 
                mov resultado,bl
        
            b: 
                inc di     ;incrementa el valor del indice del destino
        
        loop BuscarMenor   ;al llegar aqui saltara a la etiqueta BuscarMenor

        mov dx,offset mensaje3    ; Direccion del texto a imprimir
        mov ah,09h  ;Escribir cadena a STDOUT
        int 21h    ;Activar Interrupcion 0x21

        mov bl,resultado
        call MostrarNumero

        mov ah,4ch
        int 21h    ;Activar Interrupcion 0x21

        ;Declaracion del procedimiento LeerEntrada de dos digitos
        LeerEntrada proc 
            mov ah,01h    ;Leer primer digito from STDIN
            int 21h     ;Activar Interrupcion 0x21
            call AsciiAHex     ;llamar al procedimiento
            rol al,4    ;Realiza una rotación hacia la izquierda.
            mov bl,al
            
            mov ah,01h  ;Leer segundo digito from STDIN
            int 21h    ;Activar Interrupcion 0x21
            call AsciiAHex     ;llamar al procedimiento
            add bl,al     ;sumar
            ret    ;retornar
        endp

        ;Declaracion del procedimiento MostrarNumero en pantalla
        MostrarNumero proc
            mov dl,bl
            and dl,0f0h
            ror dl,4
            call Hex_A_Ascii    ;llamar al procedimiento
            mov ah,02h    ;Escribir caracter en STDIN
            int 21h    ;Activar Interrupcion 0x21
            mov dl,bl
            and dl,0fh
            call Hex_A_Ascii    ;llamar al procedimiento
            mov ah,02h    ;Escribir caracter en STDIN
            int 21h    ;Activar Interrupcion 0x21
        endp
        
        ;Declaracion del procedimiento Convertir ASCII a Hex
        AsciiAHex proc
            cmp al,41h    ;Comparar al con Ascci

            jc sk    ;Si(C==1) Ir a
                sub al,07h    ;Restar
            sk: 
                sub al,30h    ;Restar 
                ret    ;retornar
        endp

        ;Declaracion del procedimiento Convertir Hex a ASCII
        Hex_A_Ascii proc
            cmp dl,0ah    ;Comparar dl con Ascci

            jc sk2    ;Si(C==1)
                add dl,07h     ;Sumar
            sk2: 
                add dl,30h     ;Sumar     
                ret    ;retornar
        endp

    Code ends
end Inicio