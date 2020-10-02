package ru.lanit.lkp;

import javax.ejb.Remote;

@Remote
public interface Server {
    public void run(String parameter);
}
