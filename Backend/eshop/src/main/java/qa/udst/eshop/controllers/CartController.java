package qa.udst.eshop.controllers;

import org.springframework.web.bind.annotation.*;
import qa.udst.eshop.models.Cart;
import qa.udst.eshop.services.CartService;

@RestController
@RequestMapping("/cart")
@CrossOrigin(origins = "*")
public class CartController {
    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping("/{id}")
    public Cart getCart(@PathVariable Long id) {
        return cartService.getCart(id);
    }

    @PostMapping("/{cartId}/add/{productId}")
    public Cart addProduct(@PathVariable Long cartId,
                           @PathVariable Long productId,
                           @RequestParam int quantity) {
        return cartService.addToCart(cartId, productId, quantity);
    }

    @DeleteMapping("/{cartId}/remove/{productId}")
    public Cart removeProduct(@PathVariable Long cartId,
                              @PathVariable Long productId) {
        return cartService.removeFromCart(cartId, productId);
    }
}
