;*************** Macro ************************************
; Definicion Macro para imprimir mensaje
imprimir macro m                ; definicion macro
    mov dx,offset m             ; Mover contenido a imprimir a DX
    mov ah,09h                  ; Funcion 09 para escribir cadena a STDOUT
    int 21h                     ; Activar Interrupcion 0x21
endm                            ; Finalizar macro

;*************** Segmento Data ****************************
.MODEL SMALL       ;Indiaca el modelo de memoria
.STACK         ;Indica el modelo de pila

.DATA    ;Indica el inicio del segmento de datos

    mensaje1    db 0dh,0ah,"Longitud del arreglo: $"
    mensaje2    db 0dh,0ah,"Ingrese un numero: $"
    mensaje3    db 0dh,0ah,"La suma de los numeros pares es de: $"
    saltoLinea  db 0dh,0ah," $"
    longitud    db ?
    resultado   db ?

    num1 db 0
    num2 db 0
    ten db 10
    t2 db 0


;************** Inicia el segmento codigo ******************
.CODE         ; Inicia el segmento de codigo

    MAIN:

        MOV AX, @DATA           ; ACUMULAR DIRECCION DE DATA
        MOV DS, AX              ; MOVER LA DIRECCION A DS

        imprimir mensaje1   ;Llama al macro imprimir, para mostrar mensaje
        call LeerNum    ;Llamar al procedimiento leer numero

        mov longitud,AL     ;Guardar los digitos como la longitud del arreglo
        mov cl,AL     ;Asignar la longitud del arreglo al contador cx
        mov ch,00h
        mov di,1000h
 
        ;Bucle para realizar la lectura del arreglo
        LeerArreglo: 
            imprimir mensaje2   ;Llama al macro imprimir, para mostrar mensaje

            call LeerNum    ;llamar al procedimiento
            mov [di],AL ;Almacenar numero ingresado en el arreglo
            
            inc di     ;incrementa el valor del indice del destino

        loop LeerArreglo; al llegar aqui saltara a la etiqueta LeerArreglo hasta que (CX == 0)

        mov di,1000h
        mov cl,longitud     ;copiamos la longitud del arreglo en cx
        mov ch,00h

        imprimir saltoLinea   ;Llama al macro imprimir, para mostrar mensaje

        mov al,[di] 
        mov resultado, 0

        ;Codigo para buscar el numero menor dentro del arreglo
        SumPar: 
            mov al,[di]   ;copiamos el contenido almacenado en arreglo[posicion] en al
            test al, 1   ;revisar si el numero actual del arreglo es impar

            JNZ  a    ;Si(Z==0) Ir a
                add resultado, al ; sumamos a la variable resultado el valor contenido en al
                jmp a   ;Siempre saltar a "a"
            a: 
                inc di     ;incrementa el valor del indice del destino
        
        loop SumPar   ;al llegar aqui saltara a la etiqueta SumPar

        imprimir mensaje3   ;Llama al macro imprimir, para mostrar mensaje

        mov al,resultado
        call EscribirNum

        mov ah,4ch  ;Salir del programa
        int 21h    ;Activar Interrupcion 0x21

        LeerNum proc
            ;Leer el segundo digito
            mov ah,01h  ;Leer caracter desde STDIN
            int 21h    ;Activar Interrupcion 0x21
            sub al,48
            mov num1,al

            ;Leer el segundo digito
            mov ah,01h  ;Leer caracter desde STDIN
            int 21h    ;Activar Interrupcion 0x21
            sub al,48
            mov num2,al     

            mov al,num1
            mul ten
            add al,num2     ;El numero se almacena en AL
            ret
        endp

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
    end main