package qa.udst.eshop.controllers;

import org.springframework.web.bind.annotation.*;
import qa.udst.eshop.models.User;
import qa.udst.eshop.services.AuthService;

@RestController
@RequestMapping("/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public String login(@RequestBody User request) {
        User user = authService.login(request.getEmail(), request.getPassword());
        return user.getId(); // or return a JWT in a real app
    }

    @PostMapping("/register")
    public User register(@RequestBody User request) {
        return authService.register(request.getEmail(), request.getPassword());
    }
}
