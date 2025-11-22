package qa.udst.eshop.models;


public class OrderItem {


    private Long id;

    private String productId;
    private String productName;
    private double price;
    private int quantity;

    public OrderItem() {}

    public OrderItem(Product product, int quantity) {
        this.productId = product.getId();
        this.productName = product.getName();
        this.price = product.getPrice();
        this.quantity = quantity;
    }

    public Long getId() { return id; }
    public String getProductId() { return productId; }
    public String getProductName() { return productName; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getSubtotal() { return price * quantity; }
}
