package qa.udst.eshop.services;

import java.util.List;

import org.springframework.stereotype.Service;
import qa.udst.eshop.models.*;
import qa.udst.eshop.repositories.*;

@Service
public class ProductService {
    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public Product add(Product product) {
        return productRepository.save(product);
    }

    public List<Product> findAll() {
        return productRepository.findAll();
    }

    public Product findById(Long id) {
        return productRepository.findById(id).orElseThrow(() -> new ProductNotFoundException("Product Not Found"));
    }

    public Product update(Long id, Product product) {
        Product existing = findById(id);
        product.setId(existing.getId());
        return productRepository.save(product);
    }

    public void delete(Long id) {
        Product existing = findById(id);
        productRepository.delete(existing);
    }
}
