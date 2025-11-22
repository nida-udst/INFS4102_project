package qa.udst.eshop.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import qa.udst.eshop.models.Cart;

@Repository
public interface CartRepository extends MongoRepository<Cart, String> {}
