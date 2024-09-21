package com.example.MyVPNCentral.Service;

import com.example.MyVPNCentral.Model.Message;
import com.example.MyVPNCentral.Model.VPN;
import com.example.MyVPNCentral.MyException.AppRuntimeException;
import com.example.MyVPNCentral.Repository.VpnRepo;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.Date;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class VpnService {

    private final VpnRepo vpnRepo;
    private final JwtService jwtService;
    @Value("${ping.ips}")
    private List<String> ipAddresses;

    public VpnService(VpnRepo vpnRepo,JwtService jwtService) {
        this.vpnRepo = vpnRepo;
        this.jwtService=jwtService;
    }

    public Map<String,String> getPing()throws Exception{
        Map<String,String> pingResults = new HashMap<>();
        String[] country={"Singapore","Australia","Japan"};
        int currentCountry=0;
        for (String ip:ipAddresses){
            ProcessBuilder processBuilder=new ProcessBuilder("ping", "-c", "1", ip);
            Process process = processBuilder.start();
            BufferedReader stdInput = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String s = null;
            StringBuilder message= new StringBuilder();
            int flag=2;
            while((s = stdInput.readLine()) != null &&flag!=0) {
                message.append(s);
                flag-=1;
            }
            int index= message.indexOf("time");
            if(index!=-1){
                pingResults.put(country[currentCountry],message.substring(index+5));
                currentCountry+=1;
            }
        }
        return pingResults;
    }

    public Message requestConfig(String country,String clientName){
        String name=getNameFromMail(clientName);
        //temp hardcode
        String uri="https://jp.magicconchxhell.xyz/getConfig?clientName=ggbom";
         WebClient webClient=WebClient.create();
             return webClient.get().uri(uri).accept().retrieve().bodyToMono(Message.class).block();
    }

    public void storeConfig(VPN vpn){
        vpn.setCreatedAt(Date.from(Instant.now()));
        vpnRepo.save(vpn);
    }

    public VPN retrieveConfig(String email,String country){
        return vpnRepo.findByUserAndCountry(email,country).orElse(null);
    }

    private String getNameFromMail(String uid){
        String[] list=uid.split("@");
        return list[0];
    }


//    private String getSingleIp(String ip)
//            throws Exception
//    {
//
//        ProcessBuilder build = new ProcessBuilder("ping","-c","1",ip);
//        Process process = build.start();
//
//        // to read the output
//        BufferedReader input = new BufferedReader(new InputStreamReader
//                (process.getInputStream()));
//        String s = null;
//        StringBuilder message= new StringBuilder();
//        int flag=2;
//        System.out.println("Standard output: ");
//        while((s = input.readLine()) != null &&flag!=0)
//        {
//
//            message.append(s);
//            flag-=1;
//        }
//        int index= message.indexOf("time")+5;
//        return message.substring(index);
//    }

}
