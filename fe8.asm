        .thumb

        .section get_stat_increase
	ldr r0, =GetStatIncrease_Patch+1
        bx r0

        .section level_up_caps
        @ Be sure to be correctly aligned for ldr
	push {r4, r5, lr}
        mov r2, #0x12
        ldr r3, =CheckForLevelUpCaps_Patch+1
        bx r3
        @ adds r0, #0x73
        @ etc...

        .section promotion
        cmp r0, #0

        .section patches
GetStatIncrease_Patch:
        ldr r1, =#0x0203A4EC
        cmp r1, r7
        beq 1f
        add r1, #0x80
        cmp r1, r7
        bne 2f
1:      neg r4, r4
        @ overwritten
2:      mov r0, r4
	pop {r4}
	pop {r1}
        bx r1
CheckForLevelUpCaps_Patch:
        push {r6, r7}
        @ r0 = unit struct
        @ r1 = stat change array
        @ r2 = offset to first stat (HP)
        mov r3, #0x73
        @ r3 = offset first stat change (HP)
        @ HP (min 1)
        ldrsb r6, [r0, r2]
        ldrsb r7, [r1, r3]
        add r7, r6
        cmp r7, #1
        bge 1f
        mov r7, #1
        sub r6, r7, r6
        strb r6, [r1, r3]
1:      @ STR (min 0)
        add r2, #2
        add r3, #1
        ldrsb r6, [r0, r2]
        ldrsb r7, [r1, r3]
        add r7, r6
        cmp r7, #0
        bge 1f
        neg r6, r6
        strb r6, [r1, r3]
1:      @ SKL (min 0)
        add r2, #1
        add r3, #1
        ldrsb r6, [r0, r2]
        ldrsb r7, [r1, r3]
        add r7, r6
        cmp r7, #0
        bge 1f
        neg r6, r6
        strb r6, [r1, r3]
1:      @ SPD (min 0)
        add r2, #1
        add r3, #1
        ldrsb r6, [r0, r2]
        ldrsb r7, [r1, r3]
        add r7, r6
        cmp r7, #0
        bge 1f
        neg r6, r6
        strb r6, [r1, r3]
1:      @ DEF (min 0)
        add r2, #1
        add r3, #1
        ldrsb r6, [r0, r2]
        ldrsb r7, [r1, r3]
        add r7, r6
        cmp r7, #0
        bge 1f
        neg r6, r6
        strb r6, [r1, r3]
1:      @ RES (min 0)
        add r2, #1
        add r3, #1
        ldrsb r6, [r0, r2]
        ldrsb r7, [r1, r3]
        add r7, r6
        cmp r7, #0
        bge 1f
        neg r6, r6
        strb r6, [r1, r3]
1:      @ LCK (min 0)
        add r2, #1
        add r3, #1
        ldrsb r6, [r0, r2]
        ldrsb r7, [r1, r3]
        add r7, r6
        cmp r7, #0
        bge 1f
        neg r6, r6
        strb r6, [r1, r3]
1:      @ done
        pop {r6, r7}
        @ overwritten
        mov r2, r0
	mov ip, r1
        mov r1, #0x12
        ldrsb r1, [r2, r1]
        mov r0, ip
        @ jump back
        ldr r4, =0x0802BF24+4+8+1
        bx r4
