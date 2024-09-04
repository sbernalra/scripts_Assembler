.data # Segmento para definir datos y variables
    mensaje_pedir_cantidad: .asciiz "Ingrese la cantidad de numeros a comparar (minimo 3, maximo 5): "
    mensaje_pedir_numero: .asciiz "Ingrese un numero: "
    mensaje_resultado: .asciiz "El numero mayor es: "
    numeros: .align 2 # Alinear a un l�mite de palabra (4 bytes)
    espacio_numeros: .space 20 # Espacio para 5 n�meros de 4 bytes)
    salto_linea: .asciiz "\n"
    mensaje_error: .asciiz "Debe ingresar un numero valido entre 3 y 5.\n"

.text # Instrucciones del programa
.globl main #  declara la etiqueda main como global

main:
    # Pedir al usuario la cantidad de n�meros a comparar.
    li $v0, 4 # indica que se va imprimir una cadena.
    la $a0, mensaje_pedir_cantidad # carga la cadena en $a0
    syscall # llamada al sistema para imprimir la cadena

    # Leer la cantidad de n�meros
    li $v0, 5 #Carga el valor 5 en $v0, indicando que se va a leer un entero.
    syscall # llamada al sistema para imprimir la cadena
    move $t0, $v0  # Guardar la cantidad en $t0 (Mueve el n�mero ingresado, que est� en $v0, al registro $t0.)

    # Verificar que la cantidad est� entre 3 y 5
    li $t1, 3 # Carga el valor 3 en $t1.
    blt $t0, $t1, mostrar_error # Si $t0 < 3, mostrar error y salir
    li $t1, 5 # Carga el valor 5 en $t1.
    bgt $t0, $t1, mostrar_error # Si $t0 > 5, mostrar error y salir 

    li $t2, 0          # Contador de n�meros ingresados
    li $t3, -214  # Inicializar el mayor a un valor muy bajo (m�nimo entero)

pedir_numero:
    # Imprimir mensaje para ingresar n�mero
    li $v0, 4 # indica que se va imprimir una cadena.
    la $a0, mensaje_pedir_numero # Carga la direcci�n de mensaje_pedir_numero en $a0.
    syscall # llamada al sistema para imprimir la cadena

    # Leer n�mero ingresado
    li $v0, 5 # Configura $v0 para leer un entero.
    syscall # llamada al sistema para imprimir la cadena
    
    # Comprobar si el input es v�lido
    bltz $v0, mostrar_error # Si el n�mero es negativo, mostrar error y salir

    # Guardar el n�mero ingresado en la memoria
    mul $t4, $t2, 4       # $t4 = contador * 4 (calcular el desplazamiento)
    la $t5, espacio_numeros # Cargar la direcci�n base de 'espacio_numeros'
    add $t5, $t5, $t4     # Calcular la direcci�n de almacenamiento correcta
    sw $v0, 0($t5)        # Guardar el n�mero en la lista de n�meros

    # Comparar con el mayor actual
    ble $v0, $t3, continuar # Si $v0 <= $t3, continuar
    move $t3, $v0           # Si $v0 > $t3, actualizar mayor

continuar:
    # Incrementar contador
    addi $t2, $t2, 1 # registra cu�ntos n�meros ha ingresado el usuario

    # Comprobar si se han ingresado suficientes n�meros
    bge $t2, $t0, mostrar_mayor # Si contador >= cantidad solicitada, mostrar mayor

    j pedir_numero #Salta de vuelta a la etiqueta pedir_numero para continuar pidiendo n�meros.

mostrar_mayor:
    # Imprimir mensaje de resultado
    li $v0, 4  # indica que se va imprimir una cadena.
    la $a0, mensaje_resultado
    syscall # llamada al sistema para imprimir la cadena

    # Imprimir el n�mero mayor
    li $v0, 1 # carga el valor de 1 en el registro  $vo
    move $a0, $t3 #Carga el n�mero mayor en $a0.
    syscall # llamada al sistema para imprimir la cadena

    # Terminar el programa
    li $v0, 10 # se utiliza para terminar la ejecucion del programa
    syscall # llamada al sistema para imprimir la cadena

mostrar_error:
    # Mostrar mensaje de error y terminar el programa
    li $v0, 4  # indica que se va imprimir una cadena.
    la $a0, mensaje_error
    syscall # llamada al sistema para imprimir la cadena
    li $v0, 10 # se utiliza para terminar la ejecucion del programa
    syscall # llamada al sistema para imprimir la cadena
