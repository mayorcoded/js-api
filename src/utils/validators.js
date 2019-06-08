"use strict";

//const { check } = require("./node_modules/express-validator/check");
const {check} = require("express-validator/check")

const validateNewCustomer = [
check("email")
  .not()
  .isEmpty()
  .exists()
  .withMessage("Email must be provided")
  .isEmail()
  .withMessage("email format is invalid")
  .trim()
  .normalizeEmail(),

check("name")
  .not()
  .isEmpty()
  .withMessage("Name cannot be empty")
  .trim()
  .escape(),

check(
  "password",
  "passwords must be at least 3 chars long and contain one number"
).exists()
  .not()
  .isEmpty()
  .isLength({ min: 3 })
  .matches(/\d/)
];

const validateFacebookLogin = [
  check("access_token")
  .not()
  .isEmpty()
  .withMessage("access token cannot be empty")
  .trim()
  .escape()
]

const validateUpdateCustomerCreditCard = [
  check("credit_card")
  .not()
  .isEmpty()
  .withMessage("credit card cannot be empty")
  .trim()
  .escape(),
]

const validateUpdateCustomer = [
  check("email")
    .not()
    .isEmpty()
    .exists()
    .withMessage("Email must be provided")
    .isEmail()
    .withMessage("email format is invalid")
    .trim()
    .normalizeEmail(),

  check("name")
    .not()
    .isEmpty()
    .withMessage("Name cannot be empty")
    .trim()
    .escape(),
];

const validateUpdateCustomerAddress = [
  check("address_1")
    .not()
    .isEmpty()
    .withMessage("Please provide an address")
    .toString(),

  check("city")
    .not()
    .isEmpty()
    .withMessage("Please provide a city")
    .toString(),

  check("region")
    .not()
    .isEmpty()
    .withMessage("Please provide a region")
    .toString(),

  check("postal_code")
    .not()
    .isEmpty()
    .withMessage("Please provide a postal code")
    .isNumeric()
    .withMessage("Postal code must be a number"),

  check("country")
    .not()
    .isEmpty()
    .withMessage("Please provide a country")
    .toString(),

  check("shipping_region_id")
    .not()
    .isEmpty()
    .withMessage("Please provide a shipping region")
    .isNumeric()
    .withMessage("Shipping region ID must be numeric"),
];

 const validateUpdateProfile = [
  check("address_1")
    .not()
    .isEmpty()
    .withMessage("Please provide an address")
    .toString(),

  check("city")
    .not()
    .isEmpty()
    .withMessage("Please provide a city")
    .toString(),

  check("region")
    .not()
    .isEmpty()
    .withMessage("Please provide a region")
    .toString(),

  check("postal_code")
    .not()
    .isEmpty()
    .withMessage("Please provide a postal code")
    .isNumeric()
    .withMessage("Postal code must be a number"),

  check("country")
    .not()
    .isEmpty()
    .withMessage("Please provide a country")
    .toString(),

  check("shipping_region_id")
    .not()
    .isEmpty()
    .withMessage("Please provide a shipping region")
    .isNumeric()
    .withMessage("Shipping region ID must be numeric"),

  check("day_phone")
    .not()
    .isEmpty()
    .withMessage("Please provide a phone number")
    .isNumeric()
    .withMessage("Phone number should be numeric")
];

 const validateNewDepartment = [
  check("name")
    .not()
    .isEmpty()
    .withMessage("Description name cannot be empty")
    .trim()
    .escape()
];

 const validateNewAttribute = [
  check("name")
    .not()
    .isEmpty()
    .withMessage("Attribute name cannot be empty")
    .trim()
    .escape()
];

 const validateNewProduct = [
  check("name")
    .not()
    .isEmpty()
    .withMessage("Product name cannot be empty"),

  check("description")
    .not()
    .isEmpty()
    .withMessage("The product description cannot be empty"),

  check("price")
    .isDecimal()
    .withMessage("Price must be a decimal"),

  check("discounted_price")
    .isDecimal()
    .withMessage("Discounted Price must be a decimal"),

  check("display")
    .isInt()
    .withMessage("Display must be an Integer")
];

 const validateNewOrder = [
  check("total_amount")
    .not()
    .isEmpty()
    .isNumeric()
    .withMessage("Total amount should be numeric"),

    check("shipping_id")
    .not()
    .isEmpty()
    .isNumeric()
    .withMessage("Shipping ID should be numeric")
];

 const validateNewShippingRegion = [
  check("shipping_region")
    .isAlphanumeric()
    .withMessage(
      "Shipping region must be only alphabetical and numeric characaters"
    )
];

 const validateLogin = [
  check("email")
    .isEmail()
    .withMessage("Email is not valid")
    .normalizeEmail(),

  check("password")
    .isAlphanumeric()
    .withMessage("Password must be alphanumeric characters.")
    .isLength({ min: 3 })
    .withMessage("Password must be at least 3 characters long")
];

 const validateQueryString = [
  check("query_string")
    .toString()
    .not()
    .isEmpty()
    .withMessage("Search term must be provided")
];

 const validateGetProductItem = [
  check("id")
    .isNumeric()
    .withMessage("Product item must be an integer")
    .not()
    .isEmpty()
    .withMessage("Product item is required")
];

 const validateNewItem = [
  check("cart_id")
    .isString()
    .withMessage("Cart ID must be an string")
    .not()
    .isEmpty()
    .withMessage("Cart ID cannot be empty"),

  check("product_id")
    .isNumeric()
    .withMessage("Product ID must be an integer")
    .not()
    .isEmpty()
    .withMessage("Product ID cannot be empty"),

  check("attributes")
    .isString()
    .withMessage("Attributes should be string")
    .not()
    .isEmpty()
    .withMessage("Attribute cannot be empty")
];

