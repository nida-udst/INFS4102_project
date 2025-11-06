package qa.udst.eshop.models;
import jakarta.validation.constraints.*;

import org.springframework.data.mongodb.core.mapping.Document;

import jakarta.persistence.*;

@Document(collection = "products") 
public abstract class Product {
    
    @Id
    private String id;

    @NotBlank
    private String name;
    @DecimalMin("0.0")
    private double price;
    ProductCategory category; 
    @NotBlank
    private String desc;

    

    protected Product() { }

    public Product( String name, double price, ProductCategory category, String desc){
        
        setName(name);
        setPrice(price);
        setCategory(category);
        setDesc(desc);
    }

    public void setId(String id){
        this.id = id;
    }

    public String getId(){
        return id;
    }

    public void setName(String name){
        this.name = name;
    }
    
    public String getName(){
        return name;
    }

    public void setPrice(double price){
        this.price = price;
    }

    public double getPrice(){
        return price;
    }

    public void setCategory(ProductCategory category){
        this.category = category;
    }

    public ProductCategory getCategory(){
        return category;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String displayInfo(){
        return "id: "+id+", name: "+name+", price: "+price+", category: "+category;
    }
}
