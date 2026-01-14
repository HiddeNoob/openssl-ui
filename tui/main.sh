#!/bin/bash

# TUI Ana Program
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Whiptail kontrolü
if ! command -v whiptail &> /dev/null; then
    echo "Bu script 'whiptail' aracı gerektirir. Lütfen yükleyin (örn: sudo apt install whiptail)"
    exit 1
fi

# Modülleri yükle
source "$SCRIPT_DIR/modules/encryption.sh"
source "$SCRIPT_DIR/modules/hash.sh"
source "$SCRIPT_DIR/modules/rsa.sh"
source "$SCRIPT_DIR/modules/base64.sh"
source "$SCRIPT_DIR/utils/file_browser.sh"

# Ana menü döngüsü
while true; do
    secim=$(whiptail --clear \
        --backtitle "OpenSSL TUI - Terminal Arayüzü" \
        --title "Ana Menü" \
        --menu "Yapmak istediğiniz işlemi seçin:" \
        20 70 12 \
        "1" "Dosya Şifrele (AES-256)" \
        "2" "Dosya Şifresini Çöz" \
        "3" "Hash Hesapla" \
        "4" "RSA Anahtar Oluştur" \
        "5" "Base64 Encode" \
        "6" "Base64 Decode" \
        "0" "Çıkış" \
        3>&1 1>&2 2>&3)
    
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
        clear
        exit 0
    fi
    
    case "$secim" in
        "0")
            clear
            exit 0
            ;;
        "1")
            tui_encrypt_file
            ;;
        "2")
            tui_decrypt_file
            ;;
        "3")
            tui_calculate_hash
            ;;
        "4")
            tui_generate_rsa
            ;;
        "5")
            tui_base64_encode
            ;;
        "6")
            tui_base64_decode
            ;;
    esac
done
