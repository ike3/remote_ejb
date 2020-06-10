package ru.lanit.lkp;

import javax.ejb.EJB;
import javax.ejb.Stateless;

@Stateless
public class ClientBean implements Server {
    private static int count = 0;
    private static int errorCount = 0;

    @EJB(mappedName = "ejb:server/server-ejb-9.0.0-SNAPSHOT/ServerBean!ru.lanit.lkp.Server")
    private Server server;

    @Override
    public void run() {
        if (count++ % 1000 == 0) System.err.println(count + " calls on " + System.getProperty("jboss.server.name") + ", " + errorCount + " errors");
        try {
            Thread.sleep(1l);
        } catch (InterruptedException e) {
            System.err.println(e.getMessage());
        }

        try {
            server.run();
        } catch (Exception e) {
            if (errorCount++ % 1000 == 0) System.err.println(errorCount + " error of " + e.getMessage());
        }
    }

}
