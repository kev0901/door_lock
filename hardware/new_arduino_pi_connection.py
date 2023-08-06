#!/usr/bin/env python3
import serial
import time
from flask import Flask

app = Flask(__name__)

ser = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
ser.reset_input_buffer()

def open(): 
    line="up"
    line=(line+"\n")
    line=line.encode('utf-8')
    ser.write(line);
    result = ser.readline().decode('utf-8').rstrip()
    print('line ')
    print(line)
    print('result ')
    print(result)

@app.route('/unlock', methods=['POST'])
def unlock():
    open()
    return ('Unlocked!')

@app.route('/')
def hi():
    return ('hi!')

if __name__ == '__main__':
    app.run(host='192.168.35.214',port=8080)


