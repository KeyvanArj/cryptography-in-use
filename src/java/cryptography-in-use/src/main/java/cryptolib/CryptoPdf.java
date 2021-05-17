package cryptolib;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import java.awt.geom.Rectangle2D;
import java.awt.geom.AffineTransform;
import java.awt.Color;

import java.security.cert.X509Certificate;
import java.security.GeneralSecurityException;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.PDResources;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.common.PDStream;
import org.apache.pdfbox.pdmodel.encryption.AccessPermission;
import org.apache.pdfbox.pdmodel.encryption.StandardProtectionPolicy;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.graphics.form.PDFormXObject;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.apache.pdfbox.pdmodel.interactive.digitalsignature.SignatureInterface;
import org.apache.pdfbox.pdmodel.interactive.annotation.PDAnnotationWidget;
import org.apache.pdfbox.pdmodel.interactive.annotation.PDAppearanceDictionary;
import org.apache.pdfbox.pdmodel.interactive.annotation.PDAppearanceStream;
import org.apache.pdfbox.pdmodel.interactive.digitalsignature.PDSignature;
import org.apache.pdfbox.pdmodel.interactive.digitalsignature.SignatureOptions;
import org.apache.pdfbox.pdmodel.interactive.form.PDAcroForm;
import org.apache.pdfbox.pdmodel.interactive.form.PDField;
import org.apache.pdfbox.pdmodel.interactive.form.PDSignatureField;
import org.apache.pdfbox.util.Matrix;
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
      
    public Boolean encryptDocument(PDDocument plainDocument, 
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

    public Boolean signWithVisualDocument(  PDDocument originalDocuemnt, 
                                            OutputStream signedOutputStream,
                                            Rectangle2D visualRectangle,
                                            File visualSignatureFile) throws IllegalStateException {
        try {
            int accessPermissions = this.getMDPPermission(originalDocuemnt);
            if (accessPermissions == 1) {
                throw new IllegalStateException("No changes to the document are permitted due to DocMDP transform parameters dictionary");
            }     
            
            // create visual signature rectangle
            PDRectangle visualSignaturRectangle = null;
            visualSignaturRectangle = createSignatureRectangle(originalDocuemnt, visualRectangle);

            // 
            PDAcroForm acroForm = originalDocuemnt.getDocumentCatalog().getAcroForm();
            if (acroForm != null && acroForm.getNeedAppearances())
            {
                // PDFBOX-3738 NeedAppearances true results in visible signature becoming invisible 
                // with Adobe Reader
                if (acroForm.getFields().isEmpty())
                {
                    // we can safely delete it if there are no fields
                    acroForm.getCOSObject().removeItem(COSName.NEED_APPEARANCES);
                }
                else
                {
                    System.out.println("/NeedAppearances is set, signature may be ignored by Adobe Reader");
                }
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

            // add visual signature to the document
            signatureOptions.setVisualSignature(createVisualSignatureTemplate(originalDocuemnt, 
                                                                              0, 
                                                                              visualSignaturRectangle, 
                                                                              visualSignatureFile));
            signatureOptions.setPage(0);
            
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

    private PDRectangle createSignatureRectangle(PDDocument document, Rectangle2D visualRectangle)
    {
        float x = (float) visualRectangle.getX();
        float y = (float) visualRectangle.getY();
        float width = (float) visualRectangle.getWidth();
        float height = (float) visualRectangle.getHeight();
        PDPage page = document.getPage(0);
        PDRectangle pdRectangle = new PDRectangle();
        // signing should be at the same position regardless of page rotation.
        switch (page.getRotation())
        {
            case 90:
                pdRectangle.setLowerLeftY(x);
                pdRectangle.setUpperRightY(x + width);
                pdRectangle.setLowerLeftX(y);
                pdRectangle.setUpperRightX(y + height);
                break;
            case 180:
                pdRectangle.setUpperRightX(page.getMediaBox().getWidth() - x);
                pdRectangle.setLowerLeftX(page.getMediaBox().getWidth() - x - width);
                pdRectangle.setLowerLeftY(y);
                pdRectangle.setUpperRightY(y + height);
                break;
            case 270:
                pdRectangle.setLowerLeftY(page.getMediaBox().getHeight() - x - width);
                pdRectangle.setUpperRightY(page.getMediaBox().getHeight() - x);
                pdRectangle.setLowerLeftX(page.getMediaBox().getWidth() - y - height);
                pdRectangle.setUpperRightX(page.getMediaBox().getWidth() - y);
                break;
            case 0:
            default:
                pdRectangle.setLowerLeftX(x);
                pdRectangle.setUpperRightX(x + width);
                pdRectangle.setLowerLeftY(page.getMediaBox().getHeight() - height - y);
                pdRectangle.setUpperRightY(page.getMediaBox().getHeight() - y);
                break;
        }
        return pdRectangle;
    }

    // create a template PDF document with empty signature and return it as a stream.
    private InputStream createVisualSignatureTemplate(PDDocument srcDoc, 
                                                      int pageNum, 
                                                      PDRectangle rect,
                                                      File visualSignatureFile) throws IOException
    {
        try (PDDocument doc = new PDDocument())
        {
            PDPage page = new PDPage(srcDoc.getPage(pageNum).getMediaBox());
            doc.addPage(page);
            PDAcroForm acroForm = new PDAcroForm(doc);
            doc.getDocumentCatalog().setAcroForm(acroForm);
            PDSignatureField signatureField = new PDSignatureField(acroForm);
            PDAnnotationWidget widget = signatureField.getWidgets().get(0);
            List<PDField> acroFormFields = acroForm.getFields();
            acroForm.setSignaturesExist(true);
            acroForm.setAppendOnly(true);
            acroForm.getCOSObject().setDirect(true);
            acroFormFields.add(signatureField);

            widget.setRectangle(rect);

            // from PDVisualSigBuilder.createHolderForm()
            PDStream stream = new PDStream(doc);
            PDFormXObject form = new PDFormXObject(stream);
            PDResources res = new PDResources();
            form.setResources(res);
            form.setFormType(1);
            PDRectangle bbox = new PDRectangle(rect.getWidth(), rect.getHeight());
            float height = bbox.getHeight();
            Matrix initialScale = null;
            switch (srcDoc.getPage(pageNum).getRotation())
            {
                case 90:
                    form.setMatrix(AffineTransform.getQuadrantRotateInstance(1));
                    initialScale = Matrix.getScaleInstance(bbox.getWidth() / bbox.getHeight(), bbox.getHeight() / bbox.getWidth());
                    height = bbox.getWidth();
                    break;
                case 180:
                    form.setMatrix(AffineTransform.getQuadrantRotateInstance(2)); 
                    break;
                case 270:
                    form.setMatrix(AffineTransform.getQuadrantRotateInstance(3));
                    initialScale = Matrix.getScaleInstance(bbox.getWidth() / bbox.getHeight(), bbox.getHeight() / bbox.getWidth());
                    height = bbox.getWidth();
                    break;
                case 0:
                default:
                    break;
            }
            form.setBBox(bbox);
            PDFont font = PDType1Font.HELVETICA_BOLD;

            // from PDVisualSigBuilder.createAppearanceDictionary()
            PDAppearanceDictionary appearance = new PDAppearanceDictionary();
            appearance.getCOSObject().setDirect(true);
            PDAppearanceStream appearanceStream = new PDAppearanceStream(form.getCOSObject());
            appearance.setNormalAppearance(appearanceStream);
            widget.setAppearance(appearance);

            try (PDPageContentStream cs = new PDPageContentStream(doc, appearanceStream))
            {
                // for 90Â° and 270Â° scale ratio of width / height
                // not really sure about this
                // why does scale have no effect when done in the form matrix???
                if (initialScale != null)
                {
                    cs.transform(initialScale);
                }

                // show background image
                // save and restore graphics if the image is too large and needs to be scaled
                cs.saveGraphicsState();
                cs.transform(Matrix.getScaleInstance(0.1f, 0.1f));
                PDImageXObject img = PDImageXObject.createFromFileByExtension(visualSignatureFile, doc);
                cs.drawImage(img, 0, 0);
                cs.restoreGraphicsState();

                // show text
                float fontSize = 4;
                float leading = fontSize * 1.5f;
                cs.beginText();
                cs.setFont(font, fontSize);
                cs.setNonStrokingColor(Color.black);
                cs.newLineAtOffset(fontSize, height - leading);
                cs.setLeading(leading);
                cs.showText("Signed by : ");
                cs.newLine();
                cs.showText("National code : ");
                cs.newLine();
                cs.showText("Certificate serial : ");
                cs.newLine();
                cs.showText("Signing time : ");
                cs.endText();
            }

            // no need to set annotations and /P entry
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            doc.save(byteArrayOutputStream);
            return new ByteArrayInputStream(byteArrayOutputStream.toByteArray());
        }
    }
}
