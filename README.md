# ARM-assembly-bubblesort
Bubble sort implemented in assembly. Displays the number of sorting passes that have been made on the LPC1768's onboard LEDs

Copied over from MBED ide

Assembly file takes array to be sorted as arg 0, and size of array as arg 1
While the bubble sort is being performed, the number of sorting passes that have been completed is displayed on the onbard LEDs
A wait subroutine is called after each sorting pass, causing the function to sleep for a little over a second, so that the eye can see 
the LEDs change

The C main file initalizes the array to be sorted, a variable with the size of the array, and prints the unsorted array to a serial port terminal, if one is connected
It then calls the assembly file, passing the array and array size as arguments
It then prints the now sorted array to the terminal

main.c also contains a bubble sort method (written in C) that was used for debugging purposes
