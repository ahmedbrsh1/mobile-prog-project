# Mobile App Test Cases Documentation

## Tools and Versions

| Tool           | Version |
| -------------- | ------- |
| Node.js        | 18.x    |
| Appium         | 1.22.3  |
| WebdriverIO    | Latest  |
| Test Framework | Mocha   |

---

## Test Case 1: Authentication Flow

### Test ID: AUTH-001

### Description

Validates complete user authentication from app launch through signup, login, and navigation to home screen.

### Pre-conditions

- App installed on device
- Test user credentials available
- App not logged in
- Internet connection active

### Test Data

- Email: `testuser@example.com`
- Password: `123456`

### Test Steps

| Step | Action                       | Element Locator        |
| ---- | ---------------------------- | ---------------------- |
| 1    | Launch app                   | -                      |
| 2    | Wait and click Men button    | `~menButton`           |
| 3    | Click Create Account button  | `~createAccountButton` |
| 4    | Enter email address          | `~emailField`          |
| 5    | Enter password               | `~passwordField`       |
| 6    | Click Sign Up button         | `~signupButton`        |
| 7    | Click Login button           | `~loginButton`         |
| 8    | Verify Home screen displayed | `~homeScreen`          |

### Expected Results

- Men button appears within 15 seconds
- Create Account button appears within 5 seconds
- Email and password fields accept input
- Sign up and login complete successfully
- Home screen is displayed and visible
- Console output: `"Home screen displayed: true"`

### Pass/Fail Criteria

- **Pass**: All steps execute and home screen displays
- **Fail**: Any step times out or home screen not displayed

---

## Test Case 2: Add to Cart Flow

### Test ID: CART-001

### Description

Validates opening a product and adding it to cart.

### Pre-conditions

- User logged in on home screen
- Product list loaded
- At least one product available

### Test Steps

| Step | Action                        | Element Locator    |
| ---- | ----------------------------- | ------------------ |
| 1    | Wait for products to load     | `~productItem0`    |
| 2    | Click first product           | `~productItem0`    |
| 3    | Wait for product details page | `~addToCartButton` |
| 4    | Click Add to Cart button      | `~addToCartButton` |

### Expected Results

- First product appears within 10 seconds
- Product details page loads within 5 seconds
- Add to Cart button is visible and clickable
- Console output: `"Add to Cart button clicked successfully."`

### Pass/Fail Criteria

- **Pass**: Product opens and Add to Cart clicked without errors
- **Fail**: Product doesn't open or Add to Cart fails

### Note

This test should be enhanced to include cart validation and item verification.

---

## How to Run with Appium

### 1. Start Appium Server

```bash
appium
```

### 2. Run Tests

```bash
# Run all tests
npx wdio run wdio.conf.js

# Run specific test
npx wdio run wdio.conf.js --spec ./test/specs/auth.test.js
npx wdio run wdio.conf.js --spec ./test/specs/cart.test.js
```

### 3. Configuration Requirements

Ensure `wdio.conf.js` includes:

- Port: 4723
- Platform name (Android/iOS)
- Device name
- App path
- Automation name (UiAutomator2/XCUITest)

---

## Element Locators Reference

| Element               | Accessibility ID       | Test Case |
| --------------------- | ---------------------- | --------- |
| Men Button            | `~menButton`           | AUTH-001  |
| Create Account Button | `~createAccountButton` | AUTH-001  |
| Email Field           | `~emailField`          | AUTH-001  |
| Password Field        | `~passwordField`       | AUTH-001  |
| Sign Up Button        | `~signupButton`        | AUTH-001  |
| Login Button          | `~loginButton`         | AUTH-001  |
| Home Screen           | `~homeScreen`          | AUTH-001  |
| Product Item (First)  | `~productItem0`        | CART-001  |
| Add to Cart Button    | `~addToCartButton`     | CART-001  |

---

## Troubleshooting

**Elements not found**: Verify accessibility IDs are implemented in Flutter using Key widget

**Timeout errors**: Increase timeout values or check app performance

**Connection refused**: Ensure Appium server is running on port 4723

**App doesn't launch**: Verify app path and device connection
