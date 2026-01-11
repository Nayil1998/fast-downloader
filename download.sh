#!/bin/bash

# --- Visual Setup ---
G='\033[0;32m' # Green
B='\033[0;34m' # Blue
Y='\033[1;33m' # Yellow
R='\033[0;31m' # Red
C='\033[0;36m' # Cyan
NC='\033[0m'   # No Color
BOLD='\033[1m'

# --- Config ---
DOWNLOAD_DIR="$HOME/storage/downloads"

# --- UI Components ---
draw_line() { echo -e "${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

print_banner() {
    clear
    draw_line
    echo -e "  ${BOLD}${C}🚀 PREMIER DOWNLOADER${NC} | ${G}ARIA2 ENGINE${NC}"
    draw_line
}

send_notification() {
    # Only try to send if termux-api is installed
    if command -v termux-notification &> /dev/null; then
        termux-notification --title "$1" --content "$2" --id "dl_script"
    fi
}

setup_environment() {
    if [ ! -d "$HOME/storage" ]; then
        echo -e "${Y}⚠️  Storage permission required...${NC}"
        termux-setup-storage
        sleep 2
        exit
    fi

    if ! command -v aria2c &> /dev/null; then
        echo -e "${B}📦 Initializing download engine...${NC}"
        pkg update -y && pkg install aria2 termux-api -y
        hash -r
    fi
    mkdir -p "$DOWNLOAD_DIR"
}

get_storage_info() {
    df -h /sdcard | awk 'NR==2 {print $4}'
}

start_download() {
    local url="$1"
    local filename=$(basename "$url" | cut -d? -f1)
    
    print_banner
    echo -e "${Y}📂 Save Path:${NC}  $DOWNLOAD_DIR"
    echo -e "${Y}💾 Free Space:${NC} $(get_storage_info)"
    echo -e "${Y}🔗 URL:${NC}        ${url:0:50}..."
    echo ""
    
    cd "$DOWNLOAD_DIR" || exit

    # Start Download
    aria2c -x16 -s16 -k1M \
           --continue=true \
           --user-agent="Mozilla/5.0" \
           --console-log-level=warn \
           --summary-interval=1 \
           --download-result=hide \
           "$url"

    if [ $? -eq 0 ]; then
        echo -e "\n${G}✨ DOWNLOAD COMPLETE! ✨${NC}"
        send_notification "Download Finished!" "Saved: $filename"
        draw_line
    else
        echo -e "\n${R}❌ DOWNLOAD FAILED${NC}"
        send_notification "Download Failed" "Link: $url"
        draw_line
    fi
    read -p "Press Enter to return..."
}

main() {
    setup_environment
    
    while true; do
        print_banner
        
        # Clipboard Logic
        CLIPBOARD=""
        if command -v termux-clipboard-get &> /dev/null; then
            CLIPBOARD=$(termux-clipboard-get)
        fi

        echo -e "  ${Y}1.${NC} Paste link manually"
        if [[ "$CLIPBOARD" =~ ^https?:// ]]; then
            echo -e "  ${Y}2.${NC} ${G}Download from Clipboard${NC} ${C}(Detected Link)${NC}"
        fi
        echo -e "  ${Y}q.${NC} Exit"
        echo ""
        draw_line
        read -p " Selection: " choice

        case $choice in
            1) 
                read -p " Paste URL: " manual_url
                if [[ -z "$manual_url" ]]; then continue; fi
                start_download "$manual_url"
                ;;
            2) 
                if [[ "$CLIPBOARD" =~ ^https?:// ]]; then
                    start_download "$CLIPBOARD"
                else
                    echo -e "${R}No link in clipboard!${NC}"
                    sleep 1
                fi
                ;;
            q|Q) 
                echo -e "${C}Goodbye!${NC}"
                exit 0
                ;;
            *) 
                # If they just press enter and clipboard has a link, do that!
                if [[ -z "$choice" && "$CLIPBOARD" =~ ^https?:// ]]; then
                    start_download "$CLIPBOARD"
                fi
                ;;
        esac
    done
}

main
