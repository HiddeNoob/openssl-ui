#!/bin/bash

# Dosya Şifreleme Modülü

gui_encrypt_file() {
    dosya=$(yad --file --title="Şifrelenecek Dosyayı Seç")
    [ $? -ne 0 ] && return
    
    cikti=$(yad --file --save --title="Şifrelenmiş Dosya Adı" --filename="${dosya}.enc")
    [ $? -ne 0 ] && return
    
    parola=$(yad --entry --title="Parola" --text="Dosya için parola giriniz:" --hide-text)
    [ $? -ne 0 ] && return
    [ -z "$parola" ] && yad --error --text="Parola boş olamaz!" && return
    
    openssl enc -aes-256-cbc -salt -pbkdf2 -in "$dosya" -out "$cikti" -pass pass:"$parola" 2>&1
    
    if [ $? -eq 0 ]; then
        yad --info --title="Başarılı" --text="Dosya başarıyla şifrelendi:\n$cikti" --width=400
    else
        yad --error --title="Hata" --text="Şifreleme başarısız!" --width=400
    fi
}

gui_decrypt_file() {
    dosya=$(yad --file --title="Şifresi Çözülecek Dosyayı Seç")
    [ $? -ne 0 ] && return
    
    cikti=$(yad --file --save --title="Çözülmüş Dosya Adı")
    [ $? -ne 0 ] && return
    
    parola=$(yad --entry --title="Parola" --text="Dosya parolasını giriniz:" --hide-text)
    [ $? -ne 0 ] && return
    
    openssl enc -aes-256-cbc -d -pbkdf2 -in "$dosya" -out "$cikti" -pass pass:"$parola" 2>&1
    
    if [ $? -eq 0 ]; then
        yad --info --title="Başarılı" --text="Dosya şifresi başarıyla çözüldü:\n$cikti" --width=400
    else
        yad --error --title="Hata" --text="Şifre çözme başarısız!" --width=400
    fi
}
