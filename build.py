import subprocess
import os

DEVKITBIN = 'C:/devkitPro/devkitARM/bin'
LDSCRIPT = 'fe8.ld'
ASM = 'fe8.asm'
OBJ = 'fe8.obj'
ELF = 'fe8.elf'
INROM = 'fe8.gba'
OUTROM = 'fe8_negative_growth.gba'
UPS = 'fe8_negative_growth.ups'

SECTIONS = {
    'get_stat_increase': 0x0802B9BC,
    'level_up_caps': 0x0802BF24,
    'promotion': 0x080291F6,
    'patches': 0x08B2A604,
}

def run(args):
    print('+ {}'.format(' '.join(args)))
    subprocess.check_call(args)

# Create linker script
with open(LDSCRIPT, 'w') as fp:
    fp.write('SECTIONS {\n')
    for name, addr in SECTIONS.items():
        fp.write('  {} 0x{:08x} : {{}}\n'.format(
            name, addr))
    fp.write('}\n')

# Create elf binary
run([os.path.join(DEVKITBIN, 'arm-none-eabi-as.exe'),
     '-mcpu=arm7tdmi',
     ASM,
     '-o', OBJ])
run([os.path.join(DEVKITBIN, 'arm-none-eabi-ld.exe'),
     '-T', LDSCRIPT,
     OBJ,
     '-o', ELF])

# Disassemble
run([os.path.join(DEVKITBIN, 'arm-none-eabi-objdump.exe'),
     '-D',
     ELF])

# Dump sections to raw binary
for section in SECTIONS:
    run([os.path.join(DEVKITBIN, 'arm-none-eabi-objcopy.exe'),
         '--dump-section', '{}=fe8_{}.bin'.format(section, section),
         ELF])

# Patch the rom!
with open(INROM, 'rb') as fp:
    rom = bytearray(fp.read())
for name, addr in SECTIONS.items():
    with open('fe8_{}.bin'.format(name), 'rb') as fp:
        patch = fp.read()
    rom_addr = addr - 0x08000000
    rom[rom_addr:rom_addr + len(patch)] = patch
with open(OUTROM, 'wb') as fp:
    fp.write(rom)

# Create patch files
run(['ups.exe', 'diff',
     '-b', INROM,
     '-m', OUTROM,
     '-o', UPS])

# Remove intermediate files
os.remove(LDSCRIPT)
os.remove(OBJ)
os.remove(ELF)
for name in SECTIONS.keys():
    os.remove('fe8_{}.bin'.format(name))
