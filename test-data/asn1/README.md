# Convert Signed Data ASN.1 config file to DER format

```
$ openssl asn1parse -genconf signed_data.cnf -noout -out signed_data_cms.der
```

# Conver DER formatted file to Base64

```
 openssl enc -base64 -e -in signed_data_cms.der
```
