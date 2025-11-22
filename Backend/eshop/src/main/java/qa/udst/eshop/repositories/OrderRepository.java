package qa.udst.eshop.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import qa.udst.eshop.models.Order;

@Repository
public interface OrderRepository extends MongoRepository<Order, String> {}
