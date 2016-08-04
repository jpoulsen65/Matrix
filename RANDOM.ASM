 1000 *-------------------------------
 1010 * AAL - V1N11 - AUG 1981
 1020 *-------------------------------
 1030 * STAND-ALONE RANDOM FUNCTION
 1040 * ---------------------------
 1050 * GET A RANDOM NUMBER
 1060 * BETWEEN 0 & X-1
 1070 *
 1080 * CALL:   LIMIT/VALUE X IN
 1090 *         Y & A REGISTERS
 1100 *
 1110 * RETURN: RANDOM NUMBER IN
 1120 *         Y & A REGISTERS
 1130 *         LOW  BYTE IN Y
 1140 *         HIGH BYTE IN A 
 1150 *-------------------------------
 1160 RANDOM.RNDL         .EQ $4E
 1170 RANDOM.RNDH         .EQ $4F
 1180 *-------------------------------
 1190 RANDOM STY RANDOM.LIMIT
 1200        STA RANDOM.LIMIT+1
 1210        LDA RANDOM.RNDH
 1220        BNE .1
 1230        CMP RANDOM.RNDL
 1240        ADC #00
 1250 .1     AND #$7F
 1260        STA RANDOM.RNDH
 1270        STA RANDOM.VALUE+1
 1280        LDA RANDOM.RNDL
 1290        STA RANDOM.VALUE
 1300        LDA #0
 1310        STA RANDOM.VALUE+2
 1320        STA RANDOM.VALUE+3
 1330 *-------------------------------
 1340 * LOOP TO MAKE NEXT RANDOM #
 1350 *-------------------------------
 1360        LDY #17
 1370 .2     LDA RANDOM.RNDH
 1380        ASL
 1390        CLC
 1400        ADC #$40
 1410        ASL
 1420        ROL RANDOM.RNDL
 1430        ROL RANDOM.RNDH
 1440        DEY
 1450        BNE .2
 1460 *-------------------------------
 1470        LDA RANDOM.LIMIT
 1480        ORA RANDOM.LIMIT+1
 1490        BEQ .5
 1500 *-------------------------------
 1510 * DIVIDE RANDOM VALUE (1-7FFF)
 1520 * BY LIMIT AND USE REMAINDER 
 1530 * (0 <= REMAINDER < LIMIT)
 1540 *-------------------------------
 1550        LDY #16
 1560 .3     ASL RANDOM.VALUE
 1570        ROL RANDOM.VALUE+1
 1580        ROL RANDOM.VALUE+2
 1590        ROL RANDOM.VALUE+3
 1600        LDA RANDOM.VALUE+2
 1610        CMP RANDOM.LIMIT
 1620        LDA RANDOM.VALUE+3
 1630        SBC RANDOM.LIMIT+1
 1640        BCC .4
 1650        STA RANDOM.VALUE+3
 1660        LDA RANDOM.VALUE+2
 1670        SBC RANDOM.LIMIT
 1680        STA RANDOM.VALUE+2
 1690        INC RANDOM.VALUE
 1700 .4     DEY
 1710        BNE .3
 1720 *-------------------------------
 1730 * RETURN RANDOM VALUE MOD LIMIT
 1740 *-------------------------------
 1750 .5     LDA RANDOM.VALUE+3
 1760        LDY RANDOM.VALUE+2
 1770        RTS
 1780 *-------------------------------
 1790 RANDOM.LIMIT        .BS 2
 1800 RANDOM.VALUE        .BS 4
