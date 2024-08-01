package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LiveController {

    @GetMapping("/live")
    public String live() {
        return "Application is live";
    }
}