/**
 * PruebasUnitarias.java
 * Pruebas unitarias basicas de la logica de utilidades.jspf, extraida
 * en Utilidades.java para poder probarla sin necesitar un servidor Tomcat.
 *
 * Como el proyecto no usa Maven/Gradle (todo va en JSP/JSPF puro segun
 * las reglas del curso), estas pruebas se ejecutan directo con javac/java,
 * sin necesitar JUnit ni ninguna libreria externa.
 *
 * Como correrlas:
 *   javac Utilidades.java PruebasUnitarias.java
 *   java PruebasUnitarias
 */
public class PruebasUnitarias {

    static int total = 0;
    static int exitosas = 0;

    public static void main(String[] args) {
        System.out.println("=== Pruebas unitarias: Utilidades ===\n");

        probar("claveCifrada es determinista (mismo usuario+clave -> mismo hash)",
                Utilidades.claveCifrada("admin", "1234")
                        .equals(Utilidades.claveCifrada("admin", "1234")));

        probar("claveCifrada distingue usuarios distintos con la misma clave",
                !Utilidades.claveCifrada("admin", "1234")
                        .equals(Utilidades.claveCifrada("cliente1", "1234")));

        probar("claveCifrada siempre produce un hash de 64 caracteres (SHA-256)",
                Utilidades.claveCifrada("agente1", "1234").length() == 64);

        probar("claveCifrada('admin','1234') coincide con el hash conocido de la BD",
                Utilidades.claveCifrada("admin", "1234")
                        .equals("f8e68e8d44bfb5314974a97f787d017ff6ac9d0046083f28665fcf96f0cef80c"));

        probar("aEntero convierte un texto numerico valido",
                Utilidades.aEntero("42", -1) == 42);

        probar("aEntero devuelve el valor por defecto si el texto no es numerico",
                Utilidades.aEntero("abc", -1) == -1);

        probar("aEntero devuelve el valor por defecto si el texto es null",
                Utilidades.aEntero(null, 7) == 7);

        probar("aDoble convierte un texto con punto decimal",
                Utilidades.aDoble("1500.50", -1) == 1500.50);

        probar("aDoble convierte un texto con coma decimal (formato local)",
                Utilidades.aDoble("1500,50", -1) == 1500.50);

        probar("aDoble devuelve el valor por defecto si el texto no es numerico",
                Utilidades.aDoble("no-es-numero", -99) == -99);

        probar("esc escapa las etiquetas HTML (previene XSS)",
                Utilidades.esc("<script>alert(1)</script>")
                        .equals("&lt;script&gt;alert(1)&lt;/script&gt;"));

        probar("esc no falla con texto null",
                Utilidades.esc(null).equals(""));

        probar("pesos formatea correctamente un valor entero (mismos digitos, con simbolo $)",
                Utilidades.pesos(320000000).startsWith("$")
                        && Utilidades.pesos(320000000).replaceAll("[^0-9]", "").equals("320000000"));

        System.out.println("\n=== Resultado: " + exitosas + "/" + total + " pruebas exitosas ===");
        if (exitosas != total) {
            System.exit(1);
        }
    }

    static void probar(String descripcion, boolean condicion) {
        total++;
        if (condicion) {
            exitosas++;
            System.out.println("[OK]   " + descripcion);
        } else {
            System.out.println("[FAIL] " + descripcion);
        }
    }
}
