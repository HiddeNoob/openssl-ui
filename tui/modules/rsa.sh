#!/bin/bash

# RSA Anahtar Üretim Modülü - TUI

tui_generate_rsa() {
    # Anahtar boyutu seç
    boyut=$(whiptail --title "RSA Anahtar Boyutu" \
        --menu "Bit uzunluğunu seçin:" 15 60 3 \
        "2048" "Standart (Hızlı)" \
        "4096" "Yüksek Güvenlik (Orta)" \
        "8192" "Maksimum Güvenlik (Yavaş)" 3>&1 1>&2 2>&3)
    [ -z "$boyut" ] && return
    
    # Private key adı
    priv_name=$(whiptail --title "Özel Anahtar" \
        --inputbox "Private Key dosya adı:" 10 60 "private_key.pem" 3>&1 1>&2 2>&3)
    [ -z "$priv_name" ] && return
    
    # Public key adı
    pub_name=$(whiptail --title "Genel Anahtar" \
        --inputbox "Public Key dosya adı:" 10 60 "public_key.pem" 3>&1 1>&2 2>&3)
    [ -z "$pub_name" ] && return
    
    # Anahtarları oluştur
    {
        openssl genrsa -out "$priv_name" $boyut 2>&1
        openssl rsa -in "$priv_name" -pubout -out "$pub_name" 2>&1
    } > /dev/null 2>&1
    
    if [ -f "$priv_name" ] && [ -f "$pub_name" ]; then
        whiptail --title "Başarılı" \
            --msgbox "RSA anahtarları oluşturuldu:\n\nPrivate: $priv_name\nPublic: $pub_name\n\nBoyut: $boyut bit" 14 65
    else
        whiptail --title "Hata" --msgbox "Anahtar oluşturma başarısız!" 8 50
    fi
}
