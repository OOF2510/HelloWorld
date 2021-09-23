.data

helloworld:
    .ascii        "Hello, World!\n"
helloworld_len = . - helloworld

.text

.globl _start
_start:
    mov     x0, #1
    ldr     x1, =helloworld
    ldr     x2, =helloworld_len
    mov     w8, #64
    svc     #0

    mov     x0, #0
    mov     w8, #93
    svc     #0  