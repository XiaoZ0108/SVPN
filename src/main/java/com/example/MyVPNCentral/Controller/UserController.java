package com.example.MyVPNCentral.Controller;

import com.example.MyVPNCentral.Model.Message;
import com.example.MyVPNCentral.Model.MyUser;
import com.example.MyVPNCentral.Model.RegisOtp;
import com.example.MyVPNCentral.Service.MyUserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
public class UserController {

    private final MyUserService myUserService;

    public UserController(MyUserService myUserService) {
        this.myUserService = myUserService;
    }

    @PostMapping("/register")
    public ResponseEntity<Message> registerInit(@RequestBody MyUser myUser){
       myUserService.initiateRegis(myUser);
       return ResponseEntity.ok().body(new Message("Registration Initialize ,Email send"));
    }

    @PostMapping("/vRegister")
    public ResponseEntity<MyUser> addUser(@RequestBody RegisOtp regisOtp){
      MyUser newUser= myUserService.RegisterValidation(regisOtp.getUid(), regisOtp.getOtp());
        return ResponseEntity.ok().body(newUser);
    }

    @PostMapping("/login")
    public String login(@RequestBody MyUser myUser){
        return myUserService.loginVerify(myUser);
    }


    @GetMapping("/mail")
    public ResponseEntity<Message> checkMail(@RequestParam String uid){
        return ResponseEntity.ok().build();
    }

    @PostMapping("/reset")
    public ResponseEntity<Message> resetInit(@RequestBody MyUser myUser){
        myUserService.initiateReset(myUser);
        return ResponseEntity.ok().body(new Message("Reset Password Initialize ,Email send"));
    }

    @PostMapping("/vReset")
    public ResponseEntity<Message> resetPassword(@RequestBody RegisOtp regisOtp){
        myUserService.resetUserPassword(regisOtp);
        return ResponseEntity.ok().body(new Message("Password Reset Successfully"));
    }

    @GetMapping("/test")
    public String test(){
        return "Hello";
    }
}
