#!/bin/bash

# GUI Ana Program
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# YAD kontrolü
if ! command -v yad &> /dev/null; then
    echo "Hata: Bu script 'yad' (Yet Another Dialog) aracı gerektirir."
    echo "Lütfen yükleyin"
    exit 1
fi

# Modülleri yükle
source "$SCRIPT_DIR/modules/encryption.sh"
source "$SCRIPT_DIR/modules/hash.sh"
source "$SCRIPT_DIR/modules/rsa.sh"
source "$SCRIPT_DIR/modules/base64.sh"

# Ana menü döngüsü
while true; do
    secim=$(yad --list \
        --title="OpenSSL GUI - Gelişmiş SSL Araçları" \
        --width=800 \
        --height=600 \
        --column="İşlem" \
        --column="Açıklama" \
        "Dosya Şifrele" "AES-256 ile dosya şifrele" \
        "Dosya Şifresini Çöz" "Şifrelenmiş dosyayı çöz" \
        "Hash Hesapla" "Dosya hash değerini hesapla" \
        "RSA Anahtar Oluştur" "RSA anahtar çifti oluştur" \
        "Base64 Encode" "Dosyayı Base64 formatına dönüştür" \
        "Base64 Decode" "Base64 dosyasını çöz" \
        --button="Çıkış:1" \
        --button="Seç:0")
    
    [ $? -ne 0 ] && exit 0
    
    secim=$(echo "$secim" | cut -d'|' -f1)
    
    case "$secim" in
        "Dosya Şifrele")
            gui_encrypt_file
            ;;
        "Dosya Şifresini Çöz")
            gui_decrypt_file
            ;;
        "Hash Hesapla")
            gui_calculate_hash
            ;;
        "RSA Anahtar Oluştur")
            gui_generate_rsa
            ;;
        "Base64 Encode")
            gui_base64_encode
            ;;
        "Base64 Decode")
            gui_base64_decode
            ;;
    esac
done
