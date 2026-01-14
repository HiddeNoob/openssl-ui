#!/bin/bash

# Base64 Encode/Decode Modülü

gui_base64_encode() {
    dosya=$(yad --file --title="Encode Edilecek Dosyayı Seç")
    [ $? -ne 0 ] && return
    
    cikti=$(yad --file --save --title="Base64 Dosya Adı" --filename="${dosya}.b64")
    [ $? -ne 0 ] && return
    
    openssl base64 -in "$dosya" -out "$cikti"
    
    if [ $? -eq 0 ]; then
        yad --info --title="Başarılı" --text="Dosya Base64 formatına dönüştürüldü:\n$cikti" --width=400
    else
        yad --error --title="Hata" --text="Encode işlemi başarısız!" --width=400
    fi
}

gui_base64_decode() {
    dosya=$(yad --file --title="Decode Edilecek Base64 Dosyasını Seç")
    [ $? -ne 0 ] && return
    
    cikti=$(yad --file --save --title="Çıktı Dosya Adı")
    [ $? -ne 0 ] && return
    
    openssl base64 -d -in "$dosya" -out "$cikti"
    
    if [ $? -eq 0 ]; then
        yad --info --title="Başarılı" --text="Base64 dosyası çözüldü:\n$cikti" --width=400
    else
        yad --error --title="Hata" --text="Decode işlemi başarısız!" --width=400
    fi
}
