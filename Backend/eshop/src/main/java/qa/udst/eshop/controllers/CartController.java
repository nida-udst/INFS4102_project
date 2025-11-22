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
    public Cart getCart(@PathVariable String id) {
        return cartService.getCart(id);
    }

    @PostMapping("/add/{productId}")
    public Cart addProduct(@PathVariable String cartId,
                           @PathVariable String productId,
                           @RequestParam int quantity) {
        return cartService.addToCart(cartId, productId, quantity);
    }

    @DeleteMapping("/{cartId}/remove/{productId}")
    public Cart removeProduct(@PathVariable String cartId,
                              @PathVariable String productId) {
        return cartService.removeFromCart(cartId, productId);
    }
}
