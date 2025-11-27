package qa.udst.eshop.models;

import java.util.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "cart")
public class Cart {
    @Id
    private String id;
    private List<CartItem> items = new ArrayList<>();

    public Cart() {}

    public List<CartItem> getItems() { return items; }

    public void addItem(Product product, int quantity) {
        for (CartItem item : items) {
            if (item.getProduct().getId().equals(product.getId())) {
                item.setQuantity(item.getQuantity() + quantity);
                return;
            }
        }
        items.add(new CartItem(product, quantity));
    }

    public void removeItem(String productId) {
        items.removeIf(i -> i.getProduct().getId().equals(productId));
    }

    public double getTotal() {
        return items.stream().mapToDouble(CartItem::getSubtotal).sum();
    }
}
