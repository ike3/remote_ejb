package ru.lanit.lkp;

import javax.ejb.Remote;

@Remote
public interface Server {
    public static int LOG_THRESHOLD = 1;

    public void run(String parameter);
}
