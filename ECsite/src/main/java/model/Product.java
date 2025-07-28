package model;


public class Product {
	private int id;
	private String name;
	private int price;
	private String desc;
	private int stock;
	private String img;
	private String deleteun;
	private int type;
	
	
	public Product(int id, String name, int price, String desc, int stock, String img) {
		this.id = id;
		this.name = name;
		this.price = price;
		this.desc = desc;
		this.stock = stock;
		this.img = img;
		this.deleteun = "Y";
	}
	
	public int getType() {
		return type;
	}
	
	public void setType(int type) {
		this.type = type;
	}

	
	public Product() {
	}


	public int getId() {
		return id;
	}

	
	public String getName() {
		return name;
	}

	
	public int getPrice() {
		return price;
	}
	
	public String getDesc() {
		return desc;
	}
	
	public int getStock() {
		return stock;
	}
	
	public String getImg() {
		return img;
	}

//	unen deer en mark tawih
	public String getPriceString() {
		return String.format("%,d", price) + "円";
	}
	
//	endees nemegdene
	
	public String getDeleteun() {
		return deleteun;
	}
	
	
	public void setId(Integer id) {
		 this.id = id;
	}
	
	public void  setName(String name) {
		 this.name = name;
	}

	
	public void   setPrice(Integer price) {
		 this.price = price;
	}
	
	public void  setDesc(String desc) {
		 this.desc = desc;
	}
	
	public void  setStock(Integer stock) {
		 this.stock = stock;
	}
	
	public void  setImg(String img) {
		 this.img = img;
	}
	
	public void setDeleteun(String deleteun) {
		this.deleteun = deleteun;
	}

	private int quantity;

	public int getQuantity() {
	    return quantity;
	}

	public void setQuantity(int quantity) {
	    this.quantity = quantity;
	}
	
	private int totalPrice;

	 public int getTotalPrice() {
	        return totalPrice;
    }

    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }


}
