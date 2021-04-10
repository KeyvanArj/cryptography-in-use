# Data Structure Encoding

In computing, serialization is the process of translating a data structure or object state into a format that can be stored (for example, in a file or memory data buffer) or transmitted (for example, across a computer network) and reconstructed later (possibly in a different computer environment). When the resulting series of bits is reread according to the serialization format, it can be used to create a semantically identical clone of the original object. For many complex objects, such as those that make extensive use of references, this process is not straightforward. Serialization of object-oriented objects does not include any of their associated methods with which they were previously linked.

This process of serializing an object is also called marshalling an object in some situations.The opposite operation, extracting a data structure from a series of bytes, is deserialization, (also called unserialization or unmarshalling).

[Comparison of data-serialization formats](https://en.wikipedia.org/wiki/Comparison_of_data-serialization_formats)
[Serialization](https://en.wikipedia.org/wiki/Serialization)

## Text-based encoding formats

### JSON

### YAML

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

## Binary encoding formats

### [ASN.1](https://en.wikipedia.org/wiki/ASN.1)

Abstract Syntax Notation One (ASN.1) is a standard interface description language for defining data structures that can be serialized and deserialized in a cross-platform way. It is broadly used in telecommunications and computer networking, and especially in cryptography.

Protocol developers define data structures in ASN.1 modules, which are generally a section of a broader standards document written in the ASN.1 language. The advantage is that the ASN.1 description of the data encoding is independent of a particular computer or programming language. Because ASN.1 is both human-readable and machine-readable, an ASN.1 compiler can compile modules into libraries of code, codecs, that decode or encode the data structures. Some ASN.1 compilers can produce code to encode or decode several encodings.

[X.690](https://en.wikipedia.org/wiki/X.690) is an ITU-T standard specifying several ASN.1 encoding formats:

- Basic Encoding Rules (BER)
- Canonical Encoding Rules (CER)
- Distinguished Encoding Rules (DER)

### Protocol Buffers