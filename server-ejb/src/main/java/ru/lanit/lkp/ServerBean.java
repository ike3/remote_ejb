package ru.lanit.lkp;

import javax.ejb.EJB;
import javax.ejb.Stateless;

@Stateless
public class ServerBean implements Server {
    private static int count = 0;

    @Override
    public void run() {
        if (count++ % 1000 == 0) System.err.println(count + " calls on " + System.getProperty("jboss.server.name"));
        try {
            Thread.sleep(1l);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

}
