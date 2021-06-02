const Expect = require('chai').expect;
const CryptoObject = require('../src/CryptoObject')
const FileStream = require('fs')

const TestDataPath = "D:/workspace/cryptography-in-use/test-data";

describe("Data/Message Secrecy", function() {

    const keyBase64 = 'QNV2GQxfFWXwmZTWmoJrSxYNLmqTUxv9g5NeQpabc7E=';
    const ivBase64 = '0eQbwlW32F6wbv7ca2n8bg==';
    const plainBytes = FileStream.readFileSync(TestDataPath + '/bin/data_binary.bin');

    describe("Encryption", function() {
        it("AES-256 CBC Mode by PKCS5 Padding", function() {
            let cryptoObject = new CryptoObject();
            let encryptedData = cryptoObject.encrypt_aes_256_cbc_pkcs5(plainBytes, keyBase64, ivBase64);
            let encryptedDataBase64 = encryptedData.toString('base64');
            // $ openssl enc -aes-256-cbc -K 40d576190c5f1565f09994d69a826b4b160d2e6a93531bfd83935e42969b73b1 -iv d1e41bc255b7d85eb06efedc6b69fc6e -base64 -in bin/data_binary.bin
            Expect(encryptedDataBase64).to.equal('qxdVd8vkC6R1NBYi30q0wQ==')
        });
    });

    describe("Decryption", function() {
        it("AES-256 CBC Mode by PKCS5 Padding", function() {
            let cryptoObject = new CryptoObject();
            // $ openssl enc -aes-256-cbc -K 40d576190c5f1565f09994d69a826b4b160d2e6a93531bfd83935e42969b73b1 -iv d1e41bc255b7d85eb06efedc6b69fc6e -in bin/data_binary.bin -out bin/encrypted_data.bin
            let encryptedBytes = FileStream.readFileSync(TestDataPath + '/bin/encrypted_data.bin');
            let decryptedData = cryptoObject.decrypt_aes_256_cbc_pkcs5(encryptedBytes, keyBase64, ivBase64);
            // $ openssl enc -aes-256-cbc -K 40d576190c5f1565f09994d69a826b4b160d2e6a93531bfd83935e42969b73b1 -iv d1e41bc255b7d85eb06efedc6b69fc6e -base64 -in bin/data_binary.bin
            Expect(decryptedData.toString('hex')).to.equal(plainBytes.toString('hex'))
        });
    });
});