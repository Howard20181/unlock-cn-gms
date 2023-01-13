PERMISSIONS_PATH=/etc/permissions
SYSTEM_PATH=/system
SYSTEM_EXT_PATH=$SYSTEM_PATH/system_ext
PRODUCT_PATH=$SYSTEM_PATH/product
VENDOR_PATH=$SYSTEM_PATH/vendor
OPLUS_BIGBALL_PATH=/mnt/vendor/my_bigball
ROOT_LIST=""$SYSTEM_PATH$PERMISSIONS_PATH" "$PRODUCT_PATH$PERMISSIONS_PATH" "$VENDOR_PATH$PERMISSIONS_PATH" "$SYSTEM_EXT_PATH$PERMISSIONS_PATH" "$OPLUS_BIGBALL_PATH$PERMISSIONS_PATH""
FILE_LIST="services.cn.google.xml cn.google.services.xml oplus_google_cn_gms_features.xml"
for ROOT in $ROOT_LIST; do
    for FILE in $FILE_LIST; do
        if [ -f "$ROOT/$FILE" ]; then
            PERMISSION_PATH="$MODPATH$ROOT"
            FILE_NAME=$FILE
            ui_print "- PATH $ROOT/$FILE_NAME"
            break 2
        fi
    done
done

[ -n "$PERMISSION_PATH" ] || abort "$FILE_LIST Not found!"
mkdir -p "$PERMISSION_PATH"

cat >"$PERMISSION_PATH/$FILE_NAME" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<!-- This is the standard set of features for devices that support the CN GMSCore. -->
EOF

[ "$PERMISSION_PATH" = "$MODPATH$OPLUS_BIGBALL_PATH$PERMISSIONS_PATH" ] && {
    cat >"$MODPATH/post-fs-data.sh" <<EOF
#!/system/bin/sh
MODDIR=\${0%/*}
mount -o ro,bind \$MODDIR$OPLUS_BIGBALL_PATH$PERMISSIONS_PATH/$FILE_NAME $OPLUS_BIGBALL_PATH$PERMISSIONS_PATH/$FILE_NAME
EOF
}
