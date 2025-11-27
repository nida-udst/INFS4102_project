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

    @GetMapping("/{cartId}")
    public Cart getCart(@PathVariable String cartId) {
        return cartService.getCart(cartId);
    }

    @PostMapping("/{cartId}/add/{productId}")
    public Cart addProduct(@PathVariable String cartId, @PathVariable String productId, @RequestParam int quantity) {
        return cartService.addToCart(cartId, productId, quantity);
    }

    @DeleteMapping("/{cartId}/remove/{productId}")
    public Cart removeProduct(@PathVariable String cartId, @PathVariable String productId) {
        return cartService.removeFromCart(cartId, productId);
    }

    @PutMapping("/{cartId}/increment/{productId}")
    public Cart incrementProduct(@PathVariable String cartId, @PathVariable String productId) {
        return cartService.incrementQuantity(cartId, productId);
    }

    @PutMapping("/{cartId}/decrement/{productId}")
    public Cart decrementProduct(@PathVariable String cartId, @PathVariable String productId) {
        return cartService.decrementQuantity(cartId, productId);
    }

    @GetMapping("/{cartId}/total")
    public double getTotal(@PathVariable String cartId) {
        return cartService.getTotalCost(cartId);
    }
}
