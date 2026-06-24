package com.procureflow.integration;
import java.time.Instant;
import java.util.*;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/api/integration")
public class IntegrationController {
  @GetMapping("/health") public Map<String,String> health(){ return Map.of("status","UP","service","integration-runtime"); }
  @GetMapping public Map<String,Object> info(){ return Map.of("pattern","validate-transform-route-retry","mode","WebMethods-style simulation"); }
  @PostMapping("/transform") public Map<String,Object> transform(@RequestBody Map<String,Object> input){
    return Map.of("source",input,"canonicalType","PROCUREMENT_ORDER","transformedAt",Instant.now().toString());
  }
}
