package ru.lanit.lkp;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import java.util.Arrays;

import javax.ejb.*;
import javax.inject.Inject;

import ru.lanit.lkp.db.SomeDao;

@Stateless
@TransactionAttribute(TransactionAttributeType.MANDATORY)
public class ServerBean implements Server {
    private static int count = 0;

    @Override
    public void run(String parameter) {
        if (count++ % Server.LOG_THRESHOLD == 0) System.err.println(count + " calls on " + System.getProperty("jboss.server.name"));

        doSomething(parameter);

        try {
            Thread.sleep(1l);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    @Inject
    private SomeDao dao;

    private String doSomething(String parameter) {
        dao.logJournal("Server is doing something with " + parameter);

        if (Arrays.asList("error", "server_error").contains(parameter)) {
            throw new RuntimeException("Error occured in Server");
        }

        return "done with " + parameter;
    }

}
