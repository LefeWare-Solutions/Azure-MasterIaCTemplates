CERT_NAME="fb00cf4622f8e8bc.crt"
KEY_NAME="generated-private-key.key"
PFX_NAME="api_lefewaresolutions_com.pfx"

openssl pkcs12 -export -out $PFX_NAME -in $CERT_NAME -inkey $KEY_NAME