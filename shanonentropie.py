import math
from collections import Counter
import os

def shannon_entropy(data):
    if not data:
        return 0
    entropy = 0
    length = len(data)
    frequencies = Counter(data)
    for count in frequencies.values():
        p_x = count / length
        entropy -= p_x * math.log2(p_x)
    return entropy

def analyze_file(file_path):
    if not os.path.isfile(file_path):
        print(f"Datei '{file_path}' nicht gefunden.")
        return
    with open(file_path, 'rb') as file:
        content = file.read()
    entropy = shannon_entropy(content)
    print(f"Shannon-Entropie von '{file_path}': {entropy:.4f} bits/Byte")
    if entropy > 7.5:
        print("Hinweis: Die Datei ist wahrscheinlich verschlüsselt oder komprimiert.")
    else:
        print("Hinweis: Die Datei scheint nicht verschlüsselt zu sein.")

if __name__ == "__main__":
    analyze_file("text.txt")
