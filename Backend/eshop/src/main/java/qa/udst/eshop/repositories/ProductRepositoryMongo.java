package qa.udst.eshop.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;
import qa.udst.eshop.models.*;
import org.springframework.stereotype.Repository;

//Repository for Products --- Create seperate repos for cart and orders (READ RIZKIIIIII)
@Repository
public interface ProductRepositoryMongo extends MongoRepository<Product, String> {
    List<Product> findByNameContainingIgnoreCase(String q);
    List<Product> findByPriceBetween(double min, double max);
}
