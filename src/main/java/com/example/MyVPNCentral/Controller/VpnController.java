package com.example.MyVPNCentral.Controller;

import com.example.MyVPNCentral.Model.Message;
import com.example.MyVPNCentral.Model.MyUserPrincipal;
import com.example.MyVPNCentral.Model.VPN;
import com.example.MyVPNCentral.MyException.AppRuntimeException;
import com.example.MyVPNCentral.Service.VpnService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/vpn")
public class VpnController {

    @Autowired
    private VpnService vpnService;
    @GetMapping("/try")
    public  Map<String,String> test(){
        Map<String,String> mapp=new HashMap<>();
        mapp.put("abu","ali");
        mapp.put("gg","ali");mapp.put("g12","ali");mapp.put("g44","ali");

        return mapp;
    }

    @GetMapping("/getPing")
    public Map<String,String> getPing(){
        try{
            return vpnService.getPing();
        }catch (Exception e){
            throw new AppRuntimeException("Internal Error");
        }
    }

    @GetMapping("/getConfig")
    public ResponseEntity<VPN> getConfig(@RequestParam String country){
       Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Object principal = authentication.getPrincipal();
        VPN vpn=null;
        if(principal instanceof MyUserPrincipal){
            String name=((MyUserPrincipal) principal).getUsername();
            vpn=vpnService.retrieveConfig(name,country);
            if(vpn!=null){
                return  ResponseEntity.ok().body(vpn);
            }else{
                Message message= vpnService.requestConfig(country,name);
                if(message.getConfig()!=null){
                    vpn=new VPN(name,country,message.getConfig());
                    vpnService.storeConfig(vpn);
                    return ResponseEntity.ok().body(vpn);
                }
                throw new AppRuntimeException("Configuration fetching error");
            }
        }
        throw new AppRuntimeException("Error In Internal Authentication Service");
    }

}
