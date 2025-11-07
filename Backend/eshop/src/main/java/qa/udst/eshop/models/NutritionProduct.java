package qa.udst.eshop.models;

import jakarta.validation.constraints.*;
import jakarta.persistence.*;

//Nutrition Model: + Weight(g) minimal 0.03
public class NutritionProduct extends Product{
    @NotNull
    @DecimalMin("0.03")
    private double weight;

    @DecimalMin("0.0")
    private double calories;


    public NutritionProduct(String name, double price, ProductCategory category, String desc,
            @NotNull @DecimalMin("0.03") double weight, @NotBlank String image, @DecimalMin("0.0") double calories) {
        super(name, price, category, desc, image);
        this.weight = weight;
        this.calories = calories;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }
    
    public double getCalories() {
        return calories;
    }

    public void setCalories(double calories) {
        this.calories = calories;
    }

}
