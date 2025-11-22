package qa.udst.eshop.controllers;

import org.springframework.web.bind.annotation.*;
import qa.udst.eshop.models.Order;
import qa.udst.eshop.services.OrderService;

import java.util.List;

@RestController
@RequestMapping("/orders")
@CrossOrigin(origins = "*")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping("/place/{cartId}")
    public Order placeOrder(@PathVariable String cartId) {
        return orderService.placeOrder(cartId);
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
