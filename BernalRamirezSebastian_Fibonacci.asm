.data
    mensaje_pedir_cantidad: .asciiz "Ingrese la cantidad de numeros de la serie Fibonacci a generar: "
    mensaje_resultado: .asciiz "La serie Fibonacci es:\n"
    mensaje_suma: .asciiz "\nLa suma de la serie es: "
    fibonacci: .align 2  # Alinear a una palabra (4 bytes)
    espacio_numeros: .space 100  # Espacio para almacenar hasta 25 números de la serie (4 bytes por número)
    salto_linea: .asciiz "\n"
    mensaje_error: .asciiz "Cantidad invalida. Debe ingresar un numero mayor a 0.\n"

.text
.globl main

main:
    # Pedir al usuario la cantidad de números de Fibonacci
    li $v0, 4 # indica que se va imprimir una cadena.
    la $a0, mensaje_pedir_cantidad
    syscall

    # Leer la cantidad de números
    li $v0, 5 # Configura $v0 para leer un entero.
    syscall
    move $t0, $v0  # Guardar la cantidad en $t0

    # Verificar que la cantidad sea mayor a 0
    blez $t0, mostrar_error # Si $t0 <= 0, mostrar error y salir rifica si la cantidad ingresada es menor o igual a cero.

    # Inicializar los dos primeros números de la serie
    li $t1, 0  # Primer número de Fibonacci (f0)
    li $t2, 1  # Segundo número de Fibonacci (f1)

    # Guardar los dos primeros números en la memoria
    la $t3, fibonacci #  Carga la dirección de la etiqueta fibonacci en el registro $t3
    sw $t1, 0($t3) #Esta instrucción almacena el valor en el registro $t1 en la memoria.
    addi $t3, $t3, 4 # uma 4 al valor de $t3, lo que incrementa el puntero de memoria en 4 bytes.
    sw $t2, 0($t3) # Almacena el valor del registro $t2 en la dirección de memoria apuntada por $t3.

    # Inicializar contador de la serie y suma
    li $t4, 2  # Contador de términos (ya tenemos los primeros dos)
    add $t5, $t1, $t2  # Suma inicial (f0 + f1)
    li $t6, 2  # Índice para la siguiente posición de almacenamiento

generar_fibonacci:
    # Calcular el siguiente número en la serie
    add $t7, $t1, $t2  # f(n) = f(n-1) + f(n-2)

    # Guardar el siguiente número en la memoria
    la $t3, fibonacci
    mul $t8, $t6, 4  # Desplazamiento en bytes (4 * índice) Multiplica el valor en $t6
    add $t3, $t3, $t8 # Suma el contenido de dos registros y almacena el resultado en un tercer registro
    sw $t7, 0($t3) # lmacena el valor en el registro $t7 en la dirección de memoria apuntada por $t3
    addi $t6, $t6, 1  # Incrementar índice

    # Actualizar los valores de f(n-1) y f(n-2)
    move $t1, $t2 # Copia el valor del registro $t2 a $t1.
    move $t2, $t7 # Copia el valor del registro $t7 a $t2.

    # Actualizar suma total
    add $t5, $t5, $t7 # suma el valor en $t7 al valor en $t5 y almacena el resultado en $t5.

    # Incrementar contador
    addi $t4, $t4, 1 # Suma 1 al valor en $t4 y almacena el resultado nuevamente en $t4.

    # Comprobar si hemos generado suficientes números
    bge $t4, $t0, mostrar_resultado #  Compara los valores en los registros $t4 y $t0.

    j generar_fibonacci # Si no se ha generado la cantidad deseada, vuelve al ciclo para continuar generando más números.

mostrar_resultado:
    # Imprimir mensaje de resultado
    li $v0, 4
    la $a0, mensaje_resultado
    syscall

    # Imprimir la serie Fibonacci
    la $t3, fibonacci
    li $t4, 0  # Reiniciar contador
imprimir_fibonacci:
    lw $a0, 0($t3) # Carga el valor en la dirección de memoria apuntada por $t3 (sin desplazamiento adicional) en el registro $a0.
    li $v0, 1 # Carga el valor 1 en el registro $v0.
    syscall

    # Imprimir espacio o salto de línea según sea necesario
    li $v0, 4, #  Configura el registro $v0 con el valor 4.
    la $a0, salto_linea # Carga la dirección de la etiqueta salto_linea en el registro $a0.
    syscall

    addi $t3, $t3, 4 # 4 Suma 4 al valor en $t3 y almacena el resultado en $t3.
    addi $t4, $t4, 1 # Suma 1 al valor en $t4 y almacena el resultado en $t4.
    blt $t4, $t0, imprimir_fibonacci

    # Imprimir mensaje de suma
    li $v0, 4 # indica que se va imprimir una cadena
    la $a0, mensaje_suma
    syscall

    # Imprimir la suma total
    li $v0, 1
    move $a0, $t5 # Copia el valor del registro $t5 al registro $a0.
    syscall

    # Terminar el programa
    li $v0, 10 # se utiliza para terminar la ejecucion del programa
    syscall

mostrar_error:
    # Mostrar mensaje de error y terminar el programa
    li $v0, 4 # indica que se va imprimir una cadena
    la $a0, mensaje_error
    syscall
    li $v0, 10 # se utiliza para terminar la ejecucion del programa
    syscall
