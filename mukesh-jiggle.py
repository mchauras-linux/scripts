#!/usr/bin/python3

import pyautogui
import time

try:
    while True:
        for i in range(50,60):
            pyautogui.moveTo(i * 10, i * 10)
        time.sleep(30)
except:
    pass
