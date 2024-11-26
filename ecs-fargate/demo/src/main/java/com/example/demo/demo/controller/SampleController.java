package com.example.demo.demo.controller;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;


@RestController
public class SampleController {
    
    @GetMapping("/")
    public String getMethodName() {
        return "hello ECS Fargate";
    }
    
}
