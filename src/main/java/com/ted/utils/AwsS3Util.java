package com.ted.utils;

import java.io.File;
import java.io.IOException;
import java.net.URL;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.amazonaws.services.s3.model.PutObjectRequest;

public class AwsS3Util {

    static AmazonS3 s3;
    static String AWS_ACCESS_KEY = "AKIA2KDLRLFETF5GZLUW"; // 【你的 access_key】
    static String AWS_SECRET_KEY = "39OjVTwInwaszyN6jwTFtD7EV6y6rJWJZeULHV5R"; // 【你的 aws_secret_key】
    static String bucketName = "tedawsbucket20220523"; // 【你 bucket 的名字】 # 首先需要保證 s3 上已經存在該儲存桶

    static {
        s3 = new AmazonS3Client(new BasicAWSCredentials(AWS_ACCESS_KEY, AWS_SECRET_KEY));
        s3.setRegion(Region.getRegion(Regions.AP_NORTHEAST_1)); // 此處根據自己的 s3 地區位置改變
    }

    public static String uploadToS3(File tempFile, String remoteFileName) throws IOException {
        try {
            String bucketPath = bucketName + "/javaproject";
            s3.putObject(new PutObjectRequest(bucketPath, remoteFileName, tempFile)
                    .withCannedAcl(CannedAccessControlList.PublicRead));
            GeneratePresignedUrlRequest urlRequest = new GeneratePresignedUrlRequest(bucketPath, remoteFileName);
            URL url = s3.generatePresignedUrl(urlRequest);
            System.out.println("upload success");
            return url.toString();
        } catch (AmazonServiceException ase) {
            ase.printStackTrace();
            ase.toString();
        } catch (AmazonClientException ace) {
            ace.printStackTrace();
            ace.toString();
        }
        return null;
    }
//    public static void main(String[] args) throws IOException {
//        File uploadFile = new File("D:\\Program Files\\IIIFinalServlet\\src\\main\\webapp\\images\\fist2.png");
//        System.out.println(uploadFile.length());
//        String uploadKey = "123.jpg";
//        String s3url = uploadToS3(uploadFile, uploadKey);
//        System.out.println(s3url.substring(0,s3url.indexOf("?")));
//    }
}

