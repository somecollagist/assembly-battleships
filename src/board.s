.code16

.global player_ships
.global computer_ships
.global player_torpedoes
.global computer_torpedoes

.data
player_ships:
    .byte 0b00000000        # 8                
    .byte 0b00000111        # 7           X X X
    .byte 0b01111100        # 6   X X X X X    
    .byte 0b00100010        # 5     X       X  
    .byte 0b00100010        # 4     X       X  
    .byte 0b01000010        # 3   X         X  
    .byte 0b01000010        # 2   X         X  
    .byte 0b01000000        # 1   X            
                            #   A B C D E F G HP

computer_ships:
    .byte 0b10000000        # 8 X              
    .byte 0b10111110        # 7 X   X X X X X  
    .byte 0b10000000        # 6 X              
    .byte 0b00000000        # 5                
    .byte 0b00111010        # 4     X X X   X  
    .byte 0b00000010        # 3             X  
    .byte 0b00000010        # 2             X  
    .byte 0b00110010        # 1     X X     X  
                            #   A B C D E F G H

player_torpedoes:
    .rept 8
    .byte 0
    .endr

computer_torpedoes:
    .rept 8
    .byte 0
    .endr
    