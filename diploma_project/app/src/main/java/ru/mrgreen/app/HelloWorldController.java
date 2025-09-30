package ru.mrgreen.app;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/")
public class HelloWorldController {

    @GetMapping
    public Map<String, Object> getMessage() {
        return Map.of("message", "Hello world!");
    }
}
