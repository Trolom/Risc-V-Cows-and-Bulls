# Risc-V Cows-and-Bulls

  The "Cows and Bulls" game is a classic code-breaking game where the player tries to guess a secret 4-digit number within a limited number of attempts. Each attempt reveals the number of digits correctly guessed in the right position (bulls) and digits correctly guessed but in the wrong position (cows). This project implements the game using the RISC-V assembly language, showcasing low-level programming concepts.

## Code Explanation: Main function
    1. Calls the generate_number subroutine to create a unique 4-digit secret number.
    2. Enters the main game loop, 8 attempts are available.
    3. For each guess:
        ◦ Prompts for input
        ◦ Parses the input
        ◦ Compares the input with the secret number
        ◦ Displays the count of cows and bulls
        ◦ Ends the game if the player guesses the number correctly
    4. Displays a losing message and the secret number
    
![image](https://github.com/user-attachments/assets/7dabd1f7-13a5-460c-a2ea-6089d4f0d8fd)
![image](https://github.com/user-attachments/assets/53c404b7-dcec-406b-9f0d-672b0fc67906)

## Functions:

    • generate_number
Randomly shuffles the digits in the digit_pool.
Copies the first 4 digits to secret_number.

    • parse_input
Parses the player's input, ignoring spaces and ensuring only valid digits are stored.

    • count_cows_bulls
Compares each digit in parsed_input with the corresponding digit in secret_number.
Increments the bull count if a digit matches in the correct position.
Increment the cow count if the digit is from secret number but not in the correct position.
Displays the counts of cows and bulls.


Link to RARS(Simulator for RISC V): https://github.com/TheThirdOne/rars
