package com.harunichi.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

/*
 파일 다운로드 유틸리티 클래스
 - 클라이언트 요청 시 서버에 존재하는 파일을 브라우저로 전송하여 다운로드 처리
*/
public class FileDownloadUtil {

    /*
     지정된 파일 경로에 있는 파일을 클라이언트에게 다운로드 응답으로 전송
     @param filePath 다운로드할 파일의 실제 경로 (서버 상 경로)
     @param response HttpServletResponse 객체 (Spring MVC에서 자동 주입)
     @throws Exception 파일 존재하지 않거나 스트림 오류 발생 시 예외 발생
    */
    public static void downloadFile(String filePath, HttpServletResponse response) throws Exception {
        File file = new File(filePath); // 실제 파일 객체 생성

        // 파일이 존재하지 않을 경우 404 에러 전송 후 종료
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 1. 응답 헤더 설정
        // Content-Type: 다운로드 용도로 지정 (바이너리 데이터)
        response.setContentType("application/octet-stream");

        // Content-Length: 파일 크기 지정 (다운로드 상태 표시 등)
        response.setContentLength((int) file.length());

        // Content-Disposition: 브라우저에게 다운로드 팝업을 띄우도록 지시
        // "attachment"로 설정하면 바로 다운로드창, filename은 저장될 이름
        response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

        // 2. 파일을 읽어서 응답 스트림에 쓰기 (스트리밍 방식)
        try (
            FileInputStream in = new FileInputStream(file);             // 파일 읽기 스트림
            OutputStream out = response.getOutputStream()               // 응답 출력 스트림
        ) {
            byte[] buffer = new byte[1024]; // 버퍼 설정
            int bytesRead;

            // 파일을 1KB씩 읽어서 응답 스트림에 전송
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }

            // 버퍼 강제 플러시
            out.flush();
        }
    }
}
