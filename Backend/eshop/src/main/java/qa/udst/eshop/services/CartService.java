// ...existing code...
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

    // Get existing cart or create new with email as id
    public Cart getCart(String email) {
        return cartRepo.findById(email).orElseGet(() -> {
            Cart newCart = new Cart(email);
            return cartRepo.save(newCart);
        });
    }

    private Cart findCartOrCreate(String email) {
        return getCart(email);
    }

    public Cart createCart(String email) {
        // If exists, return existing; otherwise create empty cart with id=email
        return cartRepo.findById(email).orElseGet(() -> cartRepo.save(new Cart(email)));
    }

    public Cart addToCart(String email, String productId, int quantity) {
        Cart cart = findCartOrCreate(email);
        productRepo.findById(productId)
            .orElseThrow(() -> new RuntimeException("Product not found"));
        cart.addItem(productId, quantity);
        cart.setId(email);
        return cartRepo.save(cart);
    }

    public Cart removeFromCart(String email, String productId) {
        Cart cart = findCartOrCreate(email);
        cart.removeItem(productId);
        return cartRepo.save(cart);
    }

    public Cart incrementQuantity(String email, String productId) {
        Cart cart = findCartOrCreate(email);
        boolean found = false;
        for (CartItem item : cart.getItems()) {
            if (item.getProductId().equals(productId)) {
                item.setQuantity(item.getQuantity() + 1);
                found = true;
                break;
            }
        }
        if (!found) {
            productRepo.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));
            cart.addItem(productId, 1);
        }
        return cartRepo.save(cart);
    }

    public Cart decrementQuantity(String email, String productId) {
        Cart cart = findCartOrCreate(email);
        CartItem toRemove = null;
        for (CartItem item : cart.getItems()) {
            if (item.getProductId().equals(productId)) {
                int newQty = item.getQuantity() - 1;
                if (newQty <= 0) toRemove = item;
                else item.setQuantity(newQty);
                break;
            }
        }
        if (toRemove != null) cart.getItems().remove(toRemove);
        return cartRepo.save(cart);
    }

    public Cart clearCart(String email) {
        Cart cart = findCartOrCreate(email);
        cart.clear();
        return cartRepo.save(cart);
    }

    public double getTotalCost(String email) {
        Cart cart = findCartOrCreate(email);
        double total = 0.0;
        for (CartItem item : cart.getItems()) {
            Optional<Product> pOpt = productRepo.findById(item.getProductId());
            if (pOpt.isPresent()) {
                total += pOpt.get().getPrice() * item.getQuantity();
            }
        }
        return total;
    }

    public Cart saveCart(Cart cart) {
        return cartRepo.save(cart);
    }
}