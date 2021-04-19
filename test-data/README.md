
# Digital Signature requirements

## Generate Keypairs and Certificate for a signer

```
$ openssl req -new -newkey rsa:2048 -keyout private/signer_key.pem -out certs/signer_req.pem -nodes
```

```
$ openssl ca -in certs/signer_req.pem -out certs/signer_cert.pem
```

## Bundle the signer's private key and certificate

```
$ openssl pkcs12 -inkey .\private\signer_key.pem -in .\certs\signer_cert.pem -export -out .\private\signer_bundle.pfx
```
