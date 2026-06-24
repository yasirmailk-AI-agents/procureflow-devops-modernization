package com.procureflow.order;
import java.time.Instant;
import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/api/orders")
public class OrderController {
  private final List<Map<String,Object>> orders = new CopyOnWriteArrayList<>();
  @GetMapping("/health") public Map<String,String> health(){ return Map.of("status","UP","service","order-service"); }
  @GetMapping public Map<String,Object> list(){ return Map.of("count",orders.size(),"orders",orders); }
  @PostMapping @ResponseStatus(HttpStatus.CREATED)
  public Map<String,Object> create(@RequestBody Map<String,Object> request){
    Map<String,Object> order = new LinkedHashMap<>(request);
    order.put("id", UUID.randomUUID().toString()); order.put("status","CREATED"); order.put("createdAt", Instant.now().toString());
    orders.add(order); return order;
  }
}
