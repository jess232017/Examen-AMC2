Comienzo
Inicialice el segmento de datos a través del registro AX en el registro DS.
Inicializar el SI a 5000h
Inicializar elementos totales de la matriz como un recuento en CX (por ejemplo, 0005h)
Conserve el recuento anterior en c variable temporal.
Mostrar el mensaje como "Ingresar elementos de una matriz"
Leer el primer dígito en el registro AL a través del teclado (por ejemplo, AL = 31h)
Procedimiento de entrada de llamada para convertir un número de ASCII hexadecimal a un número hexadecimal normal AL = 01h
Mover el contenido de AL a BL
Gire el contenido de BL en 4 en dirección a la izquierda.
Leer el segundo dígito en el registro AL a través del teclado (por ejemplo, AL = 32h)
Procedimiento de entrada de llamada para hacer un número de ASCII hexadecimal a un número hexadecimal normal AL = 02h
Agregar contenido BL y AL (BLß BL + AL)
Almacene el BL (número aceptado actual) en la ubicación señalada por SI
Incrementar SI en 1 para apuntar a la siguiente ubicación para el siguiente número
Repita el paso no. 7 a 15 hasta que el recuento de CX llegue a 0.
Inicialice SI nuevamente a 5000h y CX también con el número total de elementos.
Inicialice AL con el primer elemento apuntado por SI para la siguiente comparación
Comparar el número señalado por SI de una matriz con registro AL
Si se genera acarreo (es decir, si número en AL> número señalado por SI) entonces vaya al paso no. 22 de lo contrario, vaya al paso no. 21
Haz un salto incondicional al paso no. 23
Mover el número señalado por SI a AL
SI incrementado en 1
Disminuir CX en 1
Compare CX con 0000h (es decir, repita los pasos n. ° 19 a 25 hasta que no se cubran todos los números de la matriz para la comparación)
Si la bandera de cero no está configurada, salte al paso n. ° 19
Finalmente, el número mínimo estará disponible en el registro AL.
Muestra el contenido del registro AL.
Parada.