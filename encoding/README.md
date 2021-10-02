# Encoding

## Table of contents

- ### [Purpose](#purpose)
- ### [How it works](#how-it-works)
- ### [Sample](#sample)
- ### [Best practices](#best-practices)

## Purpose

The purpose of encoding is to transform data so that it can be properly (and safely) consumed by a different type of
system. The goal is not to keep information secret, but rather to ensure that it’s able to be properly consumed.
Encoding transforms data into another format using a scheme that is publicly available so that it can easily be
reversed.

## How it works

An algorithm and a key are needed things to encode data. The encoded data could be any kind of data like sample binary
data which will be sent over an API response or special characters on a debug console or unit test functions. On the
other hand, to decode the encoded data you need the algorithm that was used to encode data plus the key of encryption.

But what is happening under the hood? In cryptography, every object will be converted to an array of bytes. This array
will be used as the input of a process and the result of the process will be another array of bytes. The last array of bytes
is our encoded data.

In action, we encounter two objects from different types as input and output. So the question is how we should convert
things to an array of bytes. Or vice versa how we can encode the array of bytes to a human-readable string for
debugging, storable value in a database or transmittable through a RESTful API response? You'll find the
solution [Here](#sample).

## Sample

Using `Hello, World` is the most popular example in the developers' world. So, let's try to represent it as an array of
bytes.

```
echo -n 'Hello, World' | od -vt x1
0000000    48  65  6c  6c  6f  2c  20  57  6f  72  6c  64
```

Each represented byte in output is equal to the `Hello, World` correspondent character in ASCII Table. e.g. `H` is equal
to `0x48` and so on. So every letter in the string is converted into a character of ASCII table. The `String` is a basic
data type. The main question is what we should do if we'd like to represent complex data structures in an array of bytes
and vice versa. It seems easy at first glance, it's not though. It's highly recommended to persuade the next sections.

- [Binary to Text Encoding](https://github.com/KeyvanArj/cryptography-in-use/tree/main/encoding/binary-to-text): This
  method will be used as the primitive tool in binary and text data manipulation.
- [Data Structure Encoding](https://github.com/KeyvanArj/cryptography-in-use/tree/main/encoding/data-structure-encoding):
  This method will be used to manipulate the complex data structures in the cryptography world.

## Best practices