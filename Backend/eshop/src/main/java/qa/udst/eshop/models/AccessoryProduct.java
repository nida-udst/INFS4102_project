package qa.udst.eshop.models;

import jakarta.validation.constraints.*;
import jakarta.persistence.*;

//Accessory Model: + Material
public class AccessoryProduct extends Product{
    @NotBlank
    private String material;

    public AccessoryProduct(String name, double price, ProductCategory category, String desc,
            @NotBlank String material, @NotBlank String image) {
        super(name, price, category, desc, image);
        this.material = material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public String getMaterial() {
        return material;
    }


}
