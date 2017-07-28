/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

/**
 *
 * @author pomo
 */
public class StringUtils {
    public static String checkInputString(String s) {
        String rtr;
        rtr = s.replace("&", "&amp;");
        rtr = rtr.replace("'", "&apos;");
        rtr = rtr.replace("<", "&lt;");
        rtr = rtr.replace(">", "&gt;");
        return rtr;
    }
    
    public static boolean isValidString(String s,String allowedCharacters)
    {
        String sanitizedString = s.replaceAll(allowedCharacters, "");
        return sanitizedString.equals(s);
    }
    
    public static boolean isEmpty(String s)
    {
        boolean toRtn = false;
        String sanitizedString = s.replaceAll(" ", "");
        if(sanitizedString.equals(""))
        {
            toRtn = true;
        }
        return toRtn;
    }
}
