#!/bin/bash

# RSA Anahtar Üretim Modülü

gui_generate_rsa() {
    form_data=$(yad --form \
        --title="RSA Anahtar Parametreleri" \
        --field="Anahtar Boyutu:CB" "2048!4096!8192" \
        --field="Private Key Dosya Adı" "private_key.pem" \
        --field="Public Key Dosya Adı" "public_key.pem")
    
    [ $? -ne 0 ] && return
    
    boyut=$(echo "$form_data" | cut -d'|' -f1)
    private_key=$(echo "$form_data" | cut -d'|' -f2)
    public_key=$(echo "$form_data" | cut -d'|' -f3)
    
    # İşlemi gösteren ilerleme çubuğu
    {
        echo "# Private Key oluşturuluyor ($boyut bit)..."
        openssl genrsa -out "$private_key" $boyut 2>/dev/null
        
        echo "# Public Key çıkartılıyor..."
        openssl rsa -in "$private_key" -pubout -out "$public_key" 2>/dev/null
        
        echo "100"
    } | yad --progress --pulsate --title="İşlem Sürüyor" --text="Lütfen bekleyin..." --auto-close --no-buttons --width=400
    
    if [ -f "$private_key" ] && [ -f "$public_key" ]; then
        yad --info --title="Başarılı" --text="RSA anahtar çifti oluşturuldu:\n\nPrivate: $private_key\nPublic: $public_key" --width=400
    else
        yad --error --title="Hata" --text="Anahtar oluşturma başarısız!" --width=400
    fi
}
