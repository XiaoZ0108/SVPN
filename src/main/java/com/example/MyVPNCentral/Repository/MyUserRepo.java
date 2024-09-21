package com.example.MyVPNCentral.Repository;

import com.example.MyVPNCentral.Model.MyUser;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MyUserRepo extends MongoRepository<MyUser,String> {
}
