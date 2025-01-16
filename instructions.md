
- add to alire.toml:
```
[[depends-on]]
gnat_riscv64_elf = "*"
bare_runtime = "*"
hal = "*"
```

- [TODO] add to alire.toml
```
[gpr-set-externals]
BARE_RUNTIME_SWITCHES = "-march=rv32i2p0_m -mabi=ilp32 -D__vexriscv__"
```

- add `with "bare_runtime.gpr";` to neorv32.gpr:

```
for Languages use ("Ada", "ASM_CPP", "C");

for Target use "riscv64-elf";
for Runtime ("Ada") use Bare_Runtime'Runtime ("Ada");
```

svd files
- neorv32 provides svd file
`svd2ada -o src/svd src/svd/neorv32.svd`

- startup-gen 
`startup-gen -P neorv32.gpr -l link.ld -s crt0.S`

- elf to bin
`riscv64-elf-objcopy -O binary bin/bios bin/bios.bin`

- image_gen
`image_gen -app_bin bin/bios.bin bin/bios.exe`


gtkterm
- Config, CR LF Auto
- 19200
- Choice: u
- Ctrl + Shift + R
- Choose bios.exe
- Choice: e

