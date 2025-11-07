package qa.udst.eshop.models;

import jakarta.validation.constraints.*;
import jakarta.persistence.*;


//Equipment Model: + Weight and Dimensions
public class EquipmentProduct extends Product{
    @Min(0)
    @NotNull
    private double weightKg;

    @NotBlank
    private String dimensions;
    
    public EquipmentProduct(String name, double price, ProductCategory category, String desc,
            @Min(0) @NotNull double weight, @NotBlank String dimensions, @NotBlank String image) {
        super(name, price, category, desc, image);
        this.weightKg = weightKg;
        this.dimensions = dimensions;
    }

    public double getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(double weightKg) {
        this.weightKg = weightKg;
    }

    public String getDimensions() {
        return dimensions;
    }

    public void setDimensions(String dimensions) {
        this.dimensions = dimensions;
    }

    
    
    

    


}
