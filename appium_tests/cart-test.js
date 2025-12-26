describe("Cart Test", () => {
  it("should open a product and click Add to Cart", async () => {
    // Wait for home screen products to load
    const firstProduct = await $("~productItem0"); // Make sure your first product has a Key like this
    await firstProduct.waitForExist({ timeout: 10000 });
    await firstProduct.click();

    // Wait for product details page
    const addToCartButton = await $("~addToCartButton"); // Add Key in Flutter
    await addToCartButton.waitForExist({ timeout: 5000 });

    // Click Add to Cart
    await addToCartButton.click();

    console.log("Add to Cart button clicked successfully.");
  });
});
