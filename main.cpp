#include "mbed.h"

// Function prototypes
extern "C" int asm_sort(int numbers[16], int size);
void c_sort (int numbers[16], int size);

// Declare LED outputs
DigitalOut myled1(LED1);
DigitalOut myled2(LED2);
DigitalOut myled3(LED3);
DigitalOut myled4(LED4);

// Array to sort
const int size = 16;
int numbers[size] = {12, 11, 14, 10, 9, 8, 22, 7, 6, 5, 15, 4, 3, 2, 0, 1};

int main() {
    // Show current array contents and set lights to "before" pattern
    printf("Before\n\r");
    for(int index = 0; index <= size-1; index++)
    printf("%d, ", numbers[index]);     //Prints the unsorted dataset to terminal
    
    // Call the sort function, comment out the one not being used
    asm_sort(numbers, size); // Call to assembly sort
    //c_sort(numbers, size); // Call to driver test stub
    
    printf("\n\rAfter\n\r");
    for(int index = 0; index <= size-1; index++)
    printf("%d, ", numbers[index]);     //Prints sorted dataset to terminal
    printf("\n\rhmm");                  //Ensures that the previous print statement makes it to the terminal
    while(1) {}
}

//Bubblesort written in C, for testing purposes
void c_sort (int numbers[10], int size){ 
    int temp;
    for (int out_count = 0; out_count <= size - 2; out_count++){
        for (int in_count = 0; in_count <= size - 2 - out_count; in_count++){
            if (numbers[in_count] > numbers[in_count + 1]){
                temp = numbers[in_count];
                numbers[in_count] = numbers[in_count + 1];
                numbers[in_count + 1] = temp;
            }
        }
    }
}