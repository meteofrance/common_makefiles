import os
import sys


def main(path):
    forced = {}
    res = []
    if os.path.isfile(path):
        with open(path, "r") as f:
            lines = [x.strip() for x in f.readlines()]
        for line in lines:
            name = ""
            for letter in line:
                if letter not in ("~", "=", "<", ">", "!", " "):
                    name = name + letter
                else:
                    break
            if name.strip() != "":
                forced[name.strip()] = line.strip()

    for line in sys.stdin:
        package = line.split("=")[0].strip()
        if package in forced:
            res.append(forced[package])
        else:
            res.append(line.strip())
    return res


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("ERROR: you have to provide a forced-requirements.txt file as argument")
        sys.exit(1)
    res = main(sys.argv[1])
    for line in res:
        print(line)
