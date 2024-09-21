package com.example.MyVPNCentral.Repository;

import com.example.MyVPNCentral.Model.TempUser;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TempUserRepo extends MongoRepository<TempUser,String> {
}
