package qa.udst.eshop.services;

import org.springframework.stereotype.Service;
import qa.udst.eshop.models.User;
import qa.udst.eshop.repositories.UserRepository;
import java.util.Optional;

@Service
public class AuthService {
    private final UserRepository userRepository;

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User register(String email, String password) {
        // TODO: hash password in real app
        User user = new User(email, password);
        return userRepository.save(user);
    }

    public User login(String email, String password) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent() && userOpt.get().getPassword().equals(password)) {
            return userOpt.get();
        } else {
            throw new RuntimeException("Invalid email or password");
        }
    }
}
