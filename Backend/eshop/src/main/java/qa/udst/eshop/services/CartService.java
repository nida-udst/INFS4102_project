package qa.udst.eshop.services;

import org.springframework.stereotype.Service;
import qa.udst.eshop.models.*;
import qa.udst.eshop.repositories.*;

import java.util.Optional;

@Service
public class CartService {
    private final CartRepository cartRepo;
    private final ProductRepository productRepo;

    public CartService(CartRepository cartRepo, ProductRepository productRepo) {
        this.cartRepo = cartRepo;
        this.productRepo = productRepo;
    }

    public Cart getCart(Long id) {
        return cartRepo.findById(id).orElseGet(() -> cartRepo.save(new Cart()));
    }

    public Cart addToCart(Long cartId, Long productId, int quantity) {
        Cart cart = getCart(cartId);
        Product product = productRepo.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        cart.addItem(product, quantity);
        return cartRepo.save(cart);
    }

    public Cart removeFromCart(Long cartId, Long productId) {
        Cart cart = getCart(cartId);
        cart.removeItem(productId);
        return cartRepo.save(cart);
    }

    public Cart saveCart(Cart cart) {
        return cartRepository.save(cart);
    }


}
