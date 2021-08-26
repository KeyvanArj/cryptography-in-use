# Integrity and Authenrication

`Integrity` is an indication that a message has not been altered during storage or transmission.
`Autehntication` is a means of indicating that a message can be tied to the creator, 
                 so the recipient can verify that only the creator could have sent the message. 
`Nonrepoudation` is a means of preventing the sender of a message from claiming that they did not send the message.

A secure hash algorithm is used to provide integrity. It can be combined with a
shared-secret signing key in an HMAC algorithm to ensure authentication. 
A nonce provides anti-replay protection. 
An asymmetric key used as a signing key offers nonrepudiation.