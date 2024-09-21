package com.example.MyVPNCentral.Repository;

import com.example.MyVPNCentral.Model.VPN;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface VpnRepo extends MongoRepository<VPN,String> {
    Optional<VPN> findByUserAndCountry(String user, String country);
}
