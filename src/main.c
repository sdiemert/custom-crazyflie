#include "stm32f4xx_conf.h"

#define LED_PERIF RCC_AHB1Periph_GPIOC
#define LED_PORT GPIOC
#define LEDS (GPIO_Pin_0) //| GPIO_Pin_2 | GPIO_Pin_3)


int main (void){

    //ledInit();


    RCC_AHB1PeriphClockCmd(LED_PERIF, ENABLE);

    GPIO_InitTypeDef GPIO_InitStructure;

    GPIO_InitStructure.GPIO_Pin=LEDS;
    GPIO_InitStructure.GPIO_Mode=GPIO_Mode_OUT;
    GPIO_InitStructure.GPIO_OType=GPIO_OType_PP;
    GPIO_InitStructure.GPIO_Speed=GPIO_Speed_100MHz; 
    GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;

    GPIO_Init(LED_PORT, &GPIO_InitStructure);

    int i; 
    while(1){
        GPIO_ToggleBits(LED_PORT, LEDS);
        for(i=0; i<100000000;i++);
    }

    //ledSet(0,1);


    while(1);

    return 0;
}
