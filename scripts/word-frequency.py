#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p pastel

import sys
import re
import os
import argparse
import subprocess
import statistics
import shutil

GRADIENT = [
    "#ff0000",
    "#fc0800",
    "#fa1500",
    "#f71d00",
    "#f52900",
    "#f23000",
    "#f03c00",
    "#ed4300",
    "#ea4e00",
    "#e85500",
    "#e55c00",
    "#e26600",
    "#e06c00",
    "#dd7600",
    "#db7c00",
    "#d88500",
    "#d68b00",
    "#d39400",
    "#d19900",
    "#cea100",
    "#cba600",
    "#c8aa00",
    "#c6b200",
    "#c3b600",
    "#c1be00",
    "#bbbe00",
    "#afbc00",
    "#a7b900",
    "#9bb700",
    "#93b400",
    "#8bb100",
    "#80ae00",
    "#78ac00",
    "#6ea900",
    "#67a700",
    "#5da400",
    "#56a200",
    "#4d9f00",
    "#469d00",
    "#3e9a00",
    "#389700",
    "#329500",
    "#299200",
    "#248f00",
    "#1c8d00",
    "#178a00",
    "#108800",
    "#0b8500",
    "#048300",
    "#008000",
]


def get_gradient(steps) -> list[str] | None:
    global GRADIENT
    return GRADIENT[:steps]


assert shutil.which("pastel")

# from colormap import rgb2hex, hex2rgb
#
# def get_gradient(start_color, end_color, steps):
#     start_rgb = hex2rgb(start_color)
#     end_rgb = hex2rgb(end_color)
#     gradient = []
#
#     for step in range(steps):
#         interp = step / (steps - 1)
#         r = int(start_rgb[0] + interp * (end_rgb[0] - start_rgb[0]))
#         g = int(start_rgb[1] + interp * (end_rgb[1] - start_rgb[1]))
#         b = int(start_rgb[2] + interp * (end_rgb[2] - start_rgb[2]))
#         gradient.append(rgb2hex(r, g, b))
#
#     return gradient


# def get_gradient(n: int) -> list[str] | None:
#     print(f"{n=}")
#     output = subprocess.run(
#         f"{shutil.which('pastel')} gradient red green -s HSL -n {n} | pastel format hex",
#         shell=True,
#         capture_output=True,
#         text=True,
#     )
#
#     print(f"{output=}")
#
#     # Check if the command was successful
#     if output.returncode == 0:
#         # Split the output into lines and store in a list
#         output_lines = output.stdout.splitlines()
#         # Print the list
#         return output_lines
#     else:
#         # If the command failed, print the error message
#         print("Error:", output.stderr)


def hex_to_ansi(hex_color):
    # Remove '#' if present
    hex_color = hex_color.lstrip("#")

    # Convert hex to RGB
    r = int(hex_color[0:2], 16)
    g = int(hex_color[2:4], 16)
    b = int(hex_color[4:6], 16)

    # Compute ANSI color codes
    ansi_color = f"\033[38;2;{r};{g};{b}m"

    return ansi_color


# print(get_gradient(10))
# sys.exit(0)

parser = argparse.ArgumentParser()
parser.add_argument("-m", "--min-words", type=int, default=0)
parser.add_argument("-t", "--top", type=int)
parser.add_argument("--no-digits")
args = parser.parse_args()


dictionary: dict[str, int] = {}
word_regexp = (
    re.compile(r"\b(\D+)\b") if not args.no_digits else re.compile(r"\b(\w+)\b")
)

# word_regexp = re.compile(r"\b(\w+)\b")

for line in sys.stdin.readlines():
    line = line.strip()
    words = word_regexp.findall(line)
    for word in words:
        if word in dictionary:
            dictionary[word] += 1
        else:
            dictionary[word] = 1


total_words = sum(dictionary.values())

terminal_columns = int(os.get_terminal_size().columns)

max_word_length = max(len(word) for word in dictionary.keys())
max_count_length = len(str(max(dictionary.values())))
unique_word_lengths = set(dictionary.values())
unique_word_length = len(set(dictionary.values()))

word_count_to_gradient_index: dict[int, int] = {
    c: i for i, c in enumerate(sorted(unique_word_lengths, reverse=True))
}
# print(word_count_to_gradient_index)
# sys.exit(0)

# print(f"{unique_word_length = }")

gradient = get_gradient(unique_word_length)
# print(gradient)
#
# sys.exit(0)


# if args.top > 0:
#     for word in sorted(dictionary, key=dictionary.get, reverse=True)[: args.top]:
#         print(word, dictionary[word])
#         # if dictionary[word] >= args.min_words:
#     sys.exit(0)

GREEN = "\033[32m"
RESET = "\033[0m"
RED = "\033[31m"
YELLOW = "\033[33m"
BLUE = "\033[34m"

# print(f"{gradient=}")

N = len(dictionary) if args.top == 0 else args.top
# Print in sorted order by frequency
for word in sorted(dictionary, key=dictionary.get, reverse=True)[:N]:
    if dictionary[word] >= args.min_words:
        count = dictionary[word]
        # print(f"{word:>{max_word_length}} {count:<}")
        percentage = count / total_words * 100
        text = (
            f"{word:>{max_word_length}} {count:{max_count_length}} ({percentage:.2f}%)"
        )
        width_available = terminal_columns - len(text)
        histogram_length: int = min(count, width_available) - 1
        histogram_bar = "+" * histogram_length
        # histogram_bar = "+" * (int(count / total_words * width_available))

        color = gradient[word_count_to_gradient_index[count]]
        print(f"{color=}")
        color = hex_to_ansi(color)
        # color = hex_to_ansi(gradient[dictionary[word] - 1])
        # print(f"{YELLOW}{text}{RESET} {color}{histogram_bar}{RESET}")
        print(f"{text} {color}{histogram_bar}{RESET}")

        # print(f"{word:>{max_word_length}} {count:<}")
        # print(word, dictionary[word])


print(f"{YELLOW}------- STATS -------{RESET}")

mean: float = statistics.mean(dictionary.values())
median: float = statistics.median(dictionary.values())
stdev: float = statistics.stdev(dictionary.values())
variance: float = statistics.variance(dictionary.values())

total: int = total_words

print(f"{total    = : >10}")
print(f"{mean     = : >10.2f}")
print(f"{median   = : >10.2f}")
print(f"{stdev    = : >10.2f}")
print(f"{variance = : >10.2f}")
