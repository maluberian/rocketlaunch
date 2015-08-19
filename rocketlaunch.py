#!/usr/bin/python

import RPi.GPIO as GPIO
import time
import scratch

GATE_PIN = 40 
LAUNCH_TIME = 10
DONE = False

GPIO.setmode(GPIO.BOARD)
GPIO.setup(GATE_PIN, GPIO.OUT)
GPIO.output(GATE_PIN, GPIO.LOW)

while DONE == False:
	try:
		s = scratch.Scratch()
		if s.connected:
			print "connected to Scratch..."
			s.broadcast('go')
			print "Go sent."
	
			(key, msg) = s.receive()	
			print "received [{0}]".format(msg)
			if msg == 'launch':
				GPIO.output(GATE_PIN, GPIO.HIGH)
				time.sleep(LAUNCH_TIME)
				GPIO.output(GATE_PIN, GPIO.LOW)
				DONE = True
		else:
			print "no connection to Scratch! sleeping..."
			time.sleep(1)
			s.connect()

	except scratch.ScratchError:
		print "no connection to Scratch..."
		time.sleep(5)
s.disconnect()
GPIO.cleanup()
