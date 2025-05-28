package model;

public class CartItem {
    private int productId;
    private String productName;
    private double productPrice;
    private int quantity;

    public CartItem(int productId, String productName, double productPrice, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.productPrice = productPrice;
        this.quantity = quantity;
    }

    // Getters and Setters
    public int getProductId() { return productId; }
    public String getProductName() { return productName; }
    public double getProductPrice() { return productPrice; }
    public int getQuantity() { return quantity; }

    public void setQuantity(int quantity) { this.quantity = quantity; }

    @Override
    public String toString() {
        return productName + " - " + quantity + " pcs";
    }
}