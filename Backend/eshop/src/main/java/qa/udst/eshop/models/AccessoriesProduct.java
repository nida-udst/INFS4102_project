package qa.udst.eshop.models;

import jakarta.validation.constraints.*;
import jakarta.persistence.*;


public class AccessoriesProduct extends Product{
    @NotBlank
    private String material;

    public AccessoriesProduct(String name, double price, ProductCategory category, String desc,
            @NotBlank String material) {
        super(name, price, category, desc);
        this.material = material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public String getMaterial() {
        return material;
    }


}
