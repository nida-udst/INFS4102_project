package qa.udst.eshop.models;

import jakarta.validation.constraints.*;
import jakarta.persistence.*;


public class ClothingProduct extends Product{
    @NotBlank
    private String size;

    public ClothingProduct(String name, double price, ProductCategory category, String desc, @NotBlank String size) {
        super(name, price, category, desc);
        this.size = size;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }


}
