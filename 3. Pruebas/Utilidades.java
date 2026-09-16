import java.security.MessageDigest;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * Utilidades.java
 * Version standalone (sin JSP) de la logica de utilidades.jspf,
 * extraida unicamente para poder escribirle pruebas unitarias
 * independientes del servidor Tomcat.
 */
public class Utilidades {

    public static String sha256(String texto) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] resumen = md.digest(texto.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : resumen) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception ex) {
            throw new RuntimeException("Error al cifrar la clave", ex);
        }
    }

    public static String claveCifrada(String usuario, String clave) {
        return sha256(usuario + ":" + clave);
    }

    public static String pesos(double valor) {
        NumberFormat f = NumberFormat.getInstance(new Locale("es", "CO"));
        f.setMaximumFractionDigits(0);
        return "$ " + f.format(valor);
    }

    public static int aEntero(String valor, int porDefecto) {
        try { return Integer.parseInt(valor.trim()); }
        catch (Exception ex) { return porDefecto; }
    }

    public static double aDoble(String valor, double porDefecto) {
        try { return Double.parseDouble(valor.trim().replace(",", ".")); }
        catch (Exception ex) { return porDefecto; }
    }

    public static String esc(String texto) {
        if (texto == null) return "";
        return texto.replace("&", "&amp;").replace("<", "&lt;")
                     .replace(">", "&gt;").replace("\"", "&quot;");
    }
}
