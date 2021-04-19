package cryptolib;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.Calendar;

import java.security.cert.X509Certificate;
import java.security.GeneralSecurityException;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.encryption.AccessPermission;
import org.apache.pdfbox.pdmodel.encryption.StandardProtectionPolicy;
import org.apache.pdfbox.pdmodel.interactive.digitalsignature.SignatureInterface;
import org.apache.pdfbox.pdmodel.interactive.digitalsignature.PDSignature;
import org.apache.pdfbox.pdmodel.interactive.digitalsignature.SignatureOptions;
import org.apache.pdfbox.cos.COSArray;
import org.apache.pdfbox.cos.COSBase;
import org.apache.pdfbox.cos.COSDictionary;
import org.apache.pdfbox.cos.COSName;

import org.bouncycastle.cms.CMSSignedDataGenerator;
import org.bouncycastle.operator.ContentSigner;
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder;
import org.bouncycastle.cms.jcajce.JcaSignerInfoGeneratorBuilder;
import org.bouncycastle.operator.jcajce.JcaDigestCalculatorProviderBuilder;
import org.bouncycastle.cert.jcajce.JcaCertStore;
import org.bouncycastle.cms.CMSSignedData;
import org.bouncycastle.cms.CMSException;
import org.bouncycastle.operator.OperatorCreationException;

public class CryptoPdf extends CryptoFile implements SignatureInterface {

    public CryptoPdf() {

    }
      
    public Boolean encrypt(PDDocument plainDocument, 
                           String password, 
                           PDDocument cipheredDocument) {
        try
        {
            //Creating access permission object
            AccessPermission accessPermission = new AccessPermission();

            // Set if the user can modify the document to false
            accessPermission.setCanModify(false);

            //Creating StandardProtectionPolicy object
            StandardProtectionPolicy standardProtectionPolicy = new StandardProtectionPolicy(password, password, accessPermission);
    
            //Setting the length of the encryption key
            standardProtectionPolicy.setEncryptionKeyLength(128);
    
            //Setting the access permissions
            standardProtectionPolicy.setPermissions(accessPermission);
    
            //Protecting the document
            cipheredDocument.protect(standardProtectionPolicy);

            return true;
            
        } catch(Exception exception) {
            return false;
        }
    }

    public Boolean signDocument(PDDocument originalDocuemnt, 
                                OutputStream signedOutputStream) throws IllegalStateException {
        try {
            int accessPermissions = this.getMDPPermission(originalDocuemnt);
            if (accessPermissions == 1) {
                throw new IllegalStateException("No changes to the document are permitted due to DocMDP transform parameters dictionary");
            }     

            // create signature dictionary
            PDSignature signature = new PDSignature();
            signature.setFilter(PDSignature.FILTER_ADOBE_PPKLITE);
            signature.setSubFilter(PDSignature.SUBFILTER_ADBE_PKCS7_DETACHED);
            signature.setReason("Sign docuemnt");
        
            // the signing date, needed for valid signature
            signature.setSignDate(Calendar.getInstance());

            // Optional: certify 
            if (accessPermissions == 0)
            {
                this.setMDPPermission(originalDocuemnt, signature, 2);
            }     
            
            SignatureOptions signatureOptions = new SignatureOptions();
            // Size can vary, but should be enough for purpose.
            signatureOptions.setPreferredSignatureSize(SignatureOptions.DEFAULT_SIGNATURE_SIZE * 2);
            // register signature dictionary and sign interface
            originalDocuemnt.addSignature(signature, this, signatureOptions);

            // write incremental (only for signing purpose)
            originalDocuemnt.saveIncremental(signedOutputStream);

            return true;

        } catch(IOException ex) {
            return false;
        }

    }

