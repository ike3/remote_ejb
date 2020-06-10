package ru.lanit.lkp;

import java.util.Properties;
import java.util.stream.IntStream;

import javax.naming.*;

public class Client {
    public static void main(String[] args) throws Exception {
        String path = "ejb:client/client-ejb-9.0.0-SNAPSHOT/ClientBean!ru.lanit.lkp.Server";
        Server server = (Server) buildContext().lookup(path);

        for (int i = 0; true; i++) {
            if (i%100 == 0) System.err.println("Iteration " + i);
            IntStream.range(1, 16).parallel().forEach(c -> {
                try {
                    server.run();
                } catch (Exception e) {
                    System.err.println(e.getMessage());
                }
            });
        }
    }

    private static Context buildContext() throws NamingException {
        Properties p = new Properties();
        p.put(Context.INITIAL_CONTEXT_FACTORY, "org.jboss.naming.remote.client.InitialContextFactory");
        p.put(Context.URL_PKG_PREFIXES, "org.jboss.ejb.client.naming");
        return new InitialContext(p);
    }

}
