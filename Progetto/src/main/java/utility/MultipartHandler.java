/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utility;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.UUID;
import javax.servlet.http.Part;
/**
 *
 * @author pomo
 */
public class MultipartHandler {
    private static final int DEFAULT_BUFFER_SIZE = 1024;
    
    public static String getStringValue(Part part, String encoding) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(part.getInputStream(), encoding));
        StringBuilder value = new StringBuilder();
        char[] buffer = new char[DEFAULT_BUFFER_SIZE];
        for (int length = 0; (length = reader.read(buffer)) > 0;) {
            value.append(buffer, 0, length);
        }
        return value.toString();
    }
    public static String processImage(Part part, String context) throws IOException {
        String upname = getFilename(part);
        String ext = "";
        int i = upname.length() -1;
        while(upname.charAt(i) != '.') {
            ext = upname.charAt(i) + ext;
            i--;
        }
        if(!context.endsWith("/"))
            context += "/";
        String path = "img/";
        path += UUID.randomUUID().toString();
        path += "." + ext;
        String filename = context + path;
        File file = new File(filename);
        file.getParentFile().mkdirs();
        file.createNewFile();
        InputStream input = null;
        OutputStream out = null;
        input = part.getInputStream();
        out = new FileOutputStream(file);
        int read = 0;
        byte[] bytes = new byte[DEFAULT_BUFFER_SIZE];

        while ((read = input.read(bytes)) != -1) {
                out.write(bytes, 0, read);
        }
        part.delete();
        return path;
    }
    private static String getFilename(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}