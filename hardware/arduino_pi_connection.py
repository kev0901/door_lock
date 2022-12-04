#!/usr/bin/env python3
import serial
import time
if __name__ == '__main__':
    ser = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
    ser.reset_input_buffer()
    while True:
        #ser.write(b"Hello from Raspberry Pi!\n")
        line=input()
        line=(line+"\n")
        line=line.encode('utf-8')
        ser.write(line);
        result = ser.readline().decode('utf-8').rstrip()
        print(line)
        print(result)
        #time.sleep(1)
