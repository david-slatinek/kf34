#!/usr/bin/env python3

from sys import argv
import getopt
from gpiozero import LED, Buzzer
from signal import pause, signal, SIGTERM, SIGINT

led_pin, buzzer_pin = 18, 27
led = LED(led_pin)
buzzer = Buzzer(buzzer_pin)


def handler(signal_received=None, frame=None):
    led.off()
    buzzer.off()
    write_status("OFF\n")


def write_status(status:str):
    with open("status.txt", "w") as f:
        f.write(status)


def usage():
    print("Name")
    print("\tManage Raspberry Pi LED and buzzer")

    print("Flags")
    print("-h, --help")
    print("\tPrint help")
    print("-e, --enable")
    print("\tEnable LED and buzzer")
    print("-d, --disable")
    print("\tDisable LED and buzzer")
    print("-L <number>, --led <number>")
    print("\tDefine LED pin number. Default is 18")
    print("-b <number>, --buzzer <number>")
    print("\tDefine buzzer pin number. Default is 27")

    print("Usage")
    print("\t./led.py hedL:b:")


def validate_pin(flag: str, value: str) -> int:
    pin = -1
    try:
        pin = int(value)
    except ValueError:
        print(f"{flag} argument has to be a number")
        exit(1)
    else:
        if pin < 1 or pin > 40:
            print("Invalid pin number")
            exit(1)
    return pin


if __name__ == "__main__":
    signal(SIGTERM, handler)
    signal(SIGINT, handler)

    opts = []
    e_flag, d_flag = False, False

    try:
        opts, _ = getopt.getopt(argv[1:], "hedL:b:", ["help", "enable", "disable", "led=", "buzzer="])
    except getopt.GetoptError:
        usage()
        exit(1)

    if opts:
        for opt, arg in opts:
            if opt in ("-h", "--help"):
                usage()
                exit()
            elif opt in ("-e", "--enable"):
                e_flag = True
            elif opt in ("-d", "--disable"):
                d_flag = True
            elif opt in ("-L", "--led"):
                led_pin = validate_pin("-L", arg)
            elif opt in ("-b", "--buzzer"):
                buzzer_pin = validate_pin("-b", arg)
    else:
        usage()
        exit(1)

    if led_pin == buzzer_pin:
        print("LED and buzzer pin can't be the same")
        exit(1)

    if not e_flag and not d_flag:
        print("Use -e or -d flag")
        exit(1)

    if e_flag and d_flag:
        print("Flags -e and -d can't be combined")
        exit(1)

    if e_flag:
        led.on()
        buzzer.on()
        write_status("ON\n")
        pause()
    elif d_flag:
        handler()
