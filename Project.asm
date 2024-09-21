.model small
.stack 100h
.data    
    ; CONSTANTS
    MAX_SCREEN_WIDTH equ 321
    MAX_SCREEN_HEIGHT equ 201
    FIRST_PAGE equ 00
    BLACK_COLOR equ 00
    WHITE_COLOR equ 15
    RED_COLOR equ 04
    CYAN_COLOR equ 11
    LIGHT_GREEN_COLOR equ 10
    LIGHT_BLUE_COLOR equ 09
    SPACESHIP_Y equ 180
    RIGHT_SHIP_BORDER equ 280
    LEFT_SHIP_BORDER equ 40
    A_KEY equ 97
    D_KEY equ 100
    STOP_FLAG equ 99
    MOVEMENT_SIZE equ 5
    ALIEN_MODE1 equ 1
    ALIEN_MODE0 equ 0
    MIN_ALIEN_X equ 60
    MAX_ALIEN_X equ 100
    MOVE_LEFT equ 0
    
    ; variables used to clear the screen, representing the x and y coordinates of the screen
    screenX dw 00
    screenY dw 00
    
    ; variables used to draw the spaceship, representing the x and y coordinates of the ship
    spaceshipX dw 160 
    spaceshipY dw 180
    
    ; Arrays of 24 length to store the status of each of the aliens, their x and y coordinates
    ; there is a 5 value at the end to signal the end of the array
    alienXArr dw 80, 100, 120, 140, 160, 180, 200, 80, 100, 120, 140, 160, 180, 200, 80, 100, 120, 140, 160, 180, 200, 99
    alienYArr dw 90, 90, 90, 90, 90, 90, 90, 70, 70, 70, 70, 70, 70, 70, 50, 50, 50, 50, 50, 50, 50, 99
    alienCount dw 21
    alienMode dw 1
    
    ; Variables representing the corners of an alien's hitbox
    alienRightX dw 00
    alienLeftX dw 00
    alienBottomY dw 00
    alienTopY dw 00
    
    ; Variable representing the alien to be checked
    currentAlien dw 00
    
    ; Arrays which store the x and y coordinates of various laser beams (max of 5)
    currentBeamCount dw 00
    beamXArr dw 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 99
    beamYArr dw 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 99
    
    ; Variable which checks how many iterations we've been through
    timer dw 00
      
    ; Variable which represents the win condition
    winCondition dw 00
    
    ; Strings to display
    startMessage db "Welcome to Inon's Space Invaders!$" 
    losingPrompt db "You lose!$"
    victoryPrompt db "You win!$"
    
    ; Loop variable
    i dw 00
    count dw 00
    
    ; Variable holding the random number
    randomNumber dw 00
    
    ; Temporary variable
    temp dw 80
    
.code

;------------------------------------------------------------------clear screen-----------------------------------------------------------------;
    ;; Procedure to clear the screen
    cls proc
        print:  
                mov ah, 0ch ; set configuration to write pixel
                mov al, BLACK_COLOR ; set writing color
                mov bh, FIRST_PAGE ; set page
                mov cx, screenX ; set x coordinate
                mov dx, screenY ; set y coordinate
                int 10h ; execute configuration
                inc screenX ; increase x value
            
            
                cmp screenX, MAX_SCREEN_WIDTH ; if x is above the screen width, go down to the the next line
                je newLine
            
                cmp screenY, MAX_SCREEN_HEIGHT ; if y is above the screen length, stop the loop
                je stop
            
                jmp print
        newLine:
                mov screenX, 00h ; reset the screen x
                inc screenY ; increase the screen y
                jmp print
        stop:
            mov screenX, 00h
            mov screenY, 00h
        ret
    endp
    
