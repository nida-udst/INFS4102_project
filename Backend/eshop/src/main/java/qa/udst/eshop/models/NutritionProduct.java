package qa.udst.eshop.models;

import jakarta.validation.constraints.*;
import jakarta.persistence.*;

public class NutritionProduct extends Product{
    @NotNull
    @DecimalMax("0.03")
    private double weight;

    public NutritionProduct(String name, double price, ProductCategory category, String desc,
            @NotNull @DecimalMax("0.03") double weight) {
        super(name, price, category, desc);
        this.weight = weight;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }


}
