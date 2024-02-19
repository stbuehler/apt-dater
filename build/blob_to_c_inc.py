# xxd -name isn't supported on older versions, just implement it manually

import sys
import os.path
import re

infile = sys.argv[1]
outfile = sys.argv[2]

with open(infile, mode="rb") as f:
    data = f.read()

name = os.path.basename(infile)
name = re.sub('[^a-zA-Z0-9_]+', '_', name)

with open(outfile, mode="w") as f:
    f.write(f"unsigned char {name}[] = {{\n")
    pos = 0
    data_len = len(data)
    while pos < data_len:
        rem = data_len - pos
        chunk_size = min(rem, 12)
        chunk = data[pos:pos+chunk_size]
        pos += chunk_size
        line = "  " + ", ".join(f"0x{d:02x}" for d in chunk)
        if pos < data_len:
            line += ","
        f.write(line + "\n")
    f.write("};\n")
    f.write(f"unsigned int {name}_len = {data_len};\n")
