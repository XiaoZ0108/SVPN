package com.example.MyVPNCentral.Service;

import com.example.MyVPNCentral.Model.TempUser;
import com.example.MyVPNCentral.Repository.TempUserRepo;
import org.springframework.stereotype.Service;

@Service
public class TempUserService {

    private final TempUserRepo tempUserRepo;

    public TempUserService(TempUserRepo tempUserRepo) {
        this.tempUserRepo = tempUserRepo;
    }

    public TempUser findById(String id){
        return tempUserRepo.findById(id).orElse(null);
    }

    public void saveTempUser(TempUser tempUser){
        tempUserRepo.save(tempUser);
    }
    public void clearTemp(String id){
        tempUserRepo.deleteById(id);
    }
}
