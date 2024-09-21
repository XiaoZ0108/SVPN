package com.example.MyVPNCentral.Service;

import com.example.MyVPNCentral.Model.MyUser;
import com.example.MyVPNCentral.Model.RegisOtp;
import com.example.MyVPNCentral.Model.TempUser;
import com.example.MyVPNCentral.MyException.AppRuntimeException;
import com.example.MyVPNCentral.Repository.MyUserRepo;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.sql.Date;
import java.time.Instant;


@Service
public class MyUserService {

    private final MyUserRepo myUserRepo;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final MailService mailService;
    private final TempUserService tempUserService;
    private final RegisOtpService regisOtpService;

    public MyUserService(MyUserRepo myUserRepo,PasswordEncoder passwordEncoder,AuthenticationManager authenticationManager,JwtService jwtService,MailService mailService,TempUserService tempUserService,RegisOtpService regisOtpService) {
        this.passwordEncoder=passwordEncoder;
        this.myUserRepo = myUserRepo;
        this.jwtService=jwtService;
        this.authenticationManager=authenticationManager;
        this.mailService=mailService;
        this.tempUserService=tempUserService;
        this.regisOtpService=regisOtpService;
    }
    public void initiateRegis(MyUser myUser){
        MyUser user=getUserById(myUser.getUid());
        if(user==null){
            setTempOtpMail(myUser);
        }else{
            throw new AppRuntimeException("User Already Exist");
        }
    }

    public MyUser RegisterValidation(String email,String otp){
        boolean validated=regisOtpService.verifyOtp(email,otp);
        if(validated){
            TempUser tempUser=tempUserService.findById(email);
            if(tempUser!=null){
                clean(tempUser.getUid());
                return register(new MyUser(tempUser.getUid(),tempUser.getPassword()));
            }else{
                throw new AppRuntimeException("Session Expired");
            }
        }
        throw new AppRuntimeException("Invalid Otp");
    }

    private MyUser register(MyUser myUser) {
        try {
            myUser.setPassword(passwordEncoder.encode(myUser.getPassword()));
            myUser.setCreatedAt(Date.from(Instant.now()));
            return myUserRepo.insert(myUser);
        }catch (Exception e){
            throw new AppRuntimeException("User Already Exist");
        }
    }

    //verify login with username password
    public String loginVerify(MyUser myUser) {
        Authentication authentication=authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(myUser.getUid(),myUser.getPassword()));
        if(authentication.isAuthenticated()){
            return jwtService.generateToken(myUser.getUid());
        }
        throw new AppRuntimeException("Invalid Credential");
    }

    public void resendOtp(String email){
        String otp=regisOtpService.generateAndSave(email);
        mailService.sendEmail(email,otp);
    }

    public void initiateReset(MyUser myUser){
        MyUser user=getUserById(myUser.getUid());
        if(user!=null){
            setTempOtpMail(myUser);
        }else{
            throw new AppRuntimeException("User Not Exist");
        }
    }
    //reset user password
    public void resetUserPassword(RegisOtp regisOtp){
        boolean validated=regisOtpService.verifyOtp(regisOtp.getUid(), regisOtp.getOtp());
        if(validated) {
            TempUser tempUser=tempUserService.findById(regisOtp.getUid());
            if(tempUser!=null){
                MyUser myUser=getUserById(regisOtp.getUid());
                myUser.setPassword(passwordEncoder.encode(tempUser.getPassword()));
                clean(tempUser.getUid());
                myUserRepo.save(myUser);
            }else{
                throw new AppRuntimeException("Session Expired");
            }
        }else {
            throw new AppRuntimeException("Invalid Otp");
        }
    }

    //get certain user
    private MyUser getUserById(String id){
       return myUserRepo.findById(id).orElse(null);
    }

    private void setTempOtpMail(MyUser myUser){
        tempUserService.saveTempUser(new TempUser(myUser.getUid(),myUser.getPassword()));
        resendOtp(myUser.getUid());
    }
    private void clean(String id){
        regisOtpService.clearOtp(id);
        tempUserService.clearTemp(id);
    }



}
