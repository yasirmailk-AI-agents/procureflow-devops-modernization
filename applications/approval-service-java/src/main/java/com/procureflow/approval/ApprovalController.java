package com.procureflow.approval;
import java.time.Instant;
import java.util.*;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/api/approvals")
public class ApprovalController {
  @GetMapping("/health") public Map<String,String> health(){ return Map.of("status","UP","service","approval-service"); }
  @GetMapping public Map<String,Object> status(){ return Map.of("service","approval-service","policy","amount <= 10000 auto-approved"); }
  @PostMapping public Map<String,Object> approve(@RequestBody Map<String,Object> request){
    double amount = Double.parseDouble(String.valueOf(request.getOrDefault("amount",0)));
    return Map.of("orderId",request.getOrDefault("orderId","unknown"),"decision",amount <= 10000 ? "APPROVED" : "MANUAL_REVIEW","evaluatedAt",Instant.now().toString());
  }
}
