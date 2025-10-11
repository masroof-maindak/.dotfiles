#!/usr/bin/env sh

TMP_DIR="/tmp/rmpc"
mkdir -p "$TMP_DIR"
ALBUM_ART_PATH="$TMP_DIR/notification_cover"
IMAGE_FLAG=""

if rmpc albumart --output "$ALBUM_ART_PATH"; then
    # If rmpc succeeds, set the flag to include the album art
    IMAGE_FLAG="-i ${ALBUM_ART_PATH}"
fi

notify-send ${IMAGE_FLAG} "$TITLE • $ARTIST" "$ALBUM"
