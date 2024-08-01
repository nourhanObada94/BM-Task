package com.example.demo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LiveController {

    @Value("${DATABASE_URL}")
    private String databaseUrl;

    @GetMapping("/live")
    public ResponseEntity<String> live() {
        try {
            // Attempt to connect to the database
            Connection connection = DriverManager.getConnection(databaseUrl);
            connection.close();
            return ResponseEntity.ok("Well done");
        } catch (SQLException e) {
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body("Maintenance");
        }
    }
}
