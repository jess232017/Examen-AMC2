.data          ; start of data segment

    mensaje1    db 0dh,0ah,"Longitud del arreglo: $"
    mensaje2    db 0dh,0ah,"Ingrese un numero: $"
    mensaje3    db 0dh,0ah,"La suma de los numeros impares es de: $"
    saltoLinea  db 0dh,0ah," $"
    longitud    db ?
    resultado   db ?
    
    num1 db 0
    num2 db 0
    ten db 10
    t2 db 0

.code          ; Inicia el segmento de codigo

    main:

        mov ax,Data
        mov DS,ax

        ;Codigo para imprimir el mensaje1
        mov dx,offset mensaje1    ;Direccion del texto a imprimir
        mov ah,09h  ;Escribir cadena a STDOUT
        int 21h     ;Activar Interrupcion 0x21
        ;Fin
        
        ;Codigo para leer un numero de dos digitos
        call LeerNum    ;llamar al procedimiento

        mov longitud,AL     ;Guardar los digitos como la longitud del arreglo
        mov cl,AL     ;asignar la longitud del arreglo al contador cx
        mov ch,00h
        mov di,1000h
 
        ;Bucle para realizar la lectura del arreglo
        LeerArreglo: 
            mov dx,offset mensaje2    ; Direccion del texto a imprimir
            mov ah,09h  ;Escribir cadena a STDOUT
            int 21h     ;Activar Interrupcion 0x21

            call LeerNum    ;llamar al procedimiento
            mov [di],AL ;Almacenar numero ingresado en el arreglo
            
            inc di     ;incrementa el valor del indice del destino

        loop LeerArreglo; al llegar aqui saltara a la etiqueta LeerArreglo hasta que (CX == 0)

        mov di,1000h
        mov cl,longitud     ;copiamos la longitud del arreglo en cx
        mov ch,00h

        mov dx,offset saltoLinea   ; Direccion del texto a imprimir
        mov ah,09h  ;Escribir cadena a STDOUT
        int 21h    ;Activar Interrupcion 0x21

        mov al,[di] 
        mov resultado, 0

        ;Codigo para buscar el numero menor dentro del arreglo
        SumImpar: 
            mov al,[di]   ;copiamos el contenido almacenado en arreglo[posicion] en al
            test al, 1   ;revisar si el numero actual del arreglo es impar

            JZ  a    ;Si(Z==1) Ir a
                add resultado, al ; sumamos a la variable resultado el valor contenido en al
                jmp a   ;Siempre saltar a "a"
            a: 
                inc di     ;incrementa el valor del indice del destino
        
        loop SumImpar   ;al llegar aqui saltara a la etiqueta SumImpar

        mov dx,offset mensaje3    ; Direccion del texto a imprimir
        mov ah,09h  ;Escribir cadena a STDOUT
        int 21h    ;Activar Interrupcion 0x21

        mov al,resultado
        call EscribirNum

        mov ah,4ch  ;Salir del programa
        int 21h    ;Activar Interrupcion 0x21

        EscribirNum proc
            ;El numero a imprimir debe estar almacenado en AL antes
            mov ah,00
            div ten

            mov dl,ah
            mov t2,dl

            mov dl,al
            add dl,48
            mov ah,02h  ;Escribir caracter a STDOUT
            int 21h    ;Activar Interrupcion 0x21

            mov dl,t2
            add dl,48
            mov ah,02h  ;Escribir caracter a STDOUT
            int 21h    ;Activar Interrupcion 0x21
            ret
        endp

        LeerNum proc
            ;Leer primer digito
            mov ah,01h
            int 21h    ;Activar Interrupcion 0x21
            sub al,48
            mov num1,al

            ;Leer el segundo digito
            mov ah,01h
            int 21h    ;Activar Interrupcion 0x21
            sub al,48
            mov num2,al     

            mov al,num1
            mul ten
            add al,num2     ;El numero se almacena en AL
            ret
        endp
    end main