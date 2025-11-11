package qa.udst.eshop.services;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import qa.udst.eshop.models.*;
import qa.udst.eshop.repositories.OrderRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final CartService cartService;

    public OrderService(OrderRepository orderRepository, CartService cartService) {
        this.orderRepository = orderRepository;
        this.cartService = cartService;
    }

    @Transactional
    public Order placeOrder(Long cartId) {
        Cart cart = cartService.getCart(cartId);

        List<OrderItem> orderItems = cart.getItems().stream()
                .map(ci -> new OrderItem(ci.getProduct(), ci.getQuantity()))
                .collect(Collectors.toList());

        Order order = new Order(orderItems);
        order.setTotal(order.calculateTotal());
        orderRepository.save(order);

        // clear the cart after placing the order
        cart.getItems().clear();
        cartService.saveCart(cart);

        return order;
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    public Order getOrder(Long id) {
        return orderRepository.findById(id).orElse(null);
    }

    @Transactional
    public Order updateOrderStatus(Long orderId, String status) {
        Order order = getOrder(orderId);
        if (order != null) {
            order.setStatus(status);
            return orderRepository.save(order);
        }
        return null;
    }
}

