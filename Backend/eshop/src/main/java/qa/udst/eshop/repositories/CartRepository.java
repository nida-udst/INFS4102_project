package qa.udst.eshop.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import qa.udst.eshop.models.Cart;

public interface CartRepository extends JpaRepository<Cart, Long> {}
