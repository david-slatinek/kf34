#!/usr/bin/env python3

if __name__ == "__main__":
    try:
        with open("status.txt") as f:
            print(f"Status: {f.readline()}", end="")
    except IOError as error:
        print(error)
