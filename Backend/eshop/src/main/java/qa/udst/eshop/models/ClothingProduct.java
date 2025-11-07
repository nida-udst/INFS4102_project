package qa.udst.eshop.models;

import jakarta.validation.constraints.*;
import jakarta.persistence.*;

//Clothing: Size
public class ClothingProduct extends Product{
    @NotBlank
    private String size;

    public ClothingProduct(String name, double price, ProductCategory category, String desc, @NotBlank String size, @NotBlank String image) {
        super(name, price, category, desc, image);
        this.size = size;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }


}
