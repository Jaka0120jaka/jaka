package model;

import java.util.ArrayList;
import java.util.List;

public class Cart {

	private String userId;
	private List<CartItem> items;
	
	public Cart() {
		this.items = new ArrayList<>();
    }

	public Cart(String id) {
		this.userId = id;
		this.items = new ArrayList<>();
	}

	public String getUserId() {
		return userId;
	}

	public List<CartItem> getItems() {
		return items;
	}

	public void add(Product prod, int quantity) {
		for (CartItem item : items) {
			if (item.getProduct().getId() == prod.getId()) {
				item.increaseQuantity(quantity);
				return;
			}
		}
		items.add(new CartItem(prod, quantity));
	}

	public void remove(int index) {
		if (index >= 0 && index < items.size()) {
			items.remove(index);
		}
	}

	public void clear() {
		items.clear();
	}

	public int getTotalPrice() {
		int total = 0;
		for (CartItem item : items) {
			total += item.getProduct().getPrice() * item.getQuantity();
		}
		return total;
	}

	public String getTotalPriceString() {
		return String.format("%,d円", getTotalPrice());
	}

	public int getTotalCount() {
		int count = 0;
		for (CartItem item : items) {
			count += item.getQuantity();
		}
		return count;
	}
	
	public void setUserId(String userId) {
	    this.userId = userId;
	}
}
