const Crypto = require('crypto');

class CryptoObject {

    constructor() {

    }

    encrypt_aes_256_cbc_pkcs5(plainBytes, keyBase64, ivBase64) {

        const keyBuffer = Buffer.from(keyBase64, 'base64');
        const ivBuffer = Buffer.from(ivBase64, 'base64');

        let cipher = Crypto.createCipheriv('aes-256-cbc', keyBuffer, ivBuffer);
        let encrypted = cipher.update(plainBytes);
        encrypted = cipher.final();
        return Buffer.concat([ivBuffer, encrypted]);
    }

    decrypt_aes_256_cbc_pkcs5(encryptedBytes, keyBase64) {

        const keyString = Buffer.from(keyBase64, 'base64');
        const ivString = encryptedBytes.slice(0, 16);

        let decipher = Crypto.createDecipheriv('aes-256-cbc', keyString, ivString);
        let decrypted = decipher.update(encryptedBytes);
        decrypted = decipher.final();
        return decrypted;
    }

    base64_to_hex_string(base64String) {
        const base64Buffer = Buffer.from(base64String, 'base64');
        const hexString = base64Buffer.toString('hex');
        return hexString;
    }
}

module.exports = CryptoObject