import subprocess

cmd = 'readelf -V lib_lightgbm.so | grep -E "Link: 4|Name: GLIBC_2.14"'
a, b = subprocess.check_output(cmd, shell=True, text=True).splitlines()
a = int(a.split()[3], base=16)
b = int(b.split()[0].strip(':'), base=16)
c = a + b + 0x4
print(a, b, c)

shell = f'''\
for addr in {hex(c)} ; do printf '\x02' | dd conv=notrunc of=./lib_lightgbm.so bs=1 seek=$((addr)) ; done
'''
subprocess.run(shell, shell=True)

cmd2 = 'readelf -V lib_lightgbm.so | grep "Name: GLIBC_2.14"'
flags = subprocess.check_output(cmd2, shell=True, text=True).split()[4]
assert flags == 'WEAK'
print('GLIBC_2.14 Flags set to WEAK success')
