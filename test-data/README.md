
# Digital Signature requirements

## Generate RSA Keypairs and Certificate for a signer

```
$ openssl req -new -newkey rsa:2048 -keyout private/signer_key.pem -out certs/signer_req.pem -nodes
```

```
$ openssl ca -in certs/signer_req.pem -out certs/signer_cert.pem
```

## generate an EC private key for a curve

```
$ openssl ecparam -name prime256v1 -genkey -noout -out private/ec-private-key.pem
```

`Optional`
set passphrase on it : 

```
$ openssl ec -in private/ec-private-key.pem -out private/ec-private-key.pem -aes256
```

extract the certificate:

```
openssl req -new -x509 -key private/ec-private-key.pem -out certs/ec-cert.pem -days 360
```

extract the public key:

```
openssl ec -in private/ec-private-key.pem -pubout -out certs/ec-public-key.pem
```

## Bundle the signer's private key and certificate

```
$ openssl pkcs12 -inkey .\private\signer_key.pem -in .\certs\signer_cert.pem -export -out .\private\signer_bundle.pfx
```

# Binary Data Generation

```
$ echo -n -e \\xff\\xe2 > .\bin\data_binary.bin
```