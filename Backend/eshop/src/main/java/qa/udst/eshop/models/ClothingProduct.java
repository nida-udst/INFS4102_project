package qa.udst.eshop.models;

import jakarta.validation.constraints.*;

//Clothing: Size
public class ClothingProduct extends Product{
    @NotBlank
    private String size;

    public ClothingProduct(String name, double price, ProductCategory category, String desc, @NotBlank String size, @NotBlank String imageURL) {
        super(name, price, category, desc, imageURL);
        this.size = size;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }


}
