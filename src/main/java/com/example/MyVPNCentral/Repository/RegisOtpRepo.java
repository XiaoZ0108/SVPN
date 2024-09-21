package com.example.MyVPNCentral.Repository;

import com.example.MyVPNCentral.Model.RegisOtp;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RegisOtpRepo extends MongoRepository<RegisOtp,String> {
}
