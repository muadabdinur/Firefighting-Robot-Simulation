Serial Wack a Mole
//Program title: Relflex tester
//This program creates a wack a mole type game
//when only a single green LED flashes press the 
//button and the blue LED will light up
int clockPin = 4;
int latchPin = 5;
int dataPin = 6;
 
bool buttonState = false;
 
void setup() 
{
  pinMode(latchPin, OUTPUT);
  pinMode(dataPin, OUTPUT);  
  pinMode(clockPin, OUTPUT);
  pinMode(2,OUTPUT); //declare pin 2 as output
  pinMode(3,INPUT_PULLUP); //button pin input
  
  attachInterrupt(digitalPinToInterrupt(3), buttonPress, CHANGE);
  //button used to interrupt circuit
}
 
void loop() 
{
  delay(2000);
  for (int i = 0; i < 8; i++)
  {
    updateShiftRegister(B00000000); //sets all lights off
    byte currentled = 0;  //sets a bit of a numerical value
    bitSet(currentled, i);
    delay(1000);
      
 
    if(i == 1 || i == 3 || i == 6) //flash green
    {
      	
        flashing(500,B01001010); //give time to press button
        buttonState = false;
        flashing(1000,currentled);
      
      	if(buttonState)
        {
        	digitalWrite(2,HIGH);//success turn led on
            delay(500);
            digitalWrite(2,LOW);//turn off
          	break;
        }
    }else{
      	flashing(500,B10110101); //flash red
      	//give time to press button
      	buttonState = false;
      	flashing(1000,currentled);
    }
    
  }
}

void flashing(int dTime, byte leds){
    //creates a function for Delay time and byte leds
  	updateShiftRegister(leds);    
    delay(dTime);
	updateShiftRegister(B00000000);
}
 
void updateShiftRegister(byte ledVals)
{
   digitalWrite(latchPin, LOW);
   shiftOut(dataPin, clockPin, MSBFIRST, ledVals);
   digitalWrite(latchPin, HIGH);
}

void buttonPress()
{
  buttonState = true;
}
