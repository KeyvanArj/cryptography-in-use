# Install OpenSSL

## Download
Clone the source code from its original repository : 
```
git clone https://github.com/openssl/openssl.git

```

and checkout the latest stable version branch :

```
git checkout -b OpenSSL_1_1_1-stable
```

## Windows
## Pre-requisites
- Download [Build Tools for Visual Studio 2019](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019)
You need the `Microsoft Visual C++ (MSVC) C compiler on the command line` to build the OpenSSL from its source.

- Download and install [Perl](https://strawberryperl.com/) and make sure that Perl is on your %PATH%

- Download and instal [NASM](https://www.nasm.us) and make sure that NASM is on your %PATH% 

- Now, open the Command Prompt for VS 2019 in Administrative mode and from the root of the OpenSSL source directory run the following commands : 

  ```
  perl Configure VC-WIN32

  nmake

  nmake test

  nmake install
  ```

  The latest command will create the `C:\Program Files (x86)\OpenSSL` directory.
  Now, put the `C:\Program Files (x86)\OpenSSL\bin` directory to your %PATH% variable on top of the `C:\Strawberry\c\bin`,
  because this folder also has an instance of OpenSSL executable file. 

  To verify the installment : 

  ```
  $ openssl version
  ```

  and you will have the `openssl.cnf` file on `C:\Program Files (x86)\Common Files\SSL\openssl.cnf` path.