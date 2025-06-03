import streamlit as st
import pandas as pd

# Sample product data
products = pd.DataFrame({
    "Product": ["Rose Teddy", "Customized Mug", "LED Frame"],
    "Description": [
        "A teddy bear made of roses.",
        "Mug with your custom text/photo.",
        "LED-lit photo frame for memorable moments."
    ],
    "Price": [25, 15, 35],
    "Image": [
        "https://via.placeholder.com/300x200?text=Rose+Teddy",
        "https://via.placeholder.com/300x200?text=Customized+Mug",
        "https://via.placeholder.com/300x200?text=LED+Frame"
    ],
    "Rating": [4.5, 4.7, 4.8]
})

# Initialize cart session state
if "cart" not in st.session_state:
    st.session_state.cart = []

# Title and nav
st.set_page_config(page_title="Gift Hub", layout="wide")
st.title("🎁 Welcome to Gift Hub")

# Navigation
nav = st.sidebar.radio("Navigate", ["Home", "Shop", "Cart", "Contact Us"])

# HOME
if nav == "Home":
    st.header("Modern Gifts for Every Occasion")
    st.write("Explore our handpicked collection of elegant and personalized gifts.")

# SHOP
elif nav == "Shop":
    st.header("🛍️ Our Products")
    cols = st.columns(3)

    for idx, row in products.iterrows():
        with cols[idx % 3]:
            st.image(row["Image"], use_column_width=True)
            st.subheader(row["Product"])
            st.write(row["Description"])
            st.write(f"💲 Price: ${row['Price']}")
            st.write(f"⭐ Rating: {row['Rating']}")
            if st.button(f"Add to Cart - {row['Product']}", key=row["Product"]):
                st.session_state.cart.append(row["Product"])
                st.success(f"Added {row['Product']} to cart!")

# CART
elif nav == "Cart":
    st.header("🛒 Your Cart")
    if st.session_state.cart:
        cart_items = pd.Series(st.session_state.cart).value_counts().reset_index()
        cart_items.columns = ["Product", "Quantity"]
        cart_items = cart_items.merge(products[["Product", "Price"]], on="Product")
        cart_items["Total"] = cart_items["Quantity"] * cart_items["Price"]

        st.table(cart_items[["Product", "Quantity", "Price", "Total"]])
        st.write(f"**Total Cost:** ${cart_items['Total'].sum():.2f}")

        if st.button("Checkout"):
            st.success("Thank you for your purchase!")
            st.session_state.cart.clear()
    else:
        st.info("Your cart is empty.")

# CONTACT
elif nav == "Contact Us":
    st.header("📞 Get in Touch")
    st.write("Have questions or need help? Contact us below.")
    name = st.text_input("Your Name")
    email = st.text_input("Your Email")
    message = st.text_area("Your Message")

    if st.button("Send Message"):
        if name and email and message:
            st.success("Message sent! We'll get back to you soon.")
        else:
            st.warning("Please fill out all fields.")


