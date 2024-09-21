package com.example.MyVPNCentral.Service;

import com.example.MyVPNCentral.Model.RegisOtp;
import com.example.MyVPNCentral.MyException.AppRuntimeException;
import com.example.MyVPNCentral.Repository.RegisOtpRepo;
import org.springframework.stereotype.Service;
import java.security.SecureRandom;
import java.util.Optional;

@Service
public class RegisOtpService {
    private final SecureRandom secureRandom=new SecureRandom();

    //@Autowired
    private final RegisOtpRepo regisOtpRepo;


    public RegisOtpService(RegisOtpRepo regisOtpRepo) {
        this.regisOtpRepo = regisOtpRepo;
    }
    private String generateOtp(){
        return String.format("%06d", secureRandom.nextInt(999999));
    }

    public String generateAndSave(String username) {
            String otp = generateOtp();
            RegisOtp regisOtp = new RegisOtp(username, otp);
            regisOtpRepo.save(regisOtp);
            return otp;
    }

    public boolean verifyOtp(String username,String otp){
            Optional<RegisOtp> optionalOtp=regisOtpRepo.findById(username);
            if (optionalOtp.isPresent()){
                RegisOtp regisOtp = optionalOtp.get();
                if((regisOtp.getOtp()).equals(otp)){
                    return true;
                }
                throw new AppRuntimeException("Otp Invalid");
            }else{
                throw new AppRuntimeException("User Not Exist");
            }
    }

    public void clearOtp(String id){
        regisOtpRepo.deleteById(id);
    }



}
