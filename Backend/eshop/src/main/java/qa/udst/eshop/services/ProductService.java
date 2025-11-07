package qa.udst.eshop.services;

import java.util.List;

import org.springframework.stereotype.Service;
import qa.udst.eshop.models.*;
import qa.udst.eshop.repositories.*;

//Service for Products Catalog --- Create seperate service for cart and orders
@Service
public class ProductService {

    private final ProductRepositoryMongo productRepository;

    public ProductService(ProductRepositoryMongo productRepository) {
        this.productRepository = productRepository;
    }

    public Product add(Product product) {
        return productRepository.save(product);
    }

    public List<Product> findAll() {
        return productRepository.findAll();
    }

    public Product findById(String id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException("Product Not Found"));
    }

    public Product update(String id, Product product) {
        Product existing = findById(id);
        product.setId(existing.getId());
        return productRepository.save(product);
    }

    public void delete(String id) {
        Product existing = findById(id);
        productRepository.delete(existing);
    }
}