;--------------------------------------------------------------------Ship-----------------------------------------------------------------------;
    ;; Procedure which creates a ship
    createShip proc
        mov ah, 0ch ; Set mode to write pixel
        mov al, WHITE_COLOR ; set color to white
        mov bh, FIRST_PAGE ; Set page to 0
        
        call drawConfig ; Call function to execute configuration
        
        ;; Continue drawing the ship:
        inc spaceshipY 
        call drawConfig
        
        inc spaceshipY
        call drawConfig
        
        dec spaceshipX
        inc spaceshipY
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipY
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        inc spaceshipY
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipY
        add spaceshipX, 3
        mov al, RED_COLOR
        call drawConfig
        
        sub spaceshipX, 3
        mov al, WHITE_COLOR
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        sub spaceshipX, 3
        mov al, RED_COLOR
        call drawConfig
        
        inc spaceshipY
        call drawConfig
        
        add spaceshipX, 2
        mov al, WHITE_COLOR
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        add spaceshipX, 2
        mov al, RED_COLOR
        call drawConfig
        
        inc spaceshipY
        add spaceshipX, 3
        call drawConfig
        
        sub spaceshipX, 3
        mov al, WHITE_COLOR
        call drawConfig
        
        dec spaceshipX
        mov al, LIGHT_BLUE_COLOR
        call drawConfig
        
        dec spaceshipX
        mov al, WHITE_COLOR
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        mov al, RED_COLOR
        call drawConfig
        
        dec spaceshipX
        mov al, WHITE_COLOR
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        mov al, LIGHT_BLUE_COLOR
        call drawConfig
        
        dec spaceshipX
        mov al, WHITE_COLOR
        call drawConfig
        
        sub spaceshipX, 3
        mov al, RED_COLOR
        call drawConfig
        
        inc spaceshipY
        call drawConfig
        
        add spaceshipX, 3
        mov al, LIGHT_BLUE_COLOR
        call drawConfig
        
        inc spaceshipX
        mov al, WHITE_COLOR
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        mov al, RED_COLOR
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        mov al, WHITE_COLOR
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        mov al, LIGHT_BLUE_COLOR
        call drawConfig
        
        add spaceshipX, 3
        mov al, RED_COLOR
        call drawConfig
        
        inc spaceshipY
        mov al, WHITE_COLOR
        call drawConfig
        
        sub spaceshipX, 3
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        mov al, RED_COLOR
        call drawConfig
        
        dec spaceshipX
        mov al, WHITE_COLOR
        call drawConfig
        
        dec spaceshipX
        mov al, RED_COLOR
        call drawConfig
        
        dec spaceshipX
        mov al, WHITE_COLOR
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        sub spaceshipX, 3
        call drawConfig
        
        inc spaceshipY
        call drawConfig
        
        add spaceshipX, 2
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        add spaceshipX, 2
        call drawConfig
        
        inc spaceshipY
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        mov al, RED_COLOR
        call drawConfig
        
        dec spaceshipX
        mov al, WHITE_COLOR
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        mov al, RED_COLOR
        call drawConfig
        
        dec spaceshipX
        mov al, WHITE_COLOR
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        inc spaceshipY
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        add spaceshipX, 2
        mov al, RED_COLOR
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        mov al, WHITE_COLOR
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        mov al, RED_COLOR
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        add spaceshipX, 2
        mov al, WHITE_COLOR
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipX
        call drawConfig
        
        inc spaceshipY
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        sub spaceshipX, 3
        mov al, RED_COLOR
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        sub spaceshipX, 2
        mov al, WHITE_COLOR
        call drawConfig
        
        sub spaceshipX, 2
        mov al, RED_COLOR
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        sub spaceshipX, 3
        mov al, WHITE_COLOR
        call drawConfig
        
        dec spaceshipX
        call drawConfig
        
        inc spaceshipY
        call drawConfig
        
        add spaceshipX, 7
        call drawConfig
        
        add spaceshipX, 7
        call drawConfig
        
        mov spaceshipY, SPACESHIP_Y
        sub spaceshipX, 7
        ret
    endp
    
    ;; Procedure to execute drawing configuration
    drawConfig proc
        mov cx, spaceshipX
        mov dx, spaceshipY
        int 10h
        ret
    endp
    
    ;; Procedure to delete the ship
    deleteShip proc
    
    mov screenY, SPACESHIP_Y ; setting the screen y to save resources
        
        print1:                 
                mov ah, 0ch ; set configuration to write pixel
                mov al, BLACK_COLOR ; set writing color
                mov bh, FIRST_PAGE ; set page
                mov cx, screenX ; set x coordinate
                mov dx, screenY ; set y coordinate
                int 10h ; execute configuration
                inc screenX ; increase x value
            
            
                cmp screenX, MAX_SCREEN_WIDTH ;if x is above the screen width, go down to the the next line
                je newLine1
            
                cmp screenY, MAX_SCREEN_HEIGHT ; if y is above the screen length, stop the loop
                je stop1
                jmp print1
                
        newLine1:
                mov screenX, 00  ; reset the screen x
                inc screenY ; increase the screen y
                jmp print1
        stop1:
        mov screenX, 00 ; Reset x and y values
        mov screenY, 00
        ret
    endp
    
    ;; Procedure which moves the ship
    moveShip proc

        cmp al, A_KEY ; check if a key was pressed
        je moveLeft
        
        cmp al, D_KEY ; check if d key was pressed
        je moveRight
        
        jmp stop2

        moveRight: ; move the ship right
            cmp spaceshipX, RIGHT_SHIP_BORDER
            jg stop2
        
            add spaceshipX, MOVEMENT_SIZE
            call deleteShip 
            call createShip
            jmp stop2
            
            moveLeft: ; move the ship left
            cmp spaceshipX, LEFT_SHIP_BORDER
            jl stop2
            
            sub spaceshipX, MOVEMENT_SIZE
            call deleteShip
            call createShip
        stop2:    
        ret
    endp
