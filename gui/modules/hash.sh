#!/bin/bash

# Hash Hesaplama Modülü

gui_calculate_hash() {
    dosya=$(yad --file --title="Hash Hesaplanacak Dosyayı Seç")
    [ $? -ne 0 ] && return
    
    algoritma=$(yad --list \
        --title="Hash Algoritması Seç" \
        --column="Algoritma" \
        "md5" "sha1" "sha256" "sha512" \
        --height=300)
    [ $? -ne 0 ] && return
    
    algoritma=$(echo "$algoritma" | cut -d'|' -f1)
    
    sonuc=$(openssl dgst -$algoritma "$dosya")
    hash_degeri=$(echo "$sonuc" | awk '{print $NF}')
    
    yad --entry \
        --title="Hash Sonucu ($algoritma)" \
        --entry-text="$hash_degeri" \
        --width=600 \
        --button="Kapat:0"
}
