#!/bin/bash

# Base64 Encode/Decode Modülü - TUI

tui_base64_encode() {
    # Dosya tarayıcıyla dosya seç
    dosya=$(file_browser "$(pwd)" "Encode Edilecek Dosyayı Seç")
    
    if [ -z "$dosya" ] || [ ! -f "$dosya" ]; then
        whiptail --title "İptal" --msgbox "Dosya seçilmedi." 8 50
        return
    fi
    
    # Çıktı dosyası adı
    cikti=$(whiptail --title "Çıktı Dosyası" \
        --inputbox "Base64 dosya adı:" 10 60 "${dosya}.b64" 3>&1 1>&2 2>&3)
    [ -z "$cikti" ] && return
    
    # Base64 encode işlemi
    openssl base64 -in "$dosya" -out "$cikti" 2>&1
    
    if [ $? -eq 0 ]; then
        whiptail --title "Başarılı" \
            --msgbox "Dosya Base64 formatına dönüştürüldü:\n\n$cikti" 10 60
    else
        whiptail --title "Hata" --msgbox "Encode işlemi başarısız!" 8 50
    fi
}

tui_base64_decode() {
    # Base64 dosyasını seç
    dosya=$(file_browser "$(pwd)" "Decode Edilecek Base64 Dosyasını Seç")
    
    if [ -z "$dosya" ] || [ ! -f "$dosya" ]; then
        whiptail --title "İptal" --msgbox "Dosya seçilmedi." 8 50
        return
    fi
    
    # Çıktı dosyası adı
    cikti=$(whiptail --title "Çıktı Dosyası" \
        --inputbox "Çözülmüş dosya adı:" 10 60 "decoded_output" 3>&1 1>&2 2>&3)
    [ -z "$cikti" ] && return
    
    # Base64 decode işlemi
    openssl base64 -d -in "$dosya" -out "$cikti" 2>&1
    
    if [ $? -eq 0 ]; then
        whiptail --title "Başarılı" \
            --msgbox "Base64 dosyası çözüldü:\n\n$cikti" 10 60
    else
        whiptail --title "Hata" --msgbox "Decode işlemi başarısız!" 8 50
    fi
}
