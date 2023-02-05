# Basic syntax quick reference

# `for`
```bash
#!/bin/bash

FILES=( "file1" "file2" "file3" )

function create_file() {
    local FNAME="${1}"
    local PERMISSIONS="${2}"
    touch "${FNAME}"
    chmod "${PERMISSIONS}" "${FNAME}"
    ls -l "${FNAME}"
}

for ELEMENT in ${FILES[@]}; do
    create_file "${ELEMENT}" "a+x"
done
exit 0
```

# `switch`
```bash
VAR=10
case $VAR in
    1) echo "1" ;;
    2) echo "2" ;;
    *) echo "What is this var?"
       exit 1
esac
```

# `while`
```bash
#!/bin/bash
cnt=1
while [ ${cnt} -lt 9 ]; do
    echo "cnt value: ${cnt}"
    ((CTR++))
done
```