#!/data/data/com.termux/files/usr/bin/bash

# ========== Settings ==========
DOWNLOAD_DIR="/storage/emulated/0/Download/NAY"
mkdir -p "$DOWNLOAD_DIR"

# ========== Enter the download link ==========
echo -e "\n🡺 Enter the direct download URL:"
read FILE_URL

# Decode the file name
ENCODED_NAME=$(basename "$FILE_URL")
DECODED_NAME=$(echo -e "$(printf '%b' "${ENCODED_NAME//%/\\x}")")

# Define the final path
FINAL_PATH="${DOWNLOAD_DIR}/${DECODED_NAME}"

echo -e "\n⬇️ Downloading:\n📄 $DECODED_NAME"
echo -e "📁 To folder:\n📂 $DOWNLOAD_DIR\n"

# Download the file
aria2c -x 16 -s 16 -k 1M -d "$DOWNLOAD_DIR" -o "$DECODED_NAME" "$FILE_URL"

echo -e "\n✅ Download completed successfully!"