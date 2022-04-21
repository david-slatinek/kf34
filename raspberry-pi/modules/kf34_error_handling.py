import logging
import subprocess


logging.basicConfig(level=logging.ERROR, filename='errors.log', filemode='a', format='%(asctime)s---%(message)s',
                    datefmt='%d.%m.%Y %H:%M:%S')

def handle_error(error):
    logging.error(error)
    subprocess.Popen(["/home/pi/.local/lib/python3.7/site-packages/led.py", "-e"])
    subprocess.Popen(["/home/pi/.local/lib/python3.7/site-packages/email.sh", error])
