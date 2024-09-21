package com.example.MyVPNCentral.Model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

public class Message {
    private String message;
   @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String config;

    public Message() {
    }

    public Message(String message) {
        this.message = message;
    }

    public Message(String message, String config) {
        this.message = message;
        this.config = config;
    }

    public String getMessage() {
        return message;
    }
    public void setMessage(String message) {
        this.message = message;
    }

    public String getConfig() {
        return config;
    }

    public void setConfig(String config) {
        this.config = config;
    }

    @Override
    public String toString() {
        return "Message{" +
                "message='" + message + '\'' +
                ", config='" + config + '\'' +
                '}';
    }
}
