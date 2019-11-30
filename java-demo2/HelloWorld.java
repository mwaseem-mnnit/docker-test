public class HelloWorld {
    public static void main(String[] args){
        while(true) {
            try {
                Thread.sleep(1000);
                System.out.println("Hello World :) ");
            } catch (java.lang.Exception exception) {
                System.out.println("interrupted");
            }

        }
    }
}