#!/bin/bash
sudo su root <<EOF
 echo 3 >/proc/sys/vm/drop_caches
EOF

