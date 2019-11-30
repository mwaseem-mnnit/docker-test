public class StringBenchMark {
    public static void main(String[] args) {
        String s = "Hello" ;
        String s1 = " ";
        String s2 = "World!!";
        String s3 = s + s1 + s2;
        System.out.println(s3);

        java.lang.StringBuilder result = new java.lang.StringBuilder();
        for (int i=0; i<1e6; i++) {
            result.append("some more data");
        }
        System.out.println(result);
    }
}