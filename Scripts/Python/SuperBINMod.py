import struct
import sys

# Paths for editing
MODIFIED_INPUT_FILE = input('Modified input file:')
SIGNED_OUTPUT_FILE = input('Signed output directory:')

with open(MODIFIED_INPUT_FILE, "rb") as f:
    data = f.read()

if len(data) < 12:
    print("Error: File is too small.")
    sys.exit()

# Strip the old 12-byte footer to isolate the raw body bytes
body = data[:-12]

print("Calculating Generalplus 32-bit Additive Sum over modified body...")

# Calculate the additive sum across the modified data blocks
additive_sum = 0
for i in range(0, len(body), 4):
    chunk = body[i:i+4]
    # Handle any hanging bytes at the end of the alignment boundary
    if len(chunk) == 4:
        additive_sum = (additive_sum + struct.unpack("<I", chunk)[0]) & 0xFFFFFFFF
    else:
        # Pad trailing partial chunks with zeros to maintain 32-bit width
        padded_chunk = chunk + b'\x00' * (4 - len(chunk))
        additive_sum = (additive_sum + struct.unpack("<I", padded_chunk)[0]) & 0xFFFFFFFF

print(f"New Checksum Value: {hex(additive_sum)}")

# Rebuild the footer exactly as the GPL32690 processor expects it:
# Word 1: Fixed Magic ID (0x5abf57b2)
# Word 2: Fixed Identifier (0x30c1d08b)
# Word 3: Dynamic Calculated Additive Sum
new_footer = struct.pack("<III", 0x5ABF57B2, 0x30C1D08B, additive_sum)

# Reattach the signed footer to the modified body payload
final_binary = body + new_footer

with open(SIGNED_OUTPUT_FILE, "wb") as out:
    out.write(final_binary)

print(f"[+] Validation Completed! Output saved to: {SIGNED_OUTPUT_FILE}")
