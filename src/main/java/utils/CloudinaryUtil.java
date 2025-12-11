package utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.io.File;
import java.io.IOException;
import java.util.Map;

/**
 * Utility class for Cloudinary operations
 */
public class CloudinaryUtil {

    private static Cloudinary cloudinary;


    private static final String CLOUD_NAME = "dl3ucqngx";
    private static final String API_KEY = "325947551261377";
    private static final String API_SECRET = "UU4r45S3FKy1y48F4njGU5lkgqQ";

    static {
        cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", CLOUD_NAME,
                "api_key", API_KEY,
                "api_secret", API_SECRET,
                "secure", true));
    }

   
    public static String uploadFile(File file, String folder) {
        try {
            Map uploadResult = cloudinary.uploader().upload(file, ObjectUtils.asMap(
                    "folder", folder,
                    "resource_type", "raw"));
            return (String) uploadResult.get("secure_url");
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    
    public static String uploadContractPdf(File file, int contractId) {
        try {
            Map uploadResult = cloudinary.uploader().upload(file, ObjectUtils.asMap(
                    "folder", "contracts",
                    "public_id", "contract_" + contractId,
                    "resource_type", "raw",
                    "format","pdf",
                    "overwrite", true));
            return (String) uploadResult.get("secure_url");
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

   
    public static String uploadContractPdfBytes(byte[] bytes, int contractId) {
        try {
            Map uploadResult = cloudinary.uploader().upload(bytes, ObjectUtils.asMap(
                    "folder", "contracts",
                    "public_id", "contract_" + contractId,
                    "resource_type", "raw",
                    "format","pdf",
                    "overwrite", true));
            return (String) uploadResult.get("secure_url");
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}
