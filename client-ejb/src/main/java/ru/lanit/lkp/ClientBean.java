package ru.lanit.lkp;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import java.util.Arrays;

import javax.ejb.*;
import javax.inject.Inject;

import ru.lanit.lkp.db.SomeDao;

@Stateless
@TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
public class ClientBean implements Server {
    private static int count = 0;
    private static int errorCount = 0;

    @EJB(mappedName = "ejb:server/server-ejb-9.0.0-SNAPSHOT/ServerBean!ru.lanit.lkp.Server")
    private Server server;

    @Override
    public void run(String parameter) {
        if (count++ % Server.LOG_THRESHOLD == 0) System.err.println(count + " calls on " + System.getProperty("jboss.server.name") + ", " + errorCount + " errors");
        try {
            Thread.sleep(1l);
        } catch (InterruptedException e) {
            System.err.println(e.getMessage());
        }

        try {
            server.run(parameter);
        } catch (Exception e) {
            if (errorCount++ % Server.LOG_THRESHOLD == 0) System.err.println(errorCount + " error of " + e.getMessage());
            if (Server.LOG_THRESHOLD == 1) e.printStackTrace();
        }

        doSomething(parameter);
    }

    @Inject
    private SomeDao dao;

    private String doSomething(String parameter) {
        dao.logJournal("Client is doing something with " + parameter);

        if (Arrays.asList("error", "client_error").contains(parameter)) {
            throw new RuntimeException("Error occured in Client");
        }

        return "done with " + parameter;
    }
}
