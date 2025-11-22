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

    public Cart getCart(String id) {
        return cartRepo.findById(id).orElseGet(() -> cartRepo.save(new Cart()));
    }

    public Cart addToCart(String cartId, String productId, int quantity) {
        Cart cart = getCart(cartId);
        Product product = productRepo.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        cart.addItem(product, quantity);
        return cartRepo.save(cart);
    }

    public Cart removeFromCart(String cartId, String productId) {
        Cart cart = getCart(cartId);
        cart.removeItem(productId);
        return cartRepo.save(cart);
    }

    public Cart saveCart(Cart cart) {
        return cartRepo.save(cart);
    }


}
