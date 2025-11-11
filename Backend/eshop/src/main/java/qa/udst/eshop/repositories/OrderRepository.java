package qa.udst.eshop.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import qa.udst.eshop.models.Order;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
}
