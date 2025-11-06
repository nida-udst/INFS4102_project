package qa.udst.eshop.models;

import jakarta.validation.constraints.*;
import jakarta.persistence.*;

public class EquipmentProduct extends Product{
    @Min(0)
    @NotNull
    private double weight;
    @NotBlank
    private String dimensions;

    public EquipmentProduct(String name, double price, ProductCategory category, @NotBlank double weight, Long dimensions) {
        super(name, price, category);
        this.weight = weight;
        this.dimensions = dimensions;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public Long getDimensions() {
        return dimensions;
    }

    public void setDimensions(Long dimensions) {
        this.dimensions = dimensions;
    }
    
    

    


}