;---------------------------------------------------------------------Aliens--------------------------------------------------------------------;
    ;; Procedure which draws the Aliens
    drawAliens proc
        ; Pass the addresses of x and y coordinates into si and di
        lea si, [alienXArr]
        lea di, [alienYArr]
        
        draw:
            cmp byte ptr [si], STOP_FLAG
            je stop13
            
            cmp byte ptr [si], 00
            je reset
            
            ; Clearing the cx and dx registers
            xor cx, cx
            xor dx, dx
        
            ; Setting up the basic configuration
            mov ah, 0ch
            mov al, LIGHT_GREEN_COLOR
            mov bh, FIRST_PAGE
            
            cmp alienMode, 1
            je drawAlien3
            
        drawAlien2:            
            call alien0
            jmp reset
            
        drawAlien3:    
            call alien1
            
        reset:
            add si, 2
            add di, 2
            jmp draw
            
        stop13:
            cmp alienMode, 1
            je changeMode1
        
        changeMode0:
            inc alienMode
            jmp stop17
            
        changeMode1:
            dec alienMode
            
        stop17:
        ret
    endp
    
    ;; Procedure to draw the first alien type
    alien0 proc
        
        mov cx, word ptr [si]
        mov dx, word ptr [di]
        int 10h
        
        add cx, 6
        int 10h
        
        inc dx
        dec cx
        int 10h
        
        sub cx, 4
        int 10h
        
        inc dx
        dec cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        inc dx
        int 10h
        
        dec cx
        int 10h
        
        sub cx, 2
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        sub cx, 2
        int 10h
        
        dec cx
        int 10h
        
        inc dx
        dec cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc dx
        int 10h
        
        sub cx, 2
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        sub cx, 2
        int 10h
        
        inc dx
        int 10h
        
        add cx, 2
        int 10h
       
        add cx, 6
        int 10h 
        
        add cx, 2
        int 10h
        
        inc dx
        sub cx, 3
        int 10h
        
        dec cx
        int 10h
        
        sub cx, 2
        int 10h
        
        dec cx
        int 10h
        ret
    endp
    
    ;; Procedure to draw the second alien type
    Alien1 proc
        
        mov cx, word ptr [si]
        mov dx, word ptr [di]
        int 10h
        
        add cx, 6
        int 10h
        
        inc dx
        add cx, 2
        int 10h
        
        sub cx, 3
        int 10h
        
        sub cx, 4
        int 10h
        
        sub cx, 3
        int 10h
        
        inc dx
        int 10h
        
        add cx, 2
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        add cx, 2
        int 10h
        
        inc dx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        sub cx, 2
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        sub cx, 2
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        inc dx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc cx
        int 10h
        
        inc dx
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        dec cx
        int 10h
        
        inc dx
        inc cx
        int 10h
        
        add cx, 6
        int 10h
        
        inc dx
        inc cx
        int 10h
        
        sub cx, 8
        int 10h
        
        ret
    endp
    
    ;; Procedure to delete the aliens
    deleteAliens proc
        ; Pass the addresses of x and y coordinates into si and di
        lea si, [alienXArr]
        lea di, [alienYArr]
        
        ; Pass the addresses of x and y coordinates into si and di
        lea si, [alienXArr]
        lea di, [alienYArr]
        
        draw1:
            cmp byte ptr [si], STOP_FLAG
            je stop16
            
            cmp byte ptr [si], 00
            je reset1
            
            ; Clearing the cx and dx registers
            xor cx, cx
            xor dx, dx
        
            ; Setting up the basic configuration
            mov ah, 0ch
            mov al, BLACK_COLOR
            mov bh, FIRST_PAGE
            
            call alien0
            call alien1
            
        reset1:
            add si, 2
            add di, 2
            jmp draw1
        stop16:    
        ret
    endp
