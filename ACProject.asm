.data

welcome_msg: .ascii "Welcome to Cows and Bulls!\n\0"
prompt_msg: .ascii "\nEnter your 4-digit guess: \nStructure is:X X X X\n\0"
cows_bulls_msg: .ascii "   Cows: \0"
bulls_msg: .ascii " Bulls: \0"
win_msg: .ascii "\nCongratulations! You guessed the number!\n\0"
lose_msg: .ascii "\nYou lost! The number was: \0"
number_msg: .ascii "\nGenerated Number: \0"
new_line: .ascii "\n\0"


secret_number: .space 5     
input_buffer: .space 8      
parsed_input: .space 5     
digit_pool: .ascii "0123456789"

.text
.globl main

main:
    la a0, welcome_msg
    li a7, 4              
    ecall
    
    # Generate 4-digit number
    jal ra, generate_number
    
    li a3, 8   # Maximum no of attempts

play_loop:
    beqz a3, game_over    
    

    la a0, input_buffer
    li a1, 8             
    li a7, 8         
    ecall


    jal ra, parse_input


    jal ra, count_cows_bulls


    li t1, 4    # Winning condition: 4 bulls
    beq s1, t1, win


    addi a3, a3, -1
    j play_loop

win:
    la a0, win_msg
    li a7, 4           
    ecall
    j end_game

game_over:
    la a0, lose_msg
    li a7, 4            
    ecall


    la a0, secret_number
    li a7, 4         
    ecall

end_game:
    li a7, 10           
    ecall


# Generates a random 4-digit number with unique digits and stores it in secret_number
generate_number:
    la s0, digit_pool      
    li s1, 10          

shuffle_pool:
    li a7, 30             
    ecall
    rem t0, a0, s1         # t0 = random index (0 to 9)

    # Swap current index with random index
    lb t1, 0(s0)           
    la t2, digit_pool   
    add t2, t2, t0    
    lb t3, 0(t2)      
    sb t3, 0(s0)    
    sb t1, 0(t2)       

    addi s0, s0, 1       
    addi s1, s1, -1       
    bnez s1, shuffle_pool


    la s0, secret_number   
    la s1, digit_pool    
    li t0, 4            

copy_digits:
    lb t1, 2(s1)            # offset is two because shuffling is not great for first 2 values
    sb t1, 0(s0)       
    addi s1, s1, 1       
    addi s0, s0, 1        
    addi t0, t0, -1     
    bnez t0, copy_digits

    sb zero, 0(s0)    
    jr ra



# Parses input_buffer (X X X X) into parsed_input (digits only)
parse_input:
    la t0, input_buffer   
    la t1, parsed_input  
    li t2, 4             

parse_loop:
    lb t3, 0(t0)        
    beqz t3, parse_done    # If null terminator, stop parsing
    li t6, 32              # ASCII code for space (' ')
    beq t3, t6, skip_space

    sb t3, 0(t1)           # Store digit into parsed_input
    addi t1, t1, 1      
    addi t0, t0, 1    
    j parse_loop

skip_space:
    addi t0, t0, 1  
    j parse_loop

parse_done:
    sb zero, 0(t1)       
    jr ra


# Compares parsed_input with secret_number and counts cows and bulls
count_cows_bulls:
    la t0, parsed_input    
    la t1, secret_number  
    li t2, 4             

    li s0, 0      # Cows count
    li s1, 0      # Bulls count

cows_bulls_loop:
    lb s2, 0(t0)           
    lb s3, 0(t1)       

    beq s2, s3, count_bull # If digits match, count as bull

    # Check for cow (digit exists elsewhere in secret_number)
    la s4, secret_number  
    li s5, 4               

check_cow:
    lb s6, 0(s4)         
    beq s2, s6, count_cow  # If digit matches, count as cow
    addi s4, s4, 1        
    addi s5, s5, -1     
    bnez s5, check_cow 
    j next_digit

count_bull:
    addi s1, s1, 1     
    j next_digit

count_cow:
    addi s0, s0, 1     

next_digit:
    addi t0, t0, 1     
    addi t1, t1, 1      
    addi t2, t2, -1     
    bnez t2, cows_bulls_loop

    # Print cows and bulls
    la a0, cows_bulls_msg 
    li a7, 4             
    ecall

    mv a0, s0    # Load cows count
    li a7, 1              
    ecall

    la a0, bulls_msg     
    li a7, 4            
    ecall

    mv a0, s1    # Load bulls count
    li a7, 1         
    ecall
    
    la a0, new_line    
    li a7, 4           
    ecall
    
    jr ra
