package qa.udst.eshop.models;

import jakarta.validation.constraints.*;

//Nutrition Model: + Weight(Kg) minimal 0.03
public class NutritionProduct extends Product{
    @NotNull
    @DecimalMin("0.03")
    private double weightKg;

    @DecimalMin("0.0")
    private double calories;


    public NutritionProduct(String name, double price, ProductCategory category, String desc,
            @NotNull @DecimalMin("0.03") double weightKg, @NotBlank String imageURL, @DecimalMin("0.0") double calories) {
        super(name, price, category, desc, imageURL);
        this.weightKg = weightKg;
        this.calories = calories;
    }

    public double getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(double weightKg) {
        this.weightKg = weightKg;
    }
    
    public double getCalories() {
        return calories;
    }

    public void setCalories(double calories) {
        this.calories = calories;
    }

}
