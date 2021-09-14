# Binary-to-text Encoding

The purpose of encoding is to transform data so that it can be properly (and safely) consumed by a different type of system, e.g. binary data being sent over the response of an API calling, or viewing special characters on a debug console or unit test function. The goal is not to keep information secret, but rather to ensure that it’s able to be properly consumed.
Encoding transforms data into another format using a scheme that is publicly available so that it can easily be reversed. It does not require a key as the only thing required to decode it is the algorithm that was used to encode it.

## Hexadecimal (Base16)

Base16 can also refer to a binary to text encoding belonging to the same family as Base32, Base58, and Base64.

In this case, data is broken into 4-bit sequences, and each value (between 0 and 15 inclusively) is encoded using 16 symbols from the ASCII character set. Although any 16 symbols from the ASCII character set can be used, in practice the ASCII digits '0'–'9' and the letters 'A'–'F' (or the lowercase 'a'–'f') are always chosen in order to align with standard written notation for hexadecimal numbers.

There are several advantages of Base16 encoding:

- Most programming languages already have facilities to parse ASCII-encoded hexadecimal
- Being exactly half a byte, 4-bits is easier to process than the 5 or 6 bits of Base32 and Base64 respectively
The symbols 0-9 and A-F are universal in hexadecimal notation, so it is easily understood at a glance without needing to rely on a symbol lookup table
- Many CPU architectures have dedicated instructions that allow access to a half-byte (otherwise known as a "nibble"), making it more efficient in hardware than Base32 and Base64

The main disadvantages of Base16 encoding are:

- Space efficiency is only 50%, since each 4-bit value from the original data will be encoded as an 8-bit byte. In contrast, Base32 and Base64 encodings have a space efficiency of 63% and 75% respectively.
- Possible added complexity of having to accept both uppercase and lowercase letters.

## Base64

Here, we are talking about the `Base64` encoding from [RFC4648 - The Base16, Base32, and Base64 Data Encodings](https://tools.ietf.org/html/rfc4648).

There are two different versions defined in RFC 4648:

* Standard
* With URL and Filename Safe Alphabet

The encoding process represents 24-bit groups of input bits as output
strings of 4 encoded characters.  Proceeding from left to right, a
24-bit input group is formed by concatenating 3 8-bit input groups.
These 24 bits are then treated as 4 concatenated 6-bit groups, each
of which is translated into a single character in the base 64
alphabet.

Each 6-bit group is used as an index into an array of 64 printable
characters.  The character referenced by the index is placed in the
output string.

The Base 64 Alphabet Table

     Value Encoding  Value Encoding  Value Encoding  Value Encoding
         0 A            17 R            34 i            51 z
         1 B            18 S            35 j            52 0
         2 C            19 T            36 k            53 1
         3 D            20 U            37 l            54 2
         4 E            21 V            38 m            55 3
         5 F            22 W            39 n            56 4
         6 G            23 X            40 o            57 5
         7 H            24 Y            41 p            58 6
         8 I            25 Z            42 q            59 7
         9 J            26 a            43 r            60 8
        10 K            27 b            44 s            61 9
        11 L            28 c            45 t            62 +
        12 M            29 d            46 u            63 /
        13 N            30 e            47 v
        14 O            31 f            48 w         (pad) =
        15 P            32 g            49 x
        16 Q            33 h            50 y

Special processing is performed if fewer than 24 bits are available
at the end of the data being encoded.  A full encoding quantum is
always completed at the end of a quantity.  When fewer than 24 input
bits are available in an input group, bits with value zero are added
(on the right) to form an integral number of 6-bit groups.
Since it encodes by group of 3 bytes, when last group of 3 bytes miss one byte then = is used, when it miss 2 bytes then == is used for padding.

In `URL/Filename safe` version, the `-` is used for `62` instead of `+` , 
and the `_` is used for `63` instead of `/` . This encoding may be referred to as "base64url".  
This encoding should not be regarded as the same as the "base64" encoding and
should not be referred to as only "base64". 

In `OpenSSL` , the `Standard` version has been implemented since OpenSSL 1.1.1j  16 Feb 2021.

### Example

#### manual encoding

Suppose that the input byte array is [0xff, 0xe2].

Its binary form is `1111 1111 1110 0010`

Now, we try to split each 6 bits from the left side:

`111111` `111110` `0010`

and add the `0` on the right of last group to form a 6 bits group:

`111111` `111110` `0010`**`00`**

Now, look at the conversion table (standard) and replace each 6 bits group by its corresponding character :

`/` `+` `I`

The output length is not the multiplier of 4, so add `=` as the padding character:

`/` `+` `I` `=`

If we try to do same one for `base64url` :

`_` `-` `I` `=`

#### create a binary file

You can use `echo` in command line interface : 

``` 
$  echo -n -e \\xff\\xe2 > data_binary.bin
```

To check the content of the binary file :

``` 
$  hexdump data_binary.bin
```

#### encode to standard Base64

``` 
$ openssl enc -base64 -e -in data_binary.bin
```

#### decode from standard Base64

```
$ openssl enc -base64 -d <<< /+I= | od -vt x1
```

# Text-to-binary decoding

In many situations, we have some text values which should be decoded to an equivalent byte arrays. Because we need to put them as the input of a cryptographic process. For example, assume that we have message for an authorized party in text and we need to encrypt it before transmission. The encryption process accepts a byte array as the input so we need to convert the message to a byte array :

```
$ echo -n 'Hello, World' | od -t x1
0000000    48  65  6c  6c  6f  20  57  6f  72  6c  64 
```
 or in other representation way :

 ```
 $ echo -n 'Hello, World' | xxd -ps
 48656c6c6f2c20576f726c64 
 ```
But what does it mean really? It's very important for you to understand what happens exactly in this conversion.
Take a look at the `ASCII Table` again. `0x48` refers to the hexadecimal representation of `H` character, `0x65` refers to `e` character and so on. So, every character in the `Hello, World` message is converted to a hexadecimal value from `ASCII Table`. It means that we have done the `ASCII` decoding process. Did we have any other option? 
Yes,   