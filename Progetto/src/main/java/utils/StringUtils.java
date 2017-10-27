/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Date;

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
        rtr = rtr.replace("\"", "\\\"");
        rtr = rtr.replace("\'", "\\\'");
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
    public static String printDate(Date d) {
        return "<b>" + d.getDate() + "/" + (d.getMonth() + 1) + "/" + (d.getYear()+1900) + "</b> alle <b>" + d.getHours() + ":" + d.getMinutes() + "</b>";
    }
}
