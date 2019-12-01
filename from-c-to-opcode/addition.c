// A small for.loop to have an example to examinate

#include <8051.h>

void main(void)
{   
    for (int i=0; i<3; i++){
        char x = P1;
        x = x - 0x34;
        P1 = x;
    }
}