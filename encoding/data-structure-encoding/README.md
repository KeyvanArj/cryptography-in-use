# Data Structure Encoding

In computing, serialization is the process of translating a data structure or object state into a format that can be stored (for example, in a file or memory data buffer) or transmitted (for example, across a computer network) and reconstructed later (possibly in a different computer environment). When the resulting series of bits is reread according to the serialization format, it can be used to create a semantically identical clone of the original object. For many complex objects, such as those that make extensive use of references, this process is not straightforward. Serialization of object-oriented objects does not include any of their associated methods with which they were previously linked.

This process of serializing an object is also called marshalling an object in some situations.The opposite operation, extracting a data structure from a series of bytes, is deserialization, (also called unserialization or unmarshalling).

[Comparison of data-serialization formats](https://en.wikipedia.org/wiki/Comparison_of_data-serialization_formats)
[Serialization](https://en.wikipedia.org/wiki/Serialization)

## Text-based encoding formats

### PEM [RFC 7468](https://tools.ietf.org/html/rfc7468)

Several security-related standards used on the Internet define ASN.1
data formats that are normally encoded using the Basic Encoding Rules
(BER) or Distinguished Encoding Rules (DER) [X.690](https://en.wikipedia.org/wiki/X.690), which are
binary, octet-oriented encodings.
A disadvantage of a binary data format is that it cannot be
interchanged in textual transports, such as email or text documents.
One advantage with text-based encodings is that they are easy to
modify using common text editors; for example, a user may concatenate
several certificates to form a certificate chain with copy-and-paste
operations.
The content of a PEM file begins with a header such as `-----BEGIN CERTIFICATE-----` in a stand-alone line and ends with a 
footer like `-----END CERTIFICATE-----` in the same way. The contents between header and footer tags are base64 encoded string of the related object in DER-encoded format. Except the header, the last line of content and footer lines, each line has the length of 64 characters. So, to parse a PEM file, you need to know the exact definition of the encoded object in ASN.1 syntax. you can use this online tool to check the content of a PEM file [PEM Parser](https://8gwifi.org/PemParserFunctions.jsp) or [Decode PEM data](https://report-uri.com/home/pem_decoder). 

 
#### Public Key

a PEM file which contains a public key begins with the line `-----BEGIN PUBLIC KEY-----` and ends with the line `-----END PUBLIC KEY-----`. Between these two tags is the base64 encoded string of `SubjectPublicKeyInfo` object in DER-encoded format:

```
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEk1qnJZfju7Cs3mcFHkaNv30Y14EX
wLpQUpi1k2W+KWVSb1dnBTkavBRZ8bp0Ip1NR59PwuN/9Nf1pKu77a3PaQ==
-----END PUBLIC KEY-----
```
To  parse the `SubjectPublicKeyInfo` object, you need to follow these steps :

- decode the base64 string (e.g. use this online tool [Cryptii](https://cryptii.com/pipes/base64-to-hex)):

```
base64decode('MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEk1qnJZfju7Cs3mcFHkaNv30Y14EXwLpQUpi1k2W+KWVSb1dnBTkavBRZ8bp0Ip1NR59PwuN/9Nf1pKu77a3PaQ==') = [30 59 30 13 06 07 2a 86 48 ce 3d 02 01 06 08 2a 86 48 ce 3d 03 01 07 03 42 00 04 93 5a a7 25 97 e3 bb b0 ac de 67 05 1e 46 8d bf 7d 18 d7 81 17 c0 ba 50 52 98 b5 93 65 be 29 65 52 6f 57 67 05 39 1a bc 14 59 f1 ba 74 22 9d 4d 47 9f 4f c2 e3 7f f4 d7 f5 a4 ab bb ed ad cf 69]
```

or you can use the following `OpenSSL` command :

```
$ openssl ec -pubin -inform DER -in certificate.cer -outform PEM -out certificate.pem
```

- parse the resulting byte array(`DER` formatted) according to the ASN.1 syntax of `SubjectPublicKeyInfo` [RFC5280](https://datatracker.ietf.org/doc/html/rfc5280#section-4.1.1.2):

```
SubjectPublicKeyInfo  ::=  SEQUENCE  {
        algorithm          AlgorithmIdentifier,
        subjectPublicKey   BIT STRING  }

where

AlgorithmIdentifier  ::=  SEQUENCE  {
        algorithm         OBJECT IDENTIFIER,
        parameters        ANY DEFINED BY algorithm OPTIONAL  }
```

you can use the [ASN.1 Javascript decoder](https://lapo.it/asn1js/) online tool to check the parser result : 

```
SEQUENCE (2 elem)
  SEQUENCE (2 elem)
    OBJECT IDENTIFIER 1.2.840.10045.2.1 ecPublicKey (ANSI X9.62 public key type)
    OBJECT IDENTIFIER 1.2.840.10045.3.1.7 prime256v1 (ANSI X9.62 named elliptic curve)
  BIT STRING (520 bit) 0000010010010011010110101010011100100101100101111110001110111011101100…
```

We know that the `SEQUENCE` tag is `0x30` so the byte array is started with this value. Here, `0x59` equals to the length of the `SEQUENCE` object in bytes. The next `0x30` means that there is another `SEQUENCE` as we expect from the `AlgorithmIdentifier` definition syntax. The `SubjectPublicKey` contains the public key bytes and included as a `BIT STRING` in the object. `BIT STRING` tag is `0x03` which you can find it in the byte array easily followed by `0x42`(it's length in bytes).

Sometimes, the cryptographic objects such as `Certificate`s, `Public Key`s, ... may be stored or transmitted in `DER` format (`.der`).
For example the following command will export the former public key (an EC Public Key) from `PEM` format to its equivalent `DER` one:

```
$ openssl ec -pubin -inform PEM -in public-key.pem -outform DER -out public-key.der
```

The resulting `.der` file contains the base64 decoded of `.pem` file. Please note that the `OpenSSL` command for a `RSA Public Key` is as the following one:

For `RSA Public Key`
```
$ openssl rsa -pubin -inform PEM -in public-key.pem -outform DER -out public-key.der
```

#### Certificate

For `Certificate`
```
$ openssl x509 -inform PEM -in certificate.pem -outform DER -out certificate.der
```

Note: `Certificate` in `DER` format may be stored in `.der`, `.cer` or `.crt` file extensions.

## Binary encoding formats

### [ASN.1](https://en.wikipedia.org/wiki/ASN.1)

Abstract Syntax Notation One (ASN.1) is a standard interface description language for defining data structures that can be serialized and deserialized in a cross-platform way. It is broadly used in telecommunications and computer networking, and especially in cryptography.

Protocol developers define data structures in ASN.1 modules, which are generally a section of a broader standards document written in the ASN.1 language. The advantage is that the ASN.1 description of the data encoding is independent of a particular computer or programming language. Because ASN.1 is both human-readable and machine-readable, an ASN.1 compiler can compile modules into libraries of code, codecs, that decode or encode the data structures. Some ASN.1 compilers can produce code to encode or decode several encodings.

[X.690](https://en.wikipedia.org/wiki/X.690) is an ITU-T standard specifying several ASN.1 encoding formats:

- Basic Encoding Rules (BER)
- Canonical Encoding Rules (CER)
- Distinguished Encoding Rules (DER)

Any ASN.1 encoding begins with two common bytes (or octets, groupings of eight bits) that are universally applied regardless of the type. The first byte is the type indicator, which also includes some modification bits we shall briefly touch upon. The second byte is the length header. 
Some of the more applicable data types are:

- Implicit : tag = 0x00

- Boolean : Primitive, tag = 0x1

- OCTET String : Primitive, tag = 0x04

- BIT String : Primitive, tag = 0x03

- IA5String : Primitive, tag = 0x16

- PrintableString : Primitive, tag = 0x13

- INTEGER : Primitive, tag = 0x02

- OBJECT Identifier (OID) : Primitive, tag = 0x06

- UTCTIME : Primitive, tag = 0x17

- NULL : Primitive, tag = 0x05

- SEQUENCE, SEQUENCE OF : Constructed, tag = 0x10

- SET, SET OF : Constructed, tag = 0x11

The header byte is always placed at the start of any ASN.1 encoding and is divides into three parts: the classification, the constructed bit, and the primitive type. The header byte is broken as shown here : 

- bits 8,7 : Classification
- bit  6 : Constructed
- bits 5..1 : Primitive Type

For example a `SEQUENCE` will be shown by `0x30` tag, because it's a constructed type so the `6`th bit will be `1` and makes the `0x10` tag to `0x30`. The same approach cause that a `SET` will be started by `0x31`.

The classification bits refer to :

| Class	          | Bit 8	| Bit 7 |
| :---------------| :-----| :-----|
|universal	      | 0	    | 0     |
|application	    | 0	    | 1     |
|context-specific | 1	    | 0     |
|private	        | 1	    | 1     |

#### Sample Encodings

We will use the [asn1parse](https://www.openssl.org/docs/manmaster/man1/openssl-asn1parse.html) command of `OpenSSL` with [ASN1_generate_nconf](https://www.openssl.org/docs/manmaster/man3/ASN1_generate_nconf.html) formatted file.

- Integer

Simple Integer : put this lines as the content of `int.cnf` file:

```
asn1=INTEGER:4
```

and run the following command :

```
openssl asn1parse -genconf int.cnf -noout -out int.der | hexdump int.der
000000  02 01 04
```

As we expected, `0x02` refers to the `INTEGER` tag, `0x01` is the length of it and `0x04` is its value.
Now, change the value in `int.cnf` file to `65889` and run it again:

```
openssl asn1parse -genconf int.cnf -noout -out int.der | hexdump int.der
000000  02 03 01 01 61
```

Great, the length of value is changed to `3` bytes which is `0x010161` equals to hexadecimal representation of `65889`.

Let check the `NULL` value out :

```
asn1=NULL
```

```
openssl asn1parse -genconf int.cnf -noout -out int.der | hexdump int.der
000000 05 00
```
`0x05` is the corresponding tag to `NULL`.

Keep going and put an `IMPLICIT` tag on it :

```
asn1=IMPLICIT:1, INTEGER:4
```

```
openssl asn1parse -genconf int.cnf -noout -out int.der | hexdump int.der
000000  81 01 04
```

Now, change it to an `EXPLICIT` tag :

```
asn1=EXPLICIT:1, INTEGER:4
```

```
openssl asn1parse -genconf int.cnf -noout -out int.der | hexdump int.der
000000  a1 03 02 01 04
```



