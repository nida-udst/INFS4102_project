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
    public Order placeOrder(String cartId) {
        Cart cart = cartService.getCart(cartId);

        List<OrderItem> orderItems = cart.getItems().stream()
                .map(ci -> new OrderItem(ci.getProduct(), ci.getQuantity()))
                .collect(Collectors.toList());

        Order order = new Order(orderItems);
        order.setTotal(order.calculateTotal());
        orderRepository.save(order);

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

