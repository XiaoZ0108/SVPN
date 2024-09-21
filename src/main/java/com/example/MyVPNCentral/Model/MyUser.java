package com.example.MyVPNCentral.Model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;
import java.util.Date;

@Document(collection="MyUser")
public class MyUser {
    @Id
    private String uid;

    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;
    private boolean premium=false;

    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private long dailyUsageSeconds=0;

    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private LocalDateTime connectTime;
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private LocalDateTime disconnectTime;


    private Date createdAt;

    @JsonCreator
    public MyUser(String uid, @JsonProperty("password") String password) {
        this.uid = uid;
        this.password = password;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isPremium() {
        return premium;
    }

    public void setPremium(boolean premium) {
        this.premium = premium;
    }

    public long getDailyUsageSeconds() {
        return dailyUsageSeconds;
    }

    public void setDailyUsageSeconds(long dailyUsageSeconds) {
        this.dailyUsageSeconds = dailyUsageSeconds;
    }

    public LocalDateTime getConnectTime() {
        return connectTime;
    }

    public void setConnectTime(LocalDateTime connectTime) {
        this.connectTime = connectTime;
    }

    public LocalDateTime getDisconnectTime() {
        return disconnectTime;
    }

    public void setDisconnectTime(LocalDateTime disconnectTime) {
        this.disconnectTime = disconnectTime;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "MyUser{" +
                "uid='" + uid + '\'' +
                ", password='" + password + '\'' +
                ", premium=" + premium +
                ", dailyUsageSeconds=" + dailyUsageSeconds +
                ", connectTime=" + connectTime +
                ", disconnectTime=" + disconnectTime +
                ", createdAt=" + createdAt +
                '}';
    }
}
