#!/bin/bash

# Dosya Tarayıcı - TUI ile dizinlerde gezinme

file_browser() {
    local current_dir="${1:-$(pwd)}"
    local title="${2:-Dosya Seç}"
    
    while true; do
        # Dizin içeriğini listele
        local files=()
        local index=1
        
        # Üst dizin seçeneği (root değilse)
        if [ "$current_dir" != "/" ]; then
            files+=("$index" "../ (Üst Dizin)")
            ((index++))
        fi
        
        # Dizinleri listele
        while IFS= read -r item; do
            if [ -d "$current_dir/$item" ]; then
                files+=("$index" "[D] $item/")
                ((index++))
            fi
        done < <(ls -1 "$current_dir" 2>/dev/null | sort)
        
        # Dosyaları listele
        while IFS= read -r item; do
            if [ -f "$current_dir/$item" ]; then
                local size=$(du -h "$current_dir/$item" 2>/dev/null | cut -f1)
                files+=("$index" "[F] $item ($size)")
                ((index++))
            fi
        done < <(ls -1 "$current_dir" 2>/dev/null | sort)
        
        if [ ${#files[@]} -eq 0 ]; then
            whiptail --title "Hata" --msgbox "Dizin boş veya okunamıyor!" 8 60
            return 1
        fi
        
        # Seçim menüsünü göster
        local choice
        choice=$(whiptail --title "$title" \
            --menu "Dizin: $current_dir\n\nDosya seçin veya dizine girin:" \
            25 78 15 \
            "${files[@]}" \
            3>&1 1>&2 2>&3)
        
        local exit_status=$?
        if [ $exit_status -ne 0 ]; then
            return 1
        fi
        
        # Seçilen öğeyi bul
        local selected_index=1
        local selected_item=""
        
        for ((i=0; i<${#files[@]}; i+=2)); do
            if [ "${files[$i]}" == "$choice" ]; then
                selected_item="${files[$((i+1))]}"
                break
            fi
        done
        
        # Üst dizin seçimi
        if [[ "$selected_item" == "../ (Üst Dizin)" ]]; then
            current_dir=$(dirname "$current_dir")
            continue
        fi
        
        # Emoji ve fazladan karakterleri temizle
        selected_item=$(echo "$selected_item" | sed 's/^\[D\] //; s/^\[F\] //; s/ ([^)]*)$//')
        
        # Dizinse içine gir
        if [ -d "$current_dir/$selected_item" ]; then
            current_dir="$current_dir/$selected_item"
            continue
        fi
        
        # Dosyaysa seç
        if [ -f "$current_dir/$selected_item" ]; then
            echo "$current_dir/$selected_item"
            return 0
        fi
    done
}

# Dizin tarayıcı - dizin seçimi için
directory_browser() {
    local current_dir="${1:-$(pwd)}"
    local title="${2:-Dizin Seç}"
    
    while true; do
        # Dizin içeriğini listele
        local dirs=()
        local index=1
        
        # Mevcut dizini seç seçeneği
        dirs+=("0" "[*] Bu Dizini Seç: $current_dir")
        
        # Üst dizin seçeneği
        if [ "$current_dir" != "/" ]; then
            dirs+=("$index" "../ (Üst Dizin)")
            ((index++))
        fi
        
        # Sadece dizinleri listele
        while IFS= read -r item; do
            if [ -d "$current_dir/$item" ]; then
                dirs+=("$index" "[D] $item/")
                ((index++))
            fi
        done < <(ls -1 "$current_dir" 2>/dev/null | sort)
        
        # Seçim menüsünü göster
        local choice
        choice=$(whiptail --title "$title" \
            --menu "Mevcut Dizin: $current_dir" \
            22 78 14 \
            "${dirs[@]}" \
            3>&1 1>&2 2>&3)
        
        local exit_status=$?
        if [ $exit_status -ne 0 ]; then
            return 1
        fi
        
        # Mevcut dizini seç
        if [ "$choice" == "0" ]; then
            echo "$current_dir"
            return 0
        fi
        
        # Seçilen öğeyi bul
        local selected_item=""
        for ((i=0; i<${#dirs[@]}; i+=2)); do
            if [ "${dirs[$i]}" == "$choice" ]; then
                selected_item="${dirs[$((i+1))]}"
                break
            fi
        done
        
        # Üst dizin
        if [[ "$selected_item" == "../ (Üst Dizin)" ]]; then
            current_dir=$(dirname "$current_dir")
            continue
        fi
        
        # Emoji'leri temizle
        selected_item=$(echo "$selected_item" | sed 's/^\[D\] //; s/\/$//')
        
        # Dizine gir
        if [ -d "$current_dir/$selected_item" ]; then
            current_dir="$current_dir/$selected_item"
        fi
    done
}
