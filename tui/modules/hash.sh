#!/bin/bash

# Hash Hesaplama Modülü - TUI

tui_calculate_hash() {
    # Dosya tarayıcıyla dosya seç
    dosya=$(file_browser "$(pwd)" "Hash Hesaplanacak Dosyayı Seç")
    
    if [ -z "$dosya" ] || [ ! -f "$dosya" ]; then
        whiptail --title "İptal" --msgbox "Dosya seçilmedi." 8 50
        return
    fi
    
    # Hash algoritması seç
    algoritma=$(whiptail --title "Algoritma Seç" \
        --menu "Hash Algoritması:" 15 60 4 \
        "md5" "MD5" \
        "sha1" "SHA1" \
        "sha256" "SHA256" \
        "sha512" "SHA512" 3>&1 1>&2 2>&3)
    [ -z "$algoritma" ] && return
    
    # Hash hesapla
    sonuc=$(openssl dgst -$algoritma "$dosya" 2>&1)
    
    if [ $? -eq 0 ]; then
        whiptail --title "Hash Sonucu ($algoritma)" \
            --msgbox "Dosya: $dosya\n\n$sonuc" 14 78
    else
        whiptail --title "Hata" --msgbox "Hash hesaplama başarısız!" 8 50
    fi
}
