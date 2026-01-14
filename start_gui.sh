#!/bin/bash

# OpenSSL GUI Launcher
# Yeni modüler yapıya yönlendirme

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# GUI ana programını çalıştır
exec bash "$SCRIPT_DIR/gui/main.sh"
