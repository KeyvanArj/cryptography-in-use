## CA Key and self-signed Certificate

- CA config file is on:

**CentOS**
```
/etc/pki/tls/openssl.cnf
```

**Windows**
```
C:/Program Files (x86)/Common Files/SSL/openssl.cnf
```

- Go to the default CA directory

**CentOS**
```
$  cd /etc/pki/CA/
```

**Windows**
You can create it yourself : 

```
$ mkdir E:/ca
$ cd E:/ca
$ mkdir private
```

- Generate a key for the subject. It is the same as we did for our subject.

```
$ openssl genrsa -out private/cakey.pem 2048 
```

- Generate a self signed certificate for the CA:

```
$ openssl req -new -x509 -key private/cakey.pem -out cacert.pem
```

- Create some directories and files if not exists

```
$ mkdir newcerts

# for Windows use : 
$ echo.> index.txt
$ echo 01 > serial

# for linux
$ touch index.txt  
$ echo '01' > serial

```

- Generate a key for TSA server

```
openssl req -new -newkey rsa:2048 -keyout private/tsakey.pem -out tsareq.pem -nodes
```

- Create `tsa.x509config` with the following content

```
[hamrahkishtsa]
basicConstraints=CA:FALSE
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
extendedKeyUsage=critical,timeStamping
```

- Generate Certificate for TSA

```
 openssl ca -in tsareq.pem -out tsacert.pem -extensions hamrahkishtsa -extfile tsa.x509config
```

- Create the `tsaserial` file :

**CentOS**
```
echo '01' > tsaserial
```

**Windows**
```
echo 01 > tsaserial
```

- Change the openssl config file `/etc/pki/tls/openssl.cnf` and change the `tsa configuration` section to 
refer to 

    - For **CentOS** : `/etc/pki/CA/`
    - For **Windows** : `C:/Hamrahkish_CA/`

- Now for test, we assume that `test.txt` contains our data which we want add time stamp to it

```
openssl ts -query -data test.txt -sha256 -out test.tsq -cert
```

- To print the content of the previous request in human readable format:

```
openssl ts -query -in test.tsq -text
```

- To create a timestamp response for a request :

```
openssl ts -reply -queryfile test.tsq -out test.tsr
```

- To print a timestamp reply to stdout in human readable format:

```
openssl ts -reply -in test.tsr -text
```

- To create a timestamp token instead of timestamp response:

```
openssl ts -reply -queryfile test.tsq -out test_token.der -token_out
```

- To print a timestamp token to stdout in human readable format : 

```
openssl ts -reply -in test_token.der -token_in -text -token_out
```

- To verify a timestamp reply against a request:

**CentOS**
```
openssl ts -verify -queryfile test.tsq -in test.tsr -CAfile /etc/pki/CA/cacert.pem
```

**Windows**
```
openssl ts -verify -queryfile test.tsq -in test.tsr -CAfile C:/Hamrahkish_CA/cacert.pem
```
