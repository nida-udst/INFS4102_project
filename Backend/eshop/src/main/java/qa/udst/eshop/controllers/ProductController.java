package qa.udst.eshop.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.service.annotation.DeleteExchange;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import org.apache.catalina.connector.Response;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;

import io.swagger.v3.oas.annotations.media.Content;
import jakarta.validation.Valid;

import java.util.*;

import qa.udst.eshop.models.*;
import qa.udst.eshop.services.*;

//Controller for Product Catalog --- Create seperate controllers for cart and orders
@RestController
@RequestMapping("/eshop")
@CrossOrigin(origins = "*")
public class ProductController {

    private final ProductService service;
    public ProductController(@Valid ProductService service){
        this.service = service;
    }

    @GetMapping("/product-catalog")
    public List<Product> getAll() {
        return service.findAll();
    }

    @GetMapping("/product-catalog/{id}")
    public ResponseEntity<Product> getById(@Valid @PathVariable String id) {
        Product saved = service.findById(id);
        return ResponseEntity.status(200).body(saved);
    }

    @PostMapping("/equipment")
    public ResponseEntity<Product> addEquipment(@Valid @RequestBody EquipmentProduct product) {
        Product saved = service.add(product);
        return ResponseEntity.status(201).body(saved);
    }
    
    @PostMapping("/clothing")
    public ResponseEntity<Product> addClothing(@Valid @RequestBody ClothingProduct product) {
        Product saved = service.add(product);
        return ResponseEntity.status(201).body(saved);
    }

    @PostMapping("/accessory")
    public ResponseEntity<Product> addAccessory(@Valid @RequestBody AccessoryProduct product) {
        Product saved = service.add(product);
        return ResponseEntity.status(201).body(saved);
    }

    @PostMapping("/nutrition")
    public ResponseEntity<Product> addNutrition(@Valid @RequestBody NutritionProduct product) {
        Product saved = service.add(product);
        return ResponseEntity.status(201).body(saved);
    }

    @PutMapping("/product-catalog/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable String id, @Valid @RequestBody Product product) {
        Product updated = service.update(id, product);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/product-catalog/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable String id) {
        service.delete(id);
        return ResponseEntity.noContent().build(); // 204 No Content
    }
    
}
