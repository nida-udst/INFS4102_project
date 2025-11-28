// ...existing code...
package qa.udst.eshop.controllers;

import org.springframework.web.bind.annotation.*;
import qa.udst.eshop.models.Order;
import qa.udst.eshop.services.OrderService;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/orders")
@CrossOrigin(origins = "*")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    // place order using user email as the cart id
    // now accepts paymentMethod in request body JSON: { "paymentMethod": "Credit Card" }
    @PostMapping("/place/{email}")
    public Order placeOrder(@PathVariable String email, @RequestBody(required = false) Map<String, String> body) {
        String paymentMethod = "unknown";
        if (body != null && body.get("paymentMethod") != null) {
            paymentMethod = body.get("paymentMethod");
        }
        return orderService.placeOrder(email, paymentMethod);
    }

    @GetMapping
    public List<Order> getAllOrders() {
        return orderService.getAllOrders();
    }

    @GetMapping("/{id}")
    public Order getOrder(@PathVariable String id) {
        return orderService.getOrder(id);
    }

    @PutMapping("/{id}/status")
    public Order updateOrderStatus(@PathVariable String id, @RequestParam String status) {
        return orderService.updateOrderStatus(id, status);
    }
}
// ...existing code...