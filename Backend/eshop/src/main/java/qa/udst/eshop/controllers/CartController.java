// ...existing code...
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

    // Get or create a cart for the user email
    @GetMapping("/{email}")
    public Cart getCart(@PathVariable String email) {
        return cartService.getCart(email);
    }

    // Explicit create cart
    @PostMapping("/{email}/create")
    public Cart createCart(@PathVariable String email) {
        return cartService.createCart(email);
    }

    // Add product (or increase by quantity)
    @PostMapping("/{email}/add/{productId}")
    public Cart addProduct(@PathVariable String email, @PathVariable String productId, @RequestParam int quantity) {
        return cartService.addToCart(email, productId, quantity);
    }

    // Remove product entry from cart
    @DeleteMapping("/{email}/remove/{productId}")
    public Cart removeProduct(@PathVariable String email, @PathVariable String productId) {
        return cartService.removeFromCart(email, productId);
    }

    // Clear all items in cart
    @PostMapping("/{email}/clear")
    public Cart clearCart(@PathVariable String email) {
        return cartService.clearCart(email);
    }

    @PutMapping("/{email}/increment/{productId}")
    public Cart incrementProduct(@PathVariable String email, @PathVariable String productId) {
        return cartService.incrementQuantity(email, productId);
    }

    @PutMapping("/{email}/decrement/{productId}")
    public Cart decrementProduct(@PathVariable String email, @PathVariable String productId) {
        return cartService.decrementQuantity(email, productId);
    }

    @GetMapping("/{email}/total")
    public double getTotal(@PathVariable String email) {
        return cartService.getTotalCost(email);
    }
}