const validateUpdateCartItem = [
  check("quantity")
  .isInt()
  .withMessage("Cart ID must be an integer")
  .not()
  .isEmpty()
  .withMessage("Cart ID cannot be empty"),
];

const validateNewPayment = [
  check("amount")
    .not()
    .isEmpty()
    .withMessage("Please enter your stripe token")
    .isNumeric()
    .withMessage("Amount should be numeric"),

  // check("currency")
  //   .isCurrency()
  //   .withMessage("Should be a currency"),

  check("order_id")
    .not()
    .isEmpty()
    .withMessage("Please enter an order ID")
    .isNumeric()
    .withMessage("Order ID should be numeric")
];

const validateEditProduct = [
  check("name")
    .isString()
    .withMessage("Name must be a string"),

  check("description")
    .isString()
    .withMessage("Descrition must be a string"),

  check("price")
    .isNumeric()
    .withMessage("Price must be an integer"),

  check("discounted_price")
    .isNumeric()
    .withMessage("Discounted price must be an integer")
];

 const validateEditDepartment = [
  check("name")
    .isString()
    .withMessage("Name must be a string"),

  check("description")
    .isString()
    .withMessage("Descrition must be a string")
];

 const validateEditAttribute = [
  check("name")
    .isString()
    .withMessage("Name must be a string")
];

 const validateDeleteDepartment = [
  check("department_id")
  .isNumeric()
  .withMessage("Product department ID must be an integer")
];


 const validateProductAttributes = [
  check("attribute_id")
  .isNumeric()
  .withMessage("Attribute ID must be an integer"),

  check("product_id")
  .isNumeric()
  .withMessage("Product ID must be an integer")
];

 const validateDeleteAttribute = [
  check("attribute_id")
  .isNumeric()
  .withMessage("Attribute ID must be an integer")
];

 const validateEditCategory = [
  check("name")
    .isString()
    .withMessage("Name must be a string"),

  check("description")
    .isString()
    .withMessage("Description must be a string"),

  check("department_id")
    .isNumeric()
    .withMessage("Department ID must be an integer")
];

 const validateDeleteProduct = [
  check("product_id")
  .isNumeric()
  .withMessage("Product ID must be an integer")
];

 const validateCancelOrder = [
  check("order_id")
  .isNumeric()
  .withMessage("Order ID must be an integer")
];

 const validateDeleteCategory = [
  check("category_id")
  .isNumeric()
  .withMessage("Category ID must be an integer")
];

 const validateAddCategory = [
  check("name")
  .isString()
  .withMessage("Name must be a string"),

  check("description")
  .isString()
  .withMessage("Description must be a string"),

  check("department_id")
  .isNumeric()
  .withMessage("Department ID must be an integer")
];

const validateProductReview = [
  check("review")
  .isString()
  .withMessage("review should be string")
  .not()
  .isEmpty()
  .withMessage("review cannot be empty"),

  check("review")
  .isNumeric()
  .withMessage("review should be a number")
  .not()
  .isEmpty()
  .withMessage("review cannot be empty")
]

//  const validateStatus = [
//   check('status')
//     .isString().withMessage('Status must be alphabetical characters.')
//     .isLength({ min: 4, max: 20 })
//     .withMessage('Status must be at least 5 characters long and not more than 20'),
// ];


module.exports = {
  validateFacebookLogin,
  validateNewCustomer,
  validateAddCategory,
  validateCancelOrder,
  validateDeleteAttribute,
  validateDeleteCategory,
  validateDeleteDepartment,
  validateDeleteProduct,
  validateEditAttribute,
  validateEditCategory,
  validateEditDepartment,
  validateEditProduct,
  validateGetProductItem,
  validateLogin,
  validateNewAttribute,
  validateNewDepartment,
  validateNewItem,
  validateNewOrder,
  validateNewPayment,
  validateNewProduct,
  validateNewShippingRegion,
  validateProductAttributes,
  validateQueryString,
  validateUpdateProfile,
  validateUpdateCustomer,
  validateUpdateCustomerAddress,
  validateUpdateCustomerCreditCard,
  validateProductReview,
  validateUpdateCartItem
}
