package com.example.MyVPNCentral.Model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;

@Document(collection="RegisOtp")
public class RegisOtp {

    @Id
    private String uid;
    private String otp;
    @Indexed(name="createDateIndex",expireAfterSeconds = 600)
    private Date createdAt;

    public RegisOtp(String uid, String otp) {
        this.uid = uid;
        this.otp = otp;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "RegisOtp{" +
                "uid='" + uid + '\'' +
                ", otp='" + otp + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
