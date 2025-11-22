package qa.udst.eshop.models;

import java.time.LocalDateTime;
import java.util.*;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "orders")
public class Order {

    @Id
    private String id;

    private List<OrderItem> items = new ArrayList<>();

    private double total;
    private String status;
    private LocalDateTime createdAt;

    public Order() {
        this.status = "pending";
        this.createdAt = LocalDateTime.now();
    }

    public Order(List<OrderItem> items) {
        this.items = items;
        this.total = calculateTotal();
        this.status = "pending";
        this.createdAt = LocalDateTime.now();
    }

    public String getId() { return id; }
    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public double calculateTotal() {
        return items.stream().mapToDouble(OrderItem::getSubtotal).sum();
    }
}
