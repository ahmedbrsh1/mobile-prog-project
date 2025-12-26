describe("Auth Test", () => {
  it("should select Men, sign up, login, and reach home screen", async () => {
    const email = "testuser@example.com";
    const password = "123456";

    // Wait for Men button (instead of skip) and click
    const menButton = await $("~menButton");
    await menButton.waitForExist({ timeout: 15000 });
    await menButton.click();

    // Wait for the second page's Create Account button
    const createAccountButton = await $("~createAccountButton");
    await createAccountButton.waitForExist({ timeout: 5000 });
    await createAccountButton.click();

    // Sign up
    const emailField = await $("~emailField");
    await emailField.waitForExist({ timeout: 5000 });
    await emailField.setValue(email);

    const passwordField = await $("~passwordField");
    await passwordField.waitForExist({ timeout: 5000 });
    await passwordField.setValue(password);

    const signupButton = await $("~signupButton");
    await signupButton.waitForExist({ timeout: 5000 });
    await signupButton.click();

    // Login
    const loginButton = await $("~loginButton");
    await loginButton.waitForExist({ timeout: 5000 });
    await loginButton.click();

    // Verify Home screen
    const homeScreen = await $("~homeScreen");
    await homeScreen.waitForExist({ timeout: 5000 });
    const isDisplayed = await homeScreen.isDisplayed();
    console.log("Home screen displayed:", isDisplayed);
    expect(isDisplayed).toBe(true);
  });
});