;------------------------------------------------------------------Move Aliens------------------------------------------------------------------;    
    ;; Procedure which generates a number between 1 and 4
    RNG proc
        ; Get the current time
        mov ah, 00
        int 1ah
        
        ; Getting the number between 0 and 1
        and dx, 1
        mov [randomNumber], dx
        xor dx, dx

        ret
    endp
    
    ;; Procedure which decides how to move the alien
    moveAliens proc
    
        ; Calling function to generate random number
        call rng
        
        ; Move aliens left if the random number is 0
        cmp randomNumber, MOVE_LEFT
        je left
        jne right
            
        left:
            call moveAliensLeft
            jmp stop23

        right:
            call moveAliensRight
            jmp stop23
            
        stop23:
        ret
    endp
    
    
    ;; Procedure to move the aliens left
    moveAliensLeft proc
        lea si, [alienXArr]
        cmp temp, MIN_ALIEN_X
            je change
        
        move1:
            cmp byte ptr [si], STOP_FLAG
                je stop19
                
            cmp byte ptr [si], 00
                je reset2
                
            sub byte ptr [si], MOVEMENT_SIZE
            
        reset2:
            add si, 2
            jmp move1
            
        change:
            call moveAliensRight
            add temp, MOVEMENT_SIZE
            
        stop19:
            sub temp, MOVEMENT_SIZE
            
        ret
    endp
    
    ;; Procedure to move the aliens right
    moveAliensRight proc
        lea si, [alienXArr]
        
       move3:
            cmp byte ptr [si], STOP_FLAG
                je stop21
                
            cmp byte ptr [si], 00
                je reset4
                
            add byte ptr [si], MOVEMENT_SIZE
            
        reset4:
            add si, 2
            jmp move3
            
        change2:
            call moveAliensLeft 
            sub temp, MOVEMENT_SIZE   
            
        stop21:
            add temp, MOVEMENT_SIZE
            
        ret
    endp
    
;------------------------------------------------------------------Tick Counter-----------------------------------------------------------------;
    ; Procedure to wait for approximately 50 milliseconds
    wait1Tick proc
    mov cx, 15000   ; Set the loop counter for approximately 50ms delay
    
        delayLoop:
            mov ah, 0      ; Set AH to 0 to prepare for INT 08h
            int 08h        ; Call the hardware timer interrupt
    
            dec cx        ; Decrement the loop counter
            jnz delayLoop  ; Jump back to delayLoop if CX is not zero
    
    ret
    endp