    @Override
    public byte[] sign(InputStream content) throws IOException {
        try
        {
            CMSSignedDataGenerator cmsSignedDataGenerator = new CMSSignedDataGenerator();
            X509Certificate x509Certificate = (X509Certificate) _certificateChain[0];
            ContentSigner contentSigner = new JcaContentSignerBuilder("SHA256WithRSA").build(_privateKey);
            cmsSignedDataGenerator.addSignerInfoGenerator(new JcaSignerInfoGeneratorBuilder(
                                                            new JcaDigestCalculatorProviderBuilder().build()).
                                                                build(contentSigner, x509Certificate));
            cmsSignedDataGenerator.addCertificates(new JcaCertStore(Arrays.asList(_certificateChain)));
            CMSProcessableInputStream cmsProcessableInputStream = new CMSProcessableInputStream(content);
            CMSSignedData cmsSignedData = cmsSignedDataGenerator.generate(cmsProcessableInputStream, false);
            return cmsSignedData.getEncoded();
        }
        catch (GeneralSecurityException | CMSException | OperatorCreationException e)
        {
            throw new IOException(e);
        }
    }

    public int getMDPPermission(PDDocument document)
    {
        COSDictionary permsDict = document.getDocumentCatalog().getCOSObject().getCOSDictionary(COSName.PERMS);
        if (permsDict != null)
        {
            COSDictionary signatureDict = permsDict.getCOSDictionary(COSName.DOCMDP);
            if (signatureDict != null)
            {
                COSArray refArray = signatureDict.getCOSArray(COSName.REFERENCE);
                if (refArray instanceof COSArray)
                {
                    for (int i = 0; i < refArray.size(); ++i)
                    {
                        COSBase base = refArray.getObject(i);
                        if (base instanceof COSDictionary)
                        {
                            COSDictionary sigRefDict = (COSDictionary) base;
                            if (COSName.DOCMDP.equals(sigRefDict.getDictionaryObject(COSName.TRANSFORM_METHOD)))
                            {
                                base = sigRefDict.getDictionaryObject(COSName.TRANSFORM_PARAMS);
                                if (base instanceof COSDictionary)
                                {
                                    COSDictionary transformDict = (COSDictionary) base;
                                    int accessPermissions = transformDict.getInt(COSName.P, 2);
                                    if (accessPermissions < 1 || accessPermissions > 3)
                                    {
                                        accessPermissions = 2;
                                    }
                                    return accessPermissions;
                                }
                            }
                        }
                    }
                }
            }
        }
        return 0;
    }

    public void setMDPPermission(PDDocument doc, PDSignature signature, int accessPermissions) throws IOException
    {
        for (PDSignature sig : doc.getSignatureDictionaries())
        {
            // "Approval signatures shall follow the certification signature if one is present"
            // thus we don't care about timestamp signatures
            if (COSName.DOC_TIME_STAMP.equals(sig.getCOSObject().getItem(COSName.TYPE)))
            {
                continue;
            }
            if (sig.getCOSObject().containsKey(COSName.CONTENTS))
            {
                throw new IOException("DocMDP transform method not allowed if an approval signature exists");
            }
        }

        COSDictionary sigDict = signature.getCOSObject();

        // DocMDP specific stuff
        COSDictionary transformParameters = new COSDictionary();
        transformParameters.setItem(COSName.TYPE, COSName.TRANSFORM_PARAMS);
        transformParameters.setInt(COSName.P, accessPermissions);
        transformParameters.setName(COSName.V, "1.2");
        transformParameters.setNeedToBeUpdated(true);

        COSDictionary referenceDict = new COSDictionary();
        referenceDict.setItem(COSName.TYPE, COSName.SIG_REF);
        referenceDict.setItem(COSName.TRANSFORM_METHOD, COSName.DOCMDP);
        referenceDict.setItem(COSName.DIGEST_METHOD, COSName.getPDFName("SHA1"));
        referenceDict.setItem(COSName.TRANSFORM_PARAMS, transformParameters);
        referenceDict.setNeedToBeUpdated(true);

        COSArray referenceArray = new COSArray();
        referenceArray.add(referenceDict);
        sigDict.setItem(COSName.REFERENCE, referenceArray);
        referenceArray.setNeedToBeUpdated(true);

        // Catalog
        COSDictionary catalogDict = doc.getDocumentCatalog().getCOSObject();
        COSDictionary permsDict = new COSDictionary();
        catalogDict.setItem(COSName.PERMS, permsDict);
        permsDict.setItem(COSName.DOCMDP, signature);
        catalogDict.setNeedToBeUpdated(true);
        permsDict.setNeedToBeUpdated(true);
    }
}
