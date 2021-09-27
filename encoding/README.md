# Encoding

The purpose of encoding is to transform data so that it can be properly (and safely) consumed by a different type of system, e.g. binary data being sent over the response of an API calling, or viewing special characters on a debug console or unit test function. The goal is not to keep information secret, but rather to ensure that it’s able to be properly consumed.
Encoding transforms data into another format using a scheme that is publicly available so that it can easily be reversed. It does not require a key as the only thing required to decode it is the algorithm that was used to encode it.

In cryptography, every object is converted to a byte array to be used as the input of a process and the result of process will be a byte array. But in action, we encounter to objects from different types. So the question is how should we convert them to a byte array? or vice versa, How can we encode the result byte array to a human-readable string for debugging, storable value in a database table or transmittable through a RESTful API response body?

Using `Hello, World` is the most popular example in developers world. So, let start with it and try to represent it as a byte array :

```
echo -n 'Hello, World' | od -vt x1
0000000    48  65  6c  6c  6f  2c  20  57  6f  72  6c  64 
```

Each represented byte in output, is equal to the `Hello, World` correspondent character in ASCII Table. e.g. `H` is equal to `0x48` and so on. 
The `String` is a basic data type. The main question is what should we do if we'd like to represent complex data structures in byte array and vice versa. It seems easy at first glance, but I highly recommend to persuade the next sections :

- [Binary to Text Encoding](https://github.com/KeyvanArj/cryptography-in-use/tree/main/encoding/binary-to-text) : which will be used as the primitive tools in binary and text data manipulation.
- [Data Structure Encoding](https://github.com/KeyvanArj/cryptography-in-use/tree/main/encoding/data-structure-encoding): which will be used to manipulate the complex data structures in cryptography world.