;-------------------------------------------------------------------laser beam------------------------------------------------------------------;
    ;; Procedure which checks if we can create another beam
    createBeam proc   
        ; If we already have 10 beams, jump to the end
        cmp currentBeamCount, 10
        je stop9
           
        ; Load the effective address of beamXArr into si
        lea si, [beamXArr]
        
        ; Loop which iterates through the array until it finds a space
        findSpace:
        cmp word ptr [si], STOP_FLAG ; If the value is 5, stop
            mov currentBeamCount, 10
            je stop9
            
            cmp word ptr [si], 00h ; If the value is 0, space was found
            je foundSpace 
            
            add si, 2
            jmp findSpace ; Jump back to the top
        foundSpace:
            inc currentBeamCount
            mov ax, spaceshipX
            mov word ptr [si], ax ; Move the value of spaceshipX into the array
        stop9:
        ret
    endp
  
    ;; Procedure which draws the beam
    drawBeam proc
        ; Load the effective addresses of beamXArr and beamYArr into si and di respectively
        lea si, [beamXArr]
        lea di, [beamYArr]
        
        shoot1:
        cmp byte ptr [si], STOP_FLAG
            je stop11
            
            cmp byte ptr [si], 00h
            je next
            
            call moveBeamUp
            
            next:
                add si, 2
                add di, 2
                jmp shoot1
            
        stop11:
        ret
    endp  
    
    ;; Procedure which moves the beam up
    moveBeamUp proc
        ; Set up basic configuration
        mov ah, 0ch
        mov al, CYAN_COLOR
        mov bh, FIRST_PAGE
        
        ; Clear cx and dx registers
        xor cx, cx
        xor dx, dx
        
        mov cl, byte ptr [si]
        mov dl, byte ptr [di]
        int 10h
 
        add byte ptr [di], 2
        mov al, 00h
        mov dl, byte ptr [di]
        int 10h
        
        sub byte ptr [di], 3
        ret
    endp
    ;; Procedure which checks if the beam reached the end
    checkBeam proc
        ; Load the effective address of beamXArr and beamYArr into si and di
        lea di, [beamYArr]
        lea si, [beamXarr]
        
        ; Loop which iterates through the array until it finds a space
        findSpace1:
            cmp word ptr [di], STOP_FLAG ; If the value is 5, stop
            je stop12
            
            cmp word ptr [di], 00 ; If the value is below 5, delete it
            je foundSpace1
            
            add di, 2
            add si, 2
            add i, 2
            jmp findSpace1 ; Jump back to the top
        foundSpace1:
            call deleteBeam
            dec currentBeamCount
            mov word ptr [di], 177 ; Move the value of spaceshipX into the array
            mov word ptr [si], 00h
            add di, 2
            add si, 2
            jmp findspace1
        stop12:
        mov i, 00h
        ret
    endp
    
    deleteBeam proc
        ; Set up basic configuration
        mov ah, 0ch
        mov al, 00h
        mov bh, 00h
        
        ; clear the cx and bx registers
        xor cx, cx
        xor bx, bx
        
        ; Execute configuration
        mov cl, byte ptr [si]
        mov dl, byte ptr [di]
        int 10h
        
        inc byte ptr [di]
        mov dl, byte ptr [di]
        int 10h
        
        inc byte ptr [di]
        mov dl, byte ptr [di]
        int 10h
        ret
    endp
;----------------------------------------------------------------------Input--------------------------------------------------------------------;
    getInput proc
        mov ah, 01h     ; Check if a key is pressed
        int 16h

        jz stop10       ; Jump to stop10 if no key is pressed

        mov ah, 00h     ; Get user input
        int 16h

        cmp al, 61h     ; If a key was pressed
        je move

        cmp al, 64h     ; If d key was pressed
        je move
        
        cmp al, 20h     ; If space key was pressed
        je shoot
        
        jmp stop10

        move:
            call moveShip
            jmp stop10
            
        shoot:
            call createBeam
        stop10:
        ret
    endp
;------------------------------------------------------------------------Win--------------------------------------------------------------------;
    ;; Procedure which checks the collision 
    checkCollision proc
        aliens:
            lea si, [alienXArr]
            lea di, [alienYArr]
            add si, currentAlien
            add di, currentAlien
            
            cmp word ptr [si], STOP_FLAG
            je tempStop
            
            call getAlienHitBox
            
            lea si, [beamXArr]
            lea di, [beamYArr]
            
            beams:
                cmp word ptr [si], STOP_FLAG
                je nextAlien
                
                cmp word ptr [si], 00
                je nextBeam
                
                mov ax, word ptr [si]
                mov bx, word ptr [di]
                cmp alienLeftX, ax
                    jl check2ndX
                    
                jmp nextBeam
            
            nextAlien:
                add currentAlien, 2
                jmp aliens
                
            nextBeam:
                add si, 2
                add di, 2
                jmp beams
                
        check2ndX:
            cmp alienRightX, ax
            jl check1stY
            jmp nextBeam
            
        check1stY:
            cmp alienTopY, bx
            jl check2ndY
            jmp nextBeam
            
        check2ndY:
            cmp alienBottomY, bx
            jg alienHit
            jmp nextBeam
            
        tempStop:
            jmp stop24  
            
        alienHit: 
            dec alienCount
            call deleteBeam
            mov word ptr [si], 00
            mov word ptr [di], 00
            
            lea si, [alienXArr]
            lea di, [alienYArr]
            
            add si, currentAlien
            add di, currentAlien
            
            mov ah, 0ch
            mov al, BLACK_COLOR
            mov bh, FIRST_PAGE
            
            call alien0
            call alien1
            
            mov word ptr [si], 00
            mov word ptr [di], 00
            jmp nextAlien
            
        stop24:
            mov currentAlien, 00
        ret
    endp
    
    ;; Procedure which gets the hitbox of the given alien
    getAlienHitbox proc
        mov ax, word ptr [si]
    
        mov alienLeftX, ax
        sub alienLeftX, 3
        
        mov alienRightX, ax
        add alienRightX, 9
        
        mov ax, word ptr [di]
        
        mov alienTopY, ax
        dec alienTopY
        
        mov alienBottomY, ax
        add alienBottomY, 9
        ret
    endp
    
    ;; Procedure which checks for a win
    checkWin proc
        ; passing x array's address
        lea si, [alienXArr]
        
        cmp alienCount, 0
        jne stop15
            
        won:
            mov winCondition, 1
             
        stop15:
        ret
    endp
