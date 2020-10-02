package ru.lanit.lkp.db;

import java.sql.Timestamp;

import javax.persistence.*;

@Entity
@Table(name = "OPERATION_JOURNAL")
public class OperationJournal {
    @Column(name = "OP_JOURNAL_ID")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SEQ_OPERATION_JOURNAL")
    @Id
    private Long id;

    @Column(name = "EVENT_NAME")
    private String name;

    @Column(name = "USER_UID")
    private String user;

    @Column(name = "TMSTMP")
    private Timestamp tmstmp;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public Timestamp getTmstmp() {
        return tmstmp;
    }

    public void setTmstmp(Timestamp tmstmp) {
        this.tmstmp = tmstmp;
    }

}
