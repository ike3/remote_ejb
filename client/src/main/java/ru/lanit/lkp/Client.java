package ru.lanit.lkp;

import java.util.Properties;
import java.util.stream.IntStream;

import javax.naming.*;

public class Client {
    private static int errorCount = 0;

    public static void main(String[] args) throws Exception {
        String path = "ejb:client/client-ejb-9.0.0-SNAPSHOT/ClientBean!ru.lanit.lkp.Server";
        Server client = (Server) buildContext().lookup(path);

        //while (true) {
            System.out.println("Calling client...");
            client.run("something");
            //client.run("client_error");
            //client.run("server_error");
        //    System.out.println("Press ENTER");
        //    System.in.read();
        //}

        /*
        for (int i = 0; true; i++) {
            if (i%100 == 0) System.err.println("Iteration " + i);
            IntStream.range(1, 16).parallel().forEach(c -> {
                try {
                    server.run();
                } catch (Exception e) {
                    if (errorCount++ % 1000 == 0) System.err.println(errorCount + " error of " + e.getMessage());
                }
            });
        }
        */
    }

    private static Context buildContext() throws NamingException {
        Properties p = new Properties();
        p.put(Context.INITIAL_CONTEXT_FACTORY, "org.jboss.naming.remote.client.InitialContextFactory");
        p.put(Context.URL_PKG_PREFIXES, "org.jboss.ejb.client.naming");
        return new InitialContext(p);
    }

}