;---------------------------------------------------------------------Prompt--------------------------------------------------------------------;
    ;; Procedure which prints the starting message
    startPrompt proc
        mov ah, 0Eh       ; BIOS interrupt subfunction to print character
        mov al, 0         ; Clear AL register
        mov bh, 0         ; Page number (0 for text mode)
        mov bl, 7         ; Text color (7 for normal white)
        mov cx, 33        ; Length of the prompt string

        lea si, [startMessage]    ; Load the address of the prompt string
        
        printStart:
            lodsb             ; Load the next character from DS:SI into AL
            cmp al, '$'       ; Check if it's the end of the string
            je done1           ; If yes, return from the subroutine

            int 10h           ; Print the character

            jmp printStart  ; Repeat for the next character
        done1:
        ret
    endp
    
    ;; Procedure whcih prints the losing message
    lossPrompt proc
        mov ah, 0Eh       ; BIOS interrupt subfunction to print character
        mov al, 0         ; Clear AL register
        mov bh, 0         ; Page number (0 for text mode)
        mov bl, 7         ; Text color (7 for normal white)
        mov cx, 9        ; Length of the prompt string

        lea si, [losingPrompt]    ; Load the address of the prompt string
        
        printLoss:
            lodsb             ; Load the next character from DS:SI into AL
            cmp al, '$'       ; Check if it's the end of the string
            je done2           ; If yes, return from the subroutine

            int 10h           ; Print the character

            jmp printLoss ; Repeat for the next character
        done2:
        ret
    endp
    
    ;; Procedure whcih prints the winning message
    winPrompt proc
        mov ah, 0Eh       ; BIOS interrupt subfunction to print character
        xor al, al         ; Clear AL register
        mov bh, FIRST_PAGE ; Page number (0 for text mode)
        mov bl, 7         ; Text color (7 for normal white)
        mov cx, 8        ; Length of the prompt string

        lea si, [victoryPrompt]    ; Load the address of the prompt string
        
        printWin:
            lodsb             ; Load the next character from DS:SI into AL
            cmp al, '$'       ; Check if it's the end of the string
            je done3          ; If yes, return from the subroutine

            int 10h           ; Print the character

            jmp printWin ; Repeat for the next character
        done3:
        ret
    endp
;----------------------------------------------------------------------Main---------------------------------------------------------------------;
    start:
    mov ax, @data
    mov ds, ax
    Again:

    mov ah, 00h ; Set configuration to video mode
    mov al, 13h ; Choose the video mode vga, 320x200, 256 colors, 8bpp
    int 10h ; Execute configuration
    
    call startPrompt ; print the starting message
    mov ah, 00h
    int 16h
    call cls ; Clear the screen
    call createShip ; Draw the initial ship
    
    gameLoop:
        call drawAliens
        call getInput
        call drawBeam
        call getInput
        call checkBeam
        call getInput
        call checkCollision
        call getInput
        call drawBeam
        call getInput
        call checkBeam
        call getInput
        call checkCollision
        call getInput
        call drawBeam
        call getInput
        call checkBeam
        call getInput
        call checkCollision
        call getInput
        call wait1Tick
        call getInput
        call wait1Tick
        call deleteAliens
        call getInput
        call moveAliens
        
        call getInput
        
        call checkWin
        
        inc timer
    
    cmp winCondition, 1
        je win
        
    cmp timer, 5
        je loss

    
    jmp gameLoop
    
    ; Loss
    loss: 
        call lossPrompt
        mov ah, 00h
        int 16h
        
    ; Win
    win:
        call winPrompt
        mov ah, 00h
        int 16h
        
    call cls
    
    
    
mov ah, 4ch
int 21h
end start