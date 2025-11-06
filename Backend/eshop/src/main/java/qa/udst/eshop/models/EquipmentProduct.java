package qa.udst.eshop.models;

import jakarta.validation.constraints.*;
import jakarta.persistence.*;

public class EquipmentProduct extends Product{
    @Min(0)
    @NotNull
    private double weight;

    @NotBlank
    private String dimensions;
    
    public EquipmentProduct(String name, double price, ProductCategory category, String desc,
            @Min(0) @NotNull double weight, @NotBlank String dimensions) {
        super(name, price, category, desc);
        this.weight = weight;
        this.dimensions = dimensions;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public String getDimensions() {
        return dimensions;
    }

    public void setDimensions(String dimensions) {
        this.dimensions = dimensions;
    }

    
    
    

    


}
