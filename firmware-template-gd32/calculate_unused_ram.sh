#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: $0 <size_file> <linker_script>"
  exit 1
fi

size_file="$1"
linker_script="$2"

used_stack=$(grep ".stack" "$size_file" | awk '{print $2}')
used_tcmsram=$(grep ".tcmsram" "$size_file" | awk '{print $2}')
used_heap=$(grep ".heap" "$size_file" | awk '{print $2}')

total_tcmsram=$(grep "TCMSRAM (rw)" "$linker_script" | awk '{print $NF}' | sed 's/K$//' | awk '{printf "%d", $0 * 1024}')
unused_tcmsram=$(( $(echo $total_tcmsram) - $(echo $used_stack) - $(echo $used_tcmsram) - $(echo $used_heap) ))

used_data=$(grep '.data' "$size_file" | tail -n 1 | awk '{print $2}')
used_bss=$(grep ".bss" "$size_file" | awk '{print $2}')

total_ram=$(grep "RAM (xrw)" "$linker_script" | awk '{print $NF}' | sed 's/K$//' | awk '{printf "%d", $0 * 1024}')
unused_ram=$(( $(echo $total_ram) - $(echo $used_data)  ))

used_ramadd=$(grep ".ramadd" "$size_file" | awk '{print $2}')

total_ramadd=$(grep "RAMADD (xrw)" "$linker_script" | awk '{print $NF}' | sed 's/K$//' | awk '{printf "%d", $0 * 1024}')
unused_ramadd=$(( $(echo $total_ramadd) - $(echo $used_ramadd) - $(echo $used_bss)))

cat $1
echo "TCMSRAM $total_tcmsram bytes, Unused TCMSRAM: $unused_tcmsram bytes"
echo "RAM $total_ram bytes, Unused: $unused_ram bytes"
echo "RAMADD $total_ramadd bytes, Unused: $unused_ramadd bytes"
echo 