package model;

public class CartItem {
	private Product product;
	private int quantity;

	public CartItem(Product product, int quantity) {
		this.product = product;
		this.quantity = quantity;
	}

	public Product getProduct() {
		return product;
	}

	public int getQuantity() {
		return quantity;
	}

	public void increaseQuantity(int amount) {
		this.quantity += amount;
	}
	
	public void setQuantity(int quantity) {
	    this.quantity = quantity;
	}
}
