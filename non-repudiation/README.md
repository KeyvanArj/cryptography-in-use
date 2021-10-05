# Non-Repudiation

`Non-Repudiation` is a means of preventing the sender of a message from claiming that they did not send the message.
`Non-repudiation` refers to a situation where a statement's author cannot successfully dispute its authorship or the validity of an associated contract. The term is often seen in a legal setting when the authenticity of a signature is being challenged. In such an instance, the authenticity is being "repudiated".

In digital security, non-repudiation means:

- A service that provides proof of the integrity and origin of data.
- An authentication that can be said to be genuine with high confidence.

Proof of data integrity is typically the easiest of these requirements to accomplish. A data hash such as SHA256 usually ensures that the data will not be changed un-detectably. Even with this safeguard, it is possible to tamper with data in transit, either through a man-in-the-middle attack or phishing. Because of this, data integrity is best asserted when the recipient already possesses the necessary verification information, such as after being mutually authenticated.

The common method to provide non-repudiation in the context of digital communications or storage is Digital Signatures, a more powerful tool that provides non-repudiation in a publicly verifiable manner.
`Public Key Infrastructure` using an asymmetric key used as a signing key offers non-repudiation.

## PKI

`Public Key Infrastructure` (PKI) ensures that an author cannot refute that they signed or encrypted a particular message once it has been sent, assuming the private key is secured. Here Digital signatures link senders to their messages. Only the sender of the message could sign messages with their private key and therefore, all messages signed with the sender's private key originated with that specific individual.

