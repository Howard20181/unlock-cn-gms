PERMISSIONS_PATH=/etc/permissions
SYSTEM_PATH=/system
SYSTEM_EXT_PATH=/system_ext
PRODUCT_PATH=/product
VENDOR_PATH=/vendor
OPLUS_BIGBALL_PATH=/my_bigball
OPLUS_BIGBALL_VENDOR_PATH=/mnt/vendor$OPLUS_BIGBALL_PATH
if [ "$KSU" ]; then
    ROOT_LIST=""$SYSTEM_PATH$PERMISSIONS_PATH" "$PRODUCT_PATH$PERMISSIONS_PATH" "$VENDOR_PATH$PERMISSIONS_PATH" "$SYSTEM_EXT_PATH$PERMISSIONS_PATH" "$OPLUS_BIGBALL_PATH$PERMISSIONS_PATH" "$OPLUS_BIGBALL_VENDOR_PATH$PERMISSIONS_PATH""
    REMOVE=""
else # Magisk
    ROOT_LIST=""$SYSTEM_PATH$PERMISSIONS_PATH" "$SYSTEM_PATH$PRODUCT_PATH$PERMISSIONS_PATH" "$SYSTEM_PATH$VENDOR_PATH$PERMISSIONS_PATH" "$SYSTEM_PATH$SYSTEM_EXT_PATH$PERMISSIONS_PATH" "$OPLUS_BIGBALL_PATH$PERMISSIONS_PATH" "$OPLUS_BIGBALL_VENDOR_PATH$PERMISSIONS_PATH""
fi
FILE_LIST="services.cn.google.xml cn.google.services.xml oplus_google_cn_gms_features.xml"
for ROOT in $ROOT_LIST; do
    for FILE in $FILE_LIST; do
        if [ -f "$ROOT/$FILE" ]; then
            PERMISSION_PATH="$MODPATH$ROOT"
            FILE_NAME=$FILE
            ui_print "- PATH $ROOT/$FILE_NAME"
            if [ "$KSU" ] && { [ "$ROOT" != "$OPLUS_BIGBALL_PATH$PERMISSIONS_PATH" ] || [ "$ROOT" != "$OPLUS_BIGBALL_VENDOR_PATH$PERMISSIONS_PATH" ]; }; then
                REMOVE="$REMOVE $ROOT/$FILE_NAME"
            else
                mkdir -p "$PERMISSION_PATH"
                cat >"$PERMISSION_PATH/$FILE_NAME" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<!-- This is the standard set of features for devices that support the CN GMSCore. -->
EOF
                [ "$ROOT" = "$OPLUS_BIGBALL_PATH$PERMISSIONS_PATH" ] || [ "$ROOT" = "$OPLUS_BIGBALL_VENDOR_PATH$PERMISSIONS_PATH" ] && {
                    if [ ! -f "$MODPATH/post-fs-data.sh" ]; then
                        cat >"$MODPATH/post-fs-data.sh" <<EOF
#!/system/bin/sh
MODDIR=\${0%/*}
EOF
                    fi
                    echo "mount -o ro,bind \$MODDIR$ROOT/$FILE_NAME $ROOT/$FILE_NAME" >>"$MODPATH/post-fs-data.sh"
                }
            fi # End else
        fi
    done
done

[ -n "$PERMISSION_PATH" ] || abort "$FILE_LIST Not found!"
