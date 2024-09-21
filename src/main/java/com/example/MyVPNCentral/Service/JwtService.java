package com.example.MyVPNCentral.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Service
public class JwtService {
    private final String SECRET_KEY = "secureNetVpnSecureKey0108300xiaoxiaoze23ggbom123456";
    public String generateToken(String username){
        Map<String,Object> claims=new HashMap<>();
        //claims.put("username",username);

        return Jwts.builder()
                .claims()
                .add(claims)
                .subject(username)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() +7*24*60*60*1000))
                .and()
                .signWith(getKey())
                .compact();

    }

    private SecretKey getKey(){

        byte[] keyBytes = Decoders.BASE64.decode(SECRET_KEY);
        return Keys.hmacShaKeyFor(keyBytes);
        //return Jwts.SIG.HS256.key().build();
    }

    private Claims extractAllClaims(String token){
        return Jwts.parser()
                .verifyWith(getKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public String extractUserName(String token){
        return extractClaim(token,Claims::getSubject);
    }

    private <T> T extractClaim(String token, Function<Claims,T> claimsTFunction){
        Claims claims=extractAllClaims(token);
        return claimsTFunction.apply(claims);
    }

    public boolean validateToken(String token, UserDetails userDetails){
        String username=extractUserName(token);
        return username.equals(userDetails.getUsername())&&!isTokenExpired(token);
    }
    //check token expiration
    public boolean isTokenExpired(String token){
        return extractExpiration(token).before(new Date());
    }

    private Date extractExpiration(String token){
        return extractClaim(token,Claims::getExpiration);
    }

}
