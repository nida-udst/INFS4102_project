package qa.udst.eshop.services;

import org.springframework.stereotype.Service;
import qa.udst.eshop.models.*;
import qa.udst.eshop.repositories.*;
import java.util.Optional;

@Service
public class CartService {
    private final CartRepository cartRepo;
    private final ProductRepositoryMongo productRepo;

    public CartService(CartRepository cartRepo, ProductRepositoryMongo productRepo) {
        this.cartRepo = cartRepo;
        this.productRepo = productRepo;
    }

    // Get existing cart or create new
    public Cart getCart(String id) {
        return cartRepo.findById(id).orElseGet(() -> {
            Cart newCart = new Cart();
            return cartRepo.save(newCart);
        });
    }

    private Cart findCartOrCreate(String cartId) {
        return getCart(cartId);
    }

    public Cart addToCart(String cartId, String productId, int quantity) {
        Cart cart = findCartOrCreate(cartId);
        Product product = productRepo.findById(productId)
            .orElseThrow(() -> new RuntimeException("Product not found"));
        cart.addItem(product, quantity);
        return cartRepo.save(cart);
    }

    public Cart removeFromCart(String cartId, String productId) {
        Cart cart = findCartOrCreate(cartId);
        cart.removeItem(productId);
        return cartRepo.save(cart);
    }

    public Cart incrementQuantity(String cartId, String productId) {
        Cart cart = findCartOrCreate(cartId);
        boolean found = false;
        for (CartItem item : cart.getItems()) {
            if (item.getProduct().getId().equals(productId)) {
                item.setQuantity(item.getQuantity() + 1);
                found = true;
                break;
            }
        }
        if (!found) {
            Product product = productRepo.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));
            cart.addItem(product, 1);
        }
        return cartRepo.save(cart);
    }

    public Cart decrementQuantity(String cartId, String productId) {
        Cart cart = findCartOrCreate(cartId);
        CartItem toRemove = null;
        for (CartItem item : cart.getItems()) {
            if (item.getProduct().getId().equals(productId)) {
                int newQty = item.getQuantity() - 1;
                if (newQty <= 0) toRemove = item;
                else item.setQuantity(newQty);
                break;
            }
        }
        if (toRemove != null) cart.getItems().remove(toRemove);
        return cartRepo.save(cart);
    }

    public Cart saveCart(Cart cart) {
        return cartRepo.save(cart);
    }

    public double getTotalCost(String cartId) {
        Cart cart = findCartOrCreate(cartId);
        return cart.getTotal();
    }
}
