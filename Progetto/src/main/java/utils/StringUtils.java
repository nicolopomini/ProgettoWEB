/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

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
}
