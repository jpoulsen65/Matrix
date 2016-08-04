 1000        .LIST OFF
 1010        .OP 65C02
 1020 *------------------------------
 1030 * MATRIX SCREEN SAVER
 1040 *------------------------------
 1050 HOME       .EQ $FC58
 1060 BASECALC   .EQ $FBC1
 1070 KEYB       .EQ $C000
 1080 CLR.KEYB   .EQ $C010
 1090 *------------------------------
 1100 MAXCOL .EQ 40
 1110 MAXROW .EQ 22
 1120 BLANK  .EQ $A0
 1130 SCRCOL .EQ $28
 1140 *------------------------------
 1150        .OR $800
 1160 *      .TF MATRIX     
 1170 *------------------------------
 1180 MATRIX
 1190 START  JSR HOME
 1200        LDX #MAXCOL     
 1210 .1     STZ COLS,X  
 1220        DEX
 1230        BPL .1
 1240 *------------------------------
 1250 .2     LDY #MAXCOL  
 1260        LDA #0      
 1270        JSR RANDOM
 1280        LDX COLS,Y
 1290        BEQ .3
 1300        JSR SCROLL
 1310 .3     LDA #0   
 1320        JSR BASECALC
 1330        JSR GETCHR
 1340        STA (SCRCOL),Y
 1350        CPX #MAXROW
 1360        BEQ .2
 1370        TYA
 1380        TAX
 1390        INC COLS,X
 1400        JSR DELAY
 1410        LDA KEYB
 1420        BPL .2
 1430        STA CLR.KEYB
 1440        JSR HOME
 1450        RTS
 1460 *------------------------------
 1470 * SCROLL - SCROLL ROW DOWN
 1480 *------------------------------
 1490 SCROLL PHX
 1500 .1     DEX
 1510        TXA
 1520        JSR BASECALC
 1530        LDA (SCRCOL),Y
 1540        PHA
 1550        INX
 1560        TXA
 1570        JSR BASECALC
 1580        PLA
 1590        STA (SCRCOL),Y
 1600        DEX
 1610        BNE .1  
 1620        PLX
 1630        RTS
 1640 *------------------------------
 1650 * GETCHR - GET RANDOM CHARACTER
 1660 *------------------------------
 1670 GETCHR PHY
 1680        LDY #$FF
 1690        TYA
 1700        JSR RANDOM
 1710        CPY #$60     
 1720        BMI .1
 1730        TYA    
 1740        PHA
 1750        LDY #$FF
 1760        TYA
 1770        JSR RANDOM 
 1780        PLA
 1790        CMP #$9F
 1800        BPL .2  
 1810        AND #$F0
 1820        CMP #$90
 1830        BEQ .1
 1840        CMP #$80
 1850        BNE .3
 1860 .1     LDA #BLANK
 1870        BMI .4
 1880 .2     TYA    
 1890        ORA #$E0
 1900        BMI .4  
 1910 .3     TYA    
 1920 .4     PLY
 1930        RTS
 1940 *------------------------------ 
 1950 * DELAY - DELAY BEFORE NXTCHR
 1960 *------------------------------ 
 1970 DELAY  PHX
 1980        PHY
 1990        LDY #$FF
 2000        LDA #$0F
 2010        JSR RANDOM
 2020        TAX
 2030 .1     DEY 
 2040        BNE .1  
 2050        DEX 
 2060        BNE .1  
 2070        PLY
 2080        PLX
 2090        RTS
 2100 *------------------------------
 2110 * INCLUDE MODULES
 2120 *------------------------------
 2130        .IN RANDOM.ASM
 2140 *------------------------------
 2150 * DATA AREAS
 2160 *------------------------------
 2170 COLS   .BS MAXCOL   
 2180 *------------------------------ 
 2190 PGMSZ  .EQ *-MATRIX 
