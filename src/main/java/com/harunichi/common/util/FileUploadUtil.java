package com.harunichi.common.util;

import java.io.File;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;

/*
 파일 업로드 및 삭제 유틸리티 클래스
 - 파일명 중복 방지를 위한 UUID 사용
 - 디렉토리 자동 생성 기능 포함
*/
public class FileUploadUtil {

    /*
     파일을 지정된 디렉토리에 저장하고 저장된 파일명을 반환
     @param uploadFile 업로드할 MultipartFile 객체 (Spring에서 전달됨)
     @param uploadDir  파일이 저장될 실제 경로 (ex: /resources/upload/product)
     @return 저장된 파일명 (UUID_원래파일명 형식)
     @throws Exception 파일 저장 중 IOException 또는 기타 예외 발생 시 던짐
    */
    public static String uploadFile(MultipartFile uploadFile, String uploadDir) throws Exception {
        // 고유한 파일명 생성 (중복 방지)
        String fileName = UUID.randomUUID().toString() + "_" + uploadFile.getOriginalFilename();
        
        // 업로드 디렉토리가 존재하지 않으면 생성
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        // 저장할 파일 객체 생성 및 실제 저장 수행
        File dest = new File(uploadDir, fileName);
        uploadFile.transferTo(dest);

        return fileName;
    }

    /*
     디렉토리 내에서 특정 파일 삭제
     @param uploadDir 삭제할 파일이 존재하는 경로
     @param fileName  삭제할 파일명 (null 또는 빈 문자열이면 삭제하지 않음)
    */
    public static void deleteFile(String uploadDir, String fileName) {
        // 파일명이 유효하지 않으면 삭제하지 않음
        if (fileName == null || fileName.trim().isEmpty()) return;

        // 지정된 경로에 파일 객체 생성
        File file = new File(uploadDir, fileName);

        // 실제 파일이 존재할 경우 삭제
        if (file.exists()) file.delete();
    }
}
