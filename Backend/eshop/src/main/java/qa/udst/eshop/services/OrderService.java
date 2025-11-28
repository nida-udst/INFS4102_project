// ...existing code...
package qa.udst.eshop.services;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import qa.udst.eshop.models.*;
import qa.udst.eshop.repositories.OrderRepository;
import qa.udst.eshop.repositories.ProductRepositoryMongo;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final CartService cartService;
    private final ProductRepositoryMongo productRepository;

    public OrderService(OrderRepository orderRepository, CartService cartService, ProductRepositoryMongo productRepository) {
        this.orderRepository = orderRepository;
        this.cartService = cartService;
        this.productRepository = productRepository;
    }

    @Transactional
    // now accepts paymentMethod
    public Order placeOrder(String email, String paymentMethod) {
        Cart cart = cartService.getCart(email);

        List<OrderItem> orderItems = cart.getItems().stream()
                .map(ci -> {
                    Product product = productRepository.findById(ci.getProductId())
                            .orElseThrow(() -> new RuntimeException("Product not found: " + ci.getProductId()));
                    return new OrderItem(product, ci.getQuantity());
                })
                .collect(Collectors.toList());

        Order order = new Order(orderItems, email, paymentMethod);
        order.setTotal(order.calculateTotal());
        order.setStatus("pending");
        orderRepository.save(order);

        // clear cart after placing order
        cart.getItems().clear();
        cartService.saveCart(cart);

        return order;
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    public Order getOrder(String id) {
        return orderRepository.findById(id).orElse(null);
    }

    @Transactional
    public Order updateOrderStatus(String orderId, String status) {
        Order order = getOrder(orderId);
        if (order != null) {
            order.setStatus(status);
            return orderRepository.save(order);
        }
        return null;
    }
}
