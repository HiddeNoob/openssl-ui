#!/bin/bash

# Dosya Şifreleme Modülü - TUI

tui_encrypt_file() {
    # Dosya tarayıcıyla dosya seç
    dosya=$(file_browser "$(pwd)" "Şifrelenecek Dosyayı Seç")
    
    if [ -z "$dosya" ] || [ ! -f "$dosya" ]; then
        whiptail --title "İptal" --msgbox "Dosya seçilmedi." 8 50
        return
    fi
    
    # Çıktı dosyası için isim al
    cikti=$(whiptail --title "Şifrelenmiş Dosya Adı" \
        --inputbox "Çıktı dosyası adı:" 10 60 "${dosya}.enc" 3>&1 1>&2 2>&3)
    [ -z "$cikti" ] && return
    
    # Parola al
    parola=$(whiptail --title "Parola" \
        --passwordbox "Dosya için güçlü bir parola girin:" 10 60 3>&1 1>&2 2>&3)
    [ -z "$parola" ] && whiptail --title "Hata" --msgbox "Parola boş olamaz!" 8 50 && return
    
    # Şifreleme işlemini gerçekleştir
    openssl enc -aes-256-cbc -salt -pbkdf2 -in "$dosya" -out "$cikti" -pass pass:"$parola" 2>&1
    
    if [ $? -eq 0 ]; then
        whiptail --title "Başarılı" --msgbox "Dosya başarıyla şifrelendi:\n\n$cikti" 12 60
    else
        whiptail --title "Hata" --msgbox "Şifreleme başarısız!" 8 50
    fi
}

tui_decrypt_file() {
    # Şifrelenmiş dosyayı seç
    dosya=$(file_browser "$(pwd)" "Şifresi Çözülecek Dosyayı Seç")
    
    if [ -z "$dosya" ] || [ ! -f "$dosya" ]; then
        whiptail --title "İptal" --msgbox "Dosya seçilmedi." 8 50
        return
    fi
    
    # Çıktı dosyası için isim al
    cikti=$(whiptail --title "Çözülmüş Dosya Adı" \
        --inputbox "Çıktı dosyası adı:" 10 60 "decrypted_file" 3>&1 1>&2 2>&3)
    [ -z "$cikti" ] && return
    
    # Parola al
    parola=$(whiptail --title "Parola" \
        --passwordbox "Dosya parolasını girin:" 10 60 3>&1 1>&2 2>&3)
    [ -z "$parola" ] && return
    
    # Şifre çözme işlemini gerçekleştir
    openssl enc -aes-256-cbc -d -pbkdf2 -in "$dosya" -out "$cikti" -pass pass:"$parola" 2>&1
    
    if [ $? -eq 0 ]; then
        whiptail --title "Başarılı" --msgbox "Dosya şifresi başarıyla çözüldü:\n\n$cikti" 12 60
    else
        whiptail --title "Hata" --msgbox "Şifre çözme başarısız!\nParola yanlış veya dosya bozuk olabilir." 10 60
    fi
}
