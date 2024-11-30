#!/bin/bash

#! Shell script cài đặt yt-dlp và FFmpeg trên macOS

# Kết thúc script nếu có bất kỳ lệnh nào thất bại
set -e

# Hàm kiểm tra xem một lệnh có tồn tại hay không
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

BIN_DIR="$HOME/bin"
mkdir -p $BIN_DIR

echo "Bắt đầu quá trình cài đặt yt-dlp và FFmpeg trên macOS..."

# Kiểm tra và cài đặt Homebrew nếu chưa có
if ! command_exists brew; then
    echo "Homebrew không được tìm thấy. Đang cài đặt Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Thêm Homebrew vào PATH
    # Kiểm tra kiến trúc hệ thống để xác định đường dẫn Homebrew
    if [ -d "/opt/homebrew/bin" ]; then
        echo 'export PATH="/opt/homebrew/bin:$PATH"' >>~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'export PATH="/usr/local/bin:$PATH"' >>~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew đã được cài đặt."
fi

# Cài đặt FFmpeg nếu chưa có
if brew list ffmpeg >/dev/null 2>&1; then
    echo "FFmpeg đã được cài đặt."
else
    echo "Đang cập nhật Homebrew..."
    brew update

    echo "Đang cài đặt FFmpeg..."
    brew install ffmpeg
fi

# Cài đặt yt-dlp nếu chưa có
if which yt-dlp >/dev/null 2>&1; then
    echo "yt-dlp đã được cài đặt."
else
    echo "Đang cài đặt yt-dlp..."
    wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos
    mv ./yt-dlp_macos $BIN_DIR/yt-dlp
    chmod +x $BIN_DIR/yt-dlp
fi

# Thêm BIN_DIR vào PATH nếu chưa có
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo "Thêm $BIN_DIR vào PATH..."
    # Xác định shell hiện tại
    SHELL_NAME=$(basename "$SHELL")
    if [ "$SHELL_NAME" = "zsh" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ "$SHELL_NAME" = "bash" ]; then
        SHELL_RC="$HOME/.bash_profile"
    else
        SHELL_RC="$HOME/.profile"
    fi

    # Thêm dòng vào file cấu hình shell nếu chưa có
    if ! grep -q "export PATH=\"$BIN_DIR:\$PATH\"" "$SHELL_RC"; then
        echo "export PATH=\"$BIN_DIR:\$PATH\"" >>"$SHELL_RC"
        echo "Đã thêm $BIN_DIR vào PATH trong $SHELL_RC"
    else
        echo "$BIN_DIR đã có trong PATH."
    fi

    # Cập nhật PATH hiện tại trong phiên làm việc
    export PATH="$BIN_DIR:$PATH"
else
    echo "$BIN_DIR đã có trong PATH."
fi

echo "Đang kiểm tra phiên bản đã cài đặt..."

# Kiểm tra phiên bản FFmpeg
if command_exists ffmpeg; then
    echo "FFmpeg đã được cài đặt thành công: $(ffmpeg -version | head -n1)"
else
    echo "Lỗi: FFmpeg không được cài đặt thành công."
fi

# Kiểm tra phiên bản yt-dlp
if command_exists yt-dlp; then
    echo "yt-dlp đã được cài đặt thành công"
else
    echo "Lỗi: yt-dlp không được cài đặt thành công."
fi

echo "Cài đặt hoàn tất!"
