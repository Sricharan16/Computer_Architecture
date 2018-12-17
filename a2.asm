.factorial:
cmp r0, 1 /* compare (1,num) */
beq .return
bgt .continue
b .return
.continue:
sub r0, r0, 1 /* num = num - 1 */
call .factorial /* result will be in r1 */
mul r1, r0, r1 /* factorial(n) = n * factorial(n-1) */

ret
.return:
mov r1, 1
ret
.main:
mov r0, 10
call .factorial
.print r1
