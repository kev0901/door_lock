#include <Servo.h>

Servo motor1;

void setup() {
  Serial.begin(9600);
  motor1.attach(9);
}
void loop() {
  if (Serial.available() > 0) {
    String data = Serial.readStringUntil('\n');
    Serial.print("You sent me: ");
    Serial.println(data);
    if(data=="up") {
        for(int position=0;position<180;position+=2)
        {
          motor1.write(position);
          delay(20);
        }
        for(int position=180;position>=0;position-=2)
        {
          motor1.write(position);    
          delay(20);
        }
        motor1.write(0);
        Serial.println("uup~~");
        delay(20);
    }
    else{
        motor1.write(0);
        delay(20);
        Serial.println("nothin");
    }
  }
}