;_______________________________________________________________ 
; DEFINICION DEL SEGMENTO DE DATOS 

DATOS SEGMENT

TITULO   DB "TECNOLOGIA DE COMPUTADORES",13,10,"$"
PREG_NOM DB "ESCRIBE TU NOMBRE: $" 
NOMBRE   DB 80 DUP (0) 
TEXTO    DB "DON $" 
TEXTO2   DB " ES ALUMNO DE 2§ CURSO DE " 
         DB "INGENIERIA INFORMATICA",13,10,"$" 
DATOS ENDS ;Fin del segmento de datos

;_______________________________________________________________
; DEFINICION DEL SEGMENTO DE PILA 
PILA SEGMENT STACK "STACK" 
DB 40H DUP (0) 
PILA ENDS    ;Fin del segmento de pila
;_______________________________________________________________ 

; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT 
ASSUME CS:CODE,DS:DATOS,SS:PILA

;Comienzo del procedimiento principal (START)
START PROC FAR

;Inicializacion de los registros de segmento
MOV AX,DATOS 
MOV DS,AX 

;Borra la pantalla
MOV AH,6         ; Codigo de funcion
MOV AL,0         ; Borrar la pantalla completa
MOV BH,07H       ; Atributo de relleno
MOV CX,0         ; Esquina superior izquierda (CH:fila,CL columna)
MOV DX,24*256+79 ; Esquina inferior derecha (DH:fila,DL:columna)
INT 10H          ; Llamada a la interrupcion de la BIOS 10h

;Situa el cursor en una coordenada determinada
MOV AH,2         ; Codigo de funcion
MOV BH,0         ; Pagina de video
MOV DH,12        ; Fila
MOV DL,0         ; Columna
INT 10H          ; Llamada a la interrupcion de la BIOS 10h

;Escribe "CURSO ... 
MOV AH,09H           ; Codigo de la funcion
MOV DX,OFFSET TITULO ; Direccion del texto a imprimir
INT 21H              ; Llamada a la interrupcion del DOS 21h

;Muestra "ESCRIBE ...
MOV DX,OFFSET PREG_NOM  ;Texto a imprimir
INT 21H                 ;Llamada a la interrupcion del DOS 21h

;Almacena el texto tecleado
MOV AH,0AH           ;Codigo de la funcion
MOV DX,OFFSET NOMBRE ;Texto a imprimir
MOV NOMBRE[0],60     ;60 es el maximo numero de caracteres 
INT 21H              ;Llamada a la interrupcion del DOS 21h

;Presenta la respuesta del programa
MOV AH,9             ;Codigo de la funcion
MOV DX, OFFSET TEXTO ;Escribe DON.... 
INT 21H              ;Llamada a la interrupcion del DOS 21h

;Escribe el texto previamente introducido
MOV BX,0             ;Indice para recorrer el texto guardado
OTRO:                ;Etiqueta para el bucle
MOV DL,NOMBRE[BX+2]  ;Carga en DL el caracter a imprimir
MOV AH,2             ;Codigo de la funcion
INT 21H              ;Escribe un caracter del nombre 
INC BX               ;Pasa al siguiente carecter
CMP BL, NOMBRE[1]    ;Compara con el numero de caracteres total 
JNE OTRO             ;Salto condicional

; Escribe "ES ALUMNO ...
MOV DX, OFFSET TEXTO2 ;Texto a imprimir
MOV AH,9              ;Codigo de la funcion
INT 21H               ;Llamada a la interrupcion del DOS 21h

;Fin del programa y vuelta al DOS
MOV AX,4C00H 
INT 21H 

START ENDP ;Fin del procedimiento START

CODE ENDS  ;Fin del segmento de codigo

END START  ;Fin del programa, indicando donde comienza la ejecucion
