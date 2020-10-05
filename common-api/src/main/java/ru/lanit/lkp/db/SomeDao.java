package ru.lanit.lkp.db;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.Timestamp;
import java.util.List;

import javax.enterprise.context.ApplicationScoped;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@ApplicationScoped
public class SomeDao {
    @PersistenceContext
    private EntityManager em;


    public void logJournal(String name) {
        String user = System.getProperty("jboss.server.name");

        try {
            String host = InetAddress.getLocalHost().getHostName();
            user += "/" + host;
        } catch (UnknownHostException e) {
            // nothing
        }

        List<?> list = em.createQuery("from OperationJournal where user = :user").setParameter("user", user).getResultList();
        OperationJournal o = list.isEmpty() ? new OperationJournal() : (OperationJournal) list.get(0);

        o.setName(name);
        o.setUser(user);
        o.setTmstmp(new Timestamp(System.currentTimeMillis()));
        em.merge(o);
    }
}
