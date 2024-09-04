.data # Segmento utilizado para definir datos y variables
    mensaje_pedir_cantidad: .asciiz "Ingrese la cantidad de numeros a comparar (minimo 3, maximo 5): "
    mensaje_pedir_numero: .asciiz "Ingrese un numero: "
    mensaje_resultado: .asciiz "El numero menor es: "
    numeros: .align 2 # espacio que reserva 20 bytes
    espacio_numeros: .space 20 # Espacio para 5 números de 4 bytes (5*4 = 20 bytes)
    salto_linea: .asciiz "\n"
    mensaje_error: .asciiz "Cantidad invalida o input incorrecto. Debe ingresar un numero valido entre 3 y 5.\n"
.text # Instrucciones del programa
.globl main

main:
    # Pedir al usuario la cantidad de números a comparar
    li $v0, 4 # indica que se va imprimir una cadena.
    la $a0, mensaje_pedir_cantidad
    syscall # llamada al sistema para imprimir la cadena

    # Leer la cantidad de números
    li $v0, 5 #Carga el valor 5 en $v0, indicando que se va a leer un entero.
    syscall
    move $t0, $v0  # Guardar la cantidad en $t0

    # Verificar que la cantidad esté entre 3 y 5
    li $t1, 3 # Carga el valor 3 en $t1.
    blt $t0, $t1, mostrar_error # Si $t0 < 3, mostrar error y salir
    li $t1, 5 # Carga el valor 5 en $t1.
    bgt $t0, $t1, mostrar_error # Si $t0 > 5, mostrar error y salir

    li $t2, 0          # Contador de números ingresados
    li $t3, 2147483647  # Inicializar el menor a un valor muy alto (máximo entero positivo)

pedir_numero:
    # Imprimir mensaje para ingresar número
    li $v0, 4 # indica que se va imprimir una cadena.
    la $a0, mensaje_pedir_numero
    syscall

    # Leer número ingresado
    li $v0, 5 # Configura $v0 para leer un entero.
    syscall

    # Comprobar si el input es válido
    bltz $v0, mostrar_error # Si el número es negativo, mostrar error y salir

    # Guardar el número ingresado en la memoria
    mul $t4, $t2, 4       # $t4 = contador * 4 (calcular el desplazamiento)
    la $t5, espacio_numeros # Cargar la dirección base de 'espacio_numeros'
    add $t5, $t5, $t4     # Calcular la dirección de almacenamiento correcta
    sw $v0, 0($t5)        # Guardar el número en la lista de números

    # Comparar con el menor actual
    bge $v0, $t3, continuar # Si $v0 >= $t3, continuar
    move $t3, $v0           # Si $v0 < $t3, actualizar menor

continuar:
    # Incrementar contador
    addi $t2, $t2, 1 # suma uno al registro

    # Comprobar si se han ingresado suficientes números
    bge $t2, $t0, mostrar_menor # Si contador >= cantidad solicitada, mostrar menor
    j pedir_numero # salto incondicional desplaza inmediatamente a la etiqueta pedir_numero
mostrar_menor:
    # Imprimir mensaje de resultado
    li $v0, 4 # indica que se va imprimir una cadena.
    la $a0, mensaje_resultado # cargar una etiqueta en el registro
    syscall

    # Imprimir el número menor
    li $v0, 1 # carga el valor de 1 en el registro  $vo
    move $a0, $t3 # Copia el valor del registro en $t3
    syscall
    # Terminar el programa
    li $v0, 10 # se utiliza para terminar la ejecucion del programa
    syscall
mostrar_error:
    # Mostrar mensaje de error y terminar el programa
    li $v0, 4 # indica que se va imprimir una cadena.
    la $a0, mensaje_error
    syscall
    li $v0, 10  # se utiliza para terminar la ejecucion del program
    syscall
