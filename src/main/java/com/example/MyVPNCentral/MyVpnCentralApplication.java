package com.example.MyVPNCentral;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.config.EnableMongoAuditing;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class MyVpnCentralApplication {

	public static void main(String[] args) {
		SpringApplication.run(MyVpnCentralApplication.class, args);
	}

}
