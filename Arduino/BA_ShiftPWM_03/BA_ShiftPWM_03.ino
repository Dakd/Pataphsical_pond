/************************************************************************************************************************************
   ShiftPWM blocking RGB fades example, (c) Elco Jacobs, updated August 2012.

   ShiftPWM blocking RGB fades example. This example uses simple delay loops to create fades.
   If you want to change the fading mode based on inputs (sensors, buttons, serial), use the non-blocking example as a starting point.
   Please go to www.elcojacobs.com/shiftpwm for documentation, fuction reference and schematics.
   If you want to use ShiftPWM with LED strips or high power LED's, visit the shop for boards.
 ************************************************************************************************************************************/

// ShiftPWM uses timer1 by default. To use a different timer, before '#include <ShiftPWM.h>', add
// #define SHIFTPWM_USE_TIMER2  // for Arduino Uno and earlier (Atmega328)
// #define SHIFTPWM_USE_TIMER3  // for Arduino Micro/Leonardo (Atmega32u4)

// Clock and data pins are pins from the hardware SPI, you cannot choose them yourself if you use the hardware SPI.
// Data pin is MOSI (Uno and earlier: 11, Leonardo: ICSP 4, Mega: 51, Teensy 2.0: 2, Teensy 2.0++: 22)
// Clock pin is SCK (Uno and earlier: 13, Leonardo: ICSP 3, Mega: 52, Teensy 2.0: 1, Teensy 2.0++: 21)

// You can choose the latch pin yourself.
const int ShiftPWM_latchPin = 8;

// ** uncomment this part to NOT use the SPI port and change the pin numbers. This is 2.5x slower **
//#define SHIFTPWM_NOSPI
 //const int ShiftPWM_dataPin = 11;
// const int ShiftPWM_clockPin = 13;


// If your LED's turn on if the pin is low, set this to true, otherwise set it to false.
const bool ShiftPWM_invertOutputs = false;

// You can enable the option below to shift the PWM phase of each shift register by 8 compared to the previous.
// This will slightly increase the interrupt load, but will prevent all PWM signals from becoming high at the same time.
// This will be a bit easier on your power supply, because the current peaks are distributed.
const bool ShiftPWM_balanceLoad = false;

#include <ShiftPWM.h>   // include ShiftPWM.h after setting the pins!
#include <SoftwareSerial.h>
#include <string.h>
SoftwareSerial BTSerial(3, 2); //Connect HC-06 TX,RX

//#include <VSync.h>


// Here you set the number of brightness levels, the update frequency and the number of shift registers.
// These values affect the load of ShiftPWM.
// Choose them wisely and use the PrintInterruptLoad() function to verify your load.
// There is a calculator on my website to estimate the load.

unsigned char maxBrightness = 128;
unsigned char pwmFrequency = 50;
int numRegisters = 16;
int numRGBleds = numRegisters * 8 / 3;
//int numRGBleds = 32;
//int Apin = 0; \
//int cellNum = 0;
//String stringOne;





//int val = 0;
//int cell = 0;


int pixNUM = 0;
int briNUM = 0;
int Blue = 0;
int LedON = 100;
int LedOFF = 200;
int mode = 0;
int moderunState = 0;

const int moderun = 6;
unsigned long previousMillis = 0;
char inData[80];
char users[80];
byte index = 0;


//ValueReceiver<2> receiver;

//int pixNUM, briNUM;



void setup() {
  Serial.begin(250000);
 // BTSerial.begin(9600);//블루투스 연결

 // receiver.observe(pixNUM);
 // receiver.observe(briNUM);



  //pinMode(ledPin, OUTPUT); // Set pin as OUTPUT

  // Sets the number of 8-bit registers that are used.
  ShiftPWM.SetAmountOfRegisters(numRegisters);

  // SetPinGrouping allows flexibility in LED setup.
  // If your LED's are connected like this: RRRRGGGGBBBBRRRRGGGGBBBB, use SetPinGrouping(4).
  ShiftPWM.SetPinGrouping(1); //This is the default, but I added here to demonstrate how to use the funtion

  ShiftPWM.Start(pwmFrequency, maxBrightness);
}





void serialdata()
{
  while (Serial.available() > 0)
  {
    char aChar = Serial.read();


    if (aChar == '\n') {
      //Parse here
      char *token = NULL;
      token = inData;

      if (strstr(inData, "$LED"))
      {
        //Serial.print("Found LED data: "); Serial.println(inData);
        char *p = inData;

        p = strchr(p, ',') + 1;
        pixNUM = atoi(p);
        pixNUM = constrain(pixNUM, 0, 125);
        p = strchr(p, ',') + 1;
        briNUM = atoi(p);
        briNUM = constrain(briNUM, 0, 255);

       // ShiftPWM.SetOne(Red, Green);


//        BTSerial.print("pixNUM: ");
//        BTSerial.println(pixNUM);
//        BTSerial.print("briNUM: ");
//        BTSerial.println(briNUM);

        /*
        p = strchr(p, ',')+1;
        Blue = atoi(p);
        Blue = constrain(Blue, 0, 255);
        p = strchr(p, ',')+1;
        LedON = atoi(p);
        p = strchr(p, ',')+1;
        LedOFF = atoi(p);
        mode = 0;
        */
      }
      else
      {
        Serial.println("Wrong command");
        mode = 0;
      }
      //End Parse
      index = 0;
      inData[index] = NULL;
    }
    else
    {
      inData[index] = aChar;
      index++;
      inData[index] = '\0'; //Keep NULL Terminated
    }

        ShiftPWM.SetOne(pixNUM, briNUM);


  }
}






void loop()
{

serialdata();



}

