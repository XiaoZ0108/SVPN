package com.example.MyVPNCentral.Model;
import com.fasterxml.jackson.annotation.JsonIgnore;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;

@Document(collection="VpnConfig")
public class VPN {

    @Id
    @JsonIgnore
    private String id;
    private String user;

    private String country;
    private String config;

    @JsonIgnore
    private Date createdAt;

    public VPN(String user, String country, String config) {
        this.user = user;
        this.country = country;
        this.config = config;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getConfig() {
        return config;
    }

    public void setConfig(String config) {
        this.config = config;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "VPN{" +
                "id=" + id +
                ", user='" + user + '\'' +
                ", country='" + country + '\'' +
                ", config='" + config + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
