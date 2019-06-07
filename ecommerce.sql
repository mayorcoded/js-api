-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 13, 2019 at 11:59 PM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 7.1.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecommerce`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_add_attribute` (IN `inName` VARCHAR(100))  BEGIN
  INSERT INTO attribute (name) VALUES (inName);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_add_attribute_value` (IN `inAttributeId` INT, IN `inValue` VARCHAR(100))  BEGIN
  INSERT INTO attribute_value (attribute_id, value)
         VALUES (inAttributeId, inValue);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_add_category` (IN `inDepartmentId` INT, IN `inName` VARCHAR(100), IN `inDescription` VARCHAR(1000))  BEGIN
  INSERT INTO category (department_id, name, description)
         VALUES (inDepartmentId, inName, inDescription);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_add_department` (IN `inName` VARCHAR(100), IN `inDescription` VARCHAR(1000))  BEGIN
  INSERT INTO department (name, description)
         VALUES (inName, inDescription);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_add_product_to_category` (IN `inCategoryId` INT, IN `inName` VARCHAR(100), IN `inDescription` VARCHAR(1000), IN `inPrice` DECIMAL(10,2))  BEGIN
  DECLARE productLastInsertId INT;

  INSERT INTO product (name, description, price)
         VALUES (inName, inDescription, inPrice);

  SELECT LAST_INSERT_ID() INTO productLastInsertId;

  INSERT INTO product_category (product_id, category_id)
         VALUES (productLastInsertId, inCategoryId);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_assign_attribute_value_to_product` (IN `inProductId` INT, IN `inAttributeValueId` INT)  BEGIN
  INSERT INTO product_attribute (product_id, attribute_value_id)
         VALUES (inProductId, inAttributeValueId);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_assign_product_to_category` (IN `inProductId` INT, IN `inCategoryId` INT)  BEGIN
  INSERT INTO product_category (product_id, category_id)
         VALUES (inProductId, inCategoryId);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_count_products_in_category` (IN `inCategoryId` INT)  BEGIN
  SELECT     COUNT(*) AS categories_count
  FROM       product p
  INNER JOIN product_category pc
               ON p.product_id = pc.product_id
  WHERE      pc.category_id = inCategoryId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_count_products_on_catalog` ()  BEGIN
  SELECT COUNT(*) AS products_on_catalog_count
  FROM   product
  WHERE  display = 1 OR display = 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_count_products_on_department` (IN `inDepartmentId` INT)  BEGIN
  SELECT DISTINCT COUNT(*) AS products_on_department_count
  FROM            product p
  INNER JOIN      product_category pc
                    ON p.product_id = pc.product_id
  INNER JOIN      category c
                    ON pc.category_id = c.category_id
  WHERE           (p.display = 2 OR p.display = 3)
                  AND c.department_id = inDepartmentId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_count_search_result` (IN `inSearchString` TEXT, IN `inAllWords` VARCHAR(3))  BEGIN
  IF inAllWords = "on" THEN
    PREPARE statement FROM
      "SELECT   count(*)
       FROM     product
       WHERE    MATCH (name, description) AGAINST (? IN BOOLEAN MODE)";
  ELSE
    PREPARE statement FROM
      "SELECT   count(*)
       FROM     product
       WHERE    MATCH (name, description) AGAINST (?)";
  END IF;

  SET @p1 = inSearchString;

  EXECUTE statement USING @p1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_create_product_review` (IN `inCustomerId` INT, IN `inProductId` INT, IN `inReview` TEXT, IN `inRating` SMALLINT)  BEGIN
  INSERT INTO review (customer_id, product_id, review, rating, created_on)
         VALUES (inCustomerId, inProductId, inReview, inRating, NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_delete_attribute` (IN `inAttributeId` INT)  BEGIN
  DECLARE attributeRowsCount INT;

  SELECT count(*)
  FROM   attribute_value
  WHERE  attribute_id = inAttributeId
  INTO   attributeRowsCount;

  IF attributeRowsCount = 0 THEN
    DELETE FROM attribute WHERE attribute_id = inAttributeId;

    SELECT 1;
  ELSE
    SELECT -1;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_delete_attribute_value` (IN `inAttributeValueId` INT)  BEGIN
  DECLARE productAttributeRowsCount INT;

  SELECT      count(*)
  FROM        product p
  INNER JOIN  product_attribute pa
                ON p.product_id = pa.product_id
  WHERE       pa.attribute_value_id = inAttributeValueId
  INTO        productAttributeRowsCount;

  IF productAttributeRowsCount = 0 THEN
    DELETE FROM attribute_value WHERE attribute_value_id = inAttributeValueId;

    SELECT 1;
  ELSE
    SELECT -1;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_delete_category` (IN `inCategoryId` INT)  BEGIN
  DECLARE productCategoryRowsCount INT;

  SELECT      count(*)
  FROM        product p
  INNER JOIN  product_category pc
                ON p.product_id = pc.product_id
  WHERE       pc.category_id = inCategoryId
  INTO        productCategoryRowsCount;

  IF productCategoryRowsCount = 0 THEN
    DELETE FROM category WHERE category_id = inCategoryId;

    SELECT 1;
  ELSE
    SELECT -1;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_delete_department` (IN `inDepartmentId` INT)  BEGIN
  DECLARE categoryRowsCount INT;

  SELECT count(*)
  FROM   category
  WHERE  department_id = inDepartmentId
  INTO   categoryRowsCount;

  IF categoryRowsCount = 0 THEN
    DELETE FROM department WHERE department_id = inDepartmentId;

    SELECT 1;
  ELSE
    SELECT -1;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_delete_product` (IN `inProductId` INT)  BEGIN
  DELETE FROM product_attribute WHERE product_id = inProductId;
  DELETE FROM product_category WHERE product_id = inProductId;
  DELETE FROM shopping_cart WHERE product_id = inProductId;
  DELETE FROM product WHERE product_id = inProductId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_attributes` ()  BEGIN
  SELECT attribute_id, name FROM attribute ORDER BY attribute_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_attributes_not_assigned_to_product` (IN `inProductId` INT)  BEGIN
  SELECT     a.name AS attribute_name,
             av.attribute_value_id, av.value AS attribute_value
  FROM       attribute_value av
  INNER JOIN attribute a
               ON av.attribute_id = a.attribute_id
  WHERE      av.attribute_value_id NOT IN
             (SELECT attribute_value_id
              FROM   product_attribute
              WHERE  product_id = inProductId)
  ORDER BY   attribute_name, av.attribute_value_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_attribute_details` (IN `inAttributeId` INT)  BEGIN
  SELECT attribute_id, name
  FROM   attribute
  WHERE  attribute_id = inAttributeId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_attribute_values` (IN `inAttributeId` INT)  BEGIN
  SELECT   attribute_value_id, value
  FROM     attribute_value
  WHERE    attribute_id = inAttributeId
  ORDER BY attribute_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_categories` ()  BEGIN
  SELECT   category_id, name, description
  FROM     category
  ORDER BY category_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_categories_for_product` (IN `inProductId` INT)  BEGIN
  SELECT   c.category_id, c.department_id, c.name
  FROM     category c
  JOIN     product_category pc
             ON c.category_id = pc.category_id
  WHERE    pc.product_id = inProductId
  ORDER BY category_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_categories_list` (IN `inDepartmentId` INT)  BEGIN
  SELECT   category_id, name
  FROM     category
  WHERE    department_id = inDepartmentId
  ORDER BY category_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_category_details` (IN `inCategoryId` INT)  BEGIN
  SELECT name, description
  FROM   category
  WHERE  category_id = inCategoryId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_category_name` (IN `inCategoryId` INT)  BEGIN
  SELECT name FROM category WHERE category_id = inCategoryId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_category_products` (IN `inCategoryId` INT)  BEGIN
  SELECT     p.product_id, p.name, p.description, p.price,
             p.discounted_price
  FROM       product p
  INNER JOIN product_category pc
               ON p.product_id = pc.product_id
  WHERE      pc.category_id = inCategoryId
  ORDER BY   p.product_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_departments` ()  BEGIN
  SELECT   department_id, name, description
  FROM     department
  ORDER BY department_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_departments_list` ()  BEGIN
  SELECT department_id, name FROM department ORDER BY department_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_department_categories` (IN `inDepartmentId` INT)  BEGIN
  SELECT   category_id, name, description
  FROM     category
  WHERE    department_id = inDepartmentId
  ORDER BY category_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_department_details` (IN `inDepartmentId` INT)  BEGIN
  SELECT name, description
  FROM   department
  WHERE  department_id = inDepartmentId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_department_name` (IN `inDepartmentId` INT)  BEGIN
  SELECT name FROM department WHERE department_id = inDepartmentId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_products_in_category` (IN `inCategoryId` INT, IN `inShortProductDescriptionLength` INT, IN `inProductsPerPage` INT, IN `inStartItem` INT)  BEGIN
  -- Prepare statement
  PREPARE statement FROM
   "SELECT     p.product_id, p.name,
               IF(LENGTH(p.description) <= ?,
                  p.description,
                  CONCAT(LEFT(p.description, ?),
                         '...')) AS description,
               p.price, p.discounted_price, p.thumbnail
    FROM       product p
    INNER JOIN product_category pc
                 ON p.product_id = pc.product_id
    WHERE      pc.category_id = ?
    ORDER BY   p.display DESC
    LIMIT      ?, ?";

  -- Define query parameters
  SET @p1 = inShortProductDescriptionLength;
  SET @p2 = inShortProductDescriptionLength;
  SET @p3 = inCategoryId;
  SET @p4 = inStartItem;
  SET @p5 = inProductsPerPage;

  -- Execute the statement
  EXECUTE statement USING @p1, @p2, @p3, @p4, @p5;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_products_on_catalog` (IN `inShortProductDescriptionLength` INT, IN `inProductsPerPage` INT, IN `inStartItem` INT)  BEGIN
  PREPARE statement FROM
    "SELECT   product_id, name,
              IF(LENGTH(description) <= ?,
                 description,
                 CONCAT(LEFT(description, ?),
                        '...')) AS description,
              price, discounted_price, thumbnail
     FROM     product
     WHERE    display = 1 OR display = 3
     ORDER BY display DESC
     LIMIT    ?, ?";

  SET @p1 = inShortProductDescriptionLength;
  SET @p2 = inShortProductDescriptionLength;
  SET @p3 = inStartItem;
  SET @p4 = inProductsPerPage;

  EXECUTE statement USING @p1, @p2, @p3, @p4;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_products_on_department` (IN `inDepartmentId` INT, IN `inShortProductDescriptionLength` INT, IN `inProductsPerPage` INT, IN `inStartItem` INT)  BEGIN
  PREPARE statement FROM
    "SELECT DISTINCT p.product_id, p.name,
                     IF(LENGTH(p.description) <= ?,
                        p.description,
                        CONCAT(LEFT(p.description, ?),
                               '...')) AS description,
                     p.price, p.discounted_price, p.thumbnail
     FROM            product p
     INNER JOIN      product_category pc
                       ON p.product_id = pc.product_id
     INNER JOIN      category c
                       ON pc.category_id = c.category_id
     WHERE           (p.display = 2 OR p.display = 3)
                     AND c.department_id = ?
     ORDER BY        p.display DESC
     LIMIT           ?, ?";

  SET @p1 = inShortProductDescriptionLength;
  SET @p2 = inShortProductDescriptionLength;
  SET @p3 = inDepartmentId;
  SET @p4 = inStartItem;
  SET @p5 = inProductsPerPage;

  EXECUTE statement USING @p1, @p2, @p3, @p4, @p5;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_product_attributes` (IN `inProductId` INT)  BEGIN
  SELECT     a.name AS attribute_name,
             av.attribute_value_id, av.value AS attribute_value
  FROM       attribute_value av
  INNER JOIN attribute a
               ON av.attribute_id = a.attribute_id
  WHERE      av.attribute_value_id IN
               (SELECT attribute_value_id
                FROM   product_attribute
                WHERE  product_id = inProductId)
  ORDER BY   a.name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_product_details` (IN `inProductId` INT)  BEGIN
  SELECT product_id, name, description,
         price, discounted_price, image, image_2
  FROM   product
  WHERE  product_id = inProductId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_product_info` (IN `inProductId` INT)  BEGIN
  SELECT product_id, name, description, price, discounted_price,
         image, image_2, thumbnail, display
  FROM   product
  WHERE  product_id = inProductId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_product_locations` (IN `inProductId` INT)  BEGIN
  SELECT c.category_id, c.name AS category_name, c.department_id,
         (SELECT name
          FROM   department
          WHERE  department_id = c.department_id) AS department_name
          -- Subquery returns the name of the department of the category
  FROM   category c
  WHERE  c.category_id IN
           (SELECT category_id
            FROM   product_category
            WHERE  product_id = inProductId);
            -- Subquery returns the category IDs a product belongs to
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_product_name` (IN `inProductId` INT)  BEGIN
  SELECT name FROM product WHERE product_id = inProductId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_product_reviews` (IN `inProductId` INT)  BEGIN
  SELECT     c.name, r.review, r.rating, r.created_on
  FROM       review r
  INNER JOIN customer c
               ON c.customer_id = r.customer_id
  WHERE      r.product_id = inProductId
  ORDER BY   r.created_on DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_get_recommendations` (IN `inProductId` INT, IN `inShortProductDescriptionLength` INT)  BEGIN
  PREPARE statement FROM
    "SELECT   od2.product_id, od2.product_name,
              IF(LENGTH(p.description) <= ?, p.description,
                 CONCAT(LEFT(p.description, ?), '...')) AS description
     FROM     order_detail od1
     JOIN     order_detail od2 ON od1.order_id = od2.order_id
     JOIN     product p ON od2.product_id = p.product_id
     WHERE    od1.product_id = ? AND
              od2.product_id != ?
     GROUP BY od2.product_id
     ORDER BY COUNT(od2.product_id) DESC
     LIMIT 5";

  SET @p1 = inShortProductDescriptionLength;
  SET @p2 = inProductId;

  EXECUTE statement USING @p1, @p1, @p2, @p2;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_move_product_to_category` (IN `inProductId` INT, IN `inSourceCategoryId` INT, IN `inTargetCategoryId` INT)  BEGIN
  UPDATE product_category
  SET    category_id = inTargetCategoryId
  WHERE  product_id = inProductId
         AND category_id = inSourceCategoryId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_remove_product_attribute_value` (IN `inProductId` INT, IN `inAttributeValueId` INT)  BEGIN
  DELETE FROM product_attribute
  WHERE       product_id = inProductId AND
              attribute_value_id = inAttributeValueId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_remove_product_from_category` (IN `inProductId` INT, IN `inCategoryId` INT)  BEGIN
  DECLARE productCategoryRowsCount INT;

  SELECT count(*)
  FROM   product_category
  WHERE  product_id = inProductId
  INTO   productCategoryRowsCount;

  IF productCategoryRowsCount = 1 THEN
    CALL catalog_delete_product(inProductId);

    SELECT 0;
  ELSE
    DELETE FROM product_category
    WHERE  category_id = inCategoryId AND product_id = inProductId;

    SELECT 1;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_search` (IN `inSearchString` TEXT, IN `inAllWords` VARCHAR(3), IN `inShortProductDescriptionLength` INT, IN `inProductsPerPage` INT, IN `inStartItem` INT)  BEGIN
  IF inAllWords = "on" THEN
    PREPARE statement FROM
      "SELECT   product_id, name,
                IF(LENGTH(description) <= ?,
                   description,
                   CONCAT(LEFT(description, ?),
                          '...')) AS description,
                price, discounted_price, thumbnail
       FROM     product
       WHERE    MATCH (name, description)
                AGAINST (? IN BOOLEAN MODE)
       ORDER BY MATCH (name, description)
                AGAINST (? IN BOOLEAN MODE) DESC
       LIMIT    ?, ?";
  ELSE
    PREPARE statement FROM
      "SELECT   product_id, name,
                IF(LENGTH(description) <= ?,
                   description,
                   CONCAT(LEFT(description, ?),
                          '...')) AS description,
                price, discounted_price, thumbnail
       FROM     product
       WHERE    MATCH (name, description) AGAINST (?)
       ORDER BY MATCH (name, description) AGAINST (?) DESC
       LIMIT    ?, ?";
  END IF;

  SET @p1 = inShortProductDescriptionLength;
  SET @p2 = inSearchString;
  SET @p3 = inStartItem;
  SET @p4 = inProductsPerPage;

  EXECUTE statement USING @p1, @p1, @p2, @p2, @p3, @p4;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_set_image` (IN `inProductId` INT, IN `inImage` VARCHAR(150))  BEGIN
  UPDATE product SET image = inImage WHERE product_id = inProductId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_set_image_2` (IN `inProductId` INT, IN `inImage` VARCHAR(150))  BEGIN
  UPDATE product SET image_2 = inImage WHERE product_id = inProductId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_set_product_display_option` (IN `inProductId` INT, IN `inDisplay` SMALLINT)  BEGIN
  UPDATE product SET display = inDisplay WHERE product_id = inProductId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_set_thumbnail` (IN `inProductId` INT, IN `inThumbnail` VARCHAR(150))  BEGIN
  UPDATE product
  SET    thumbnail = inThumbnail
  WHERE  product_id = inProductId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_update_attribute` (IN `inAttributeId` INT, IN `inName` VARCHAR(100))  BEGIN
  UPDATE attribute SET name = inName WHERE attribute_id = inAttributeId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_update_attribute_value` (IN `inAttributeValueId` INT, IN `inValue` VARCHAR(100))  BEGIN
    UPDATE attribute_value
    SET    value = inValue
    WHERE  attribute_value_id = inAttributeValueId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_update_category` (IN `inCategoryId` INT, IN `inName` VARCHAR(100), IN `inDescription` VARCHAR(1000))  BEGIN
    UPDATE category
    SET    name = inName, description = inDescription
    WHERE  category_id = inCategoryId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_update_department` (IN `inDepartmentId` INT, IN `inName` VARCHAR(100), IN `inDescription` VARCHAR(1000))  BEGIN
  UPDATE department
  SET    name = inName, description = inDescription
  WHERE  department_id = inDepartmentId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `catalog_update_product` (IN `inProductId` INT, IN `inName` VARCHAR(100), IN `inDescription` VARCHAR(1000), IN `inPrice` DECIMAL(10,2), IN `inDiscountedPrice` DECIMAL(10,2))  BEGIN
  UPDATE product
  SET    name = inName, description = inDescription, price = inPrice,
         discounted_price = inDiscountedPrice
  WHERE  product_id = inProductId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_add` (IN `inName` VARCHAR(50), IN `inEmail` VARCHAR(100), IN `inPassword` VARCHAR(50))  BEGIN
  INSERT INTO customer (name, email, password)
         VALUES (inName, inEmail, inPassword);

  SELECT LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_get_customer` (IN `inCustomerId` INT)  BEGIN
  SELECT customer_id, name, email, password, credit_card,
         address_1, address_2, city, region, postal_code, country,
         shipping_region_id, day_phone, eve_phone, mob_phone
  FROM   customer
  WHERE  customer_id = inCustomerId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_get_customers_list` ()  BEGIN
  SELECT customer_id, name FROM customer ORDER BY name ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_get_login_info` (IN `inEmail` VARCHAR(100))  BEGIN
  SELECT customer_id, password FROM customer WHERE email = inEmail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_get_shipping_regions` ()  BEGIN
  SELECT shipping_region_id, shipping_region FROM shipping_region;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_update_account` (IN `inCustomerId` INT, IN `inName` VARCHAR(50), IN `inEmail` VARCHAR(100), IN `inPassword` VARCHAR(50), IN `inDayPhone` VARCHAR(100), IN `inEvePhone` VARCHAR(100), IN `inMobPhone` VARCHAR(100))  BEGIN
  UPDATE customer
  SET    name = inName, email = inEmail,
         password = inPassword, day_phone = inDayPhone,
         eve_phone = inEvePhone, mob_phone = inMobPhone
  WHERE  customer_id = inCustomerId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_update_address` (IN `inCustomerId` INT, IN `inAddress1` VARCHAR(100), IN `inAddress2` VARCHAR(100), IN `inCity` VARCHAR(100), IN `inRegion` VARCHAR(100), IN `inPostalCode` VARCHAR(100), IN `inCountry` VARCHAR(100), IN `inShippingRegionId` INT)  BEGIN
  UPDATE customer
  SET    address_1 = inAddress1, address_2 = inAddress2, city = inCity,
         region = inRegion, postal_code = inPostalCode,
         country = inCountry, shipping_region_id = inShippingRegionId
  WHERE  customer_id = inCustomerId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_update_credit_card` (IN `inCustomerId` INT, IN `inCreditCard` TEXT)  BEGIN
  UPDATE customer
  SET    credit_card = inCreditCard
  WHERE  customer_id = inCustomerId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_create_audit` (IN `inOrderId` INT, IN `inMessage` TEXT, IN `inCode` INT)  BEGIN
  INSERT INTO audit (order_id, created_on, message, code)
         VALUES (inOrderId, NOW(), inMessage, inCode);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_get_audit_trail` (IN `inOrderId` INT)  BEGIN
  SELECT audit_id, order_id, created_on, message, code
  FROM   audit
  WHERE  order_id = inOrderId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_get_by_customer_id` (IN `inCustomerId` INT)  BEGIN
  SELECT     o.order_id, o.total_amount, o.created_on,
             o.shipped_on, o.status, c.name
  FROM       orders o
  INNER JOIN customer c
               ON o.customer_id = c.customer_id
  WHERE      o.customer_id = inCustomerId
  ORDER BY   o.created_on DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_get_most_recent_orders` (IN `inHowMany` INT)  BEGIN
  PREPARE statement FROM
    "SELECT     o.order_id, o.total_amount, o.created_on,
                o.shipped_on, o.status, c.name
     FROM       orders o
     INNER JOIN customer c
                  ON o.customer_id = c.customer_id
     ORDER BY   o.created_on DESC
     LIMIT      ?";

  SET @p1 = inHowMany;

  EXECUTE statement USING @p1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_get_orders_between_dates` (IN `inStartDate` DATETIME, IN `inEndDate` DATETIME)  BEGIN
  SELECT     o.order_id, o.total_amount, o.created_on,
             o.shipped_on, o.status, c.name
  FROM       orders o
  INNER JOIN customer c
               ON o.customer_id = c.customer_id
  WHERE      o.created_on >= inStartDate AND o.created_on <= inEndDate
  ORDER BY   o.created_on DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_get_orders_by_status` (IN `inStatus` INT)  BEGIN
  SELECT     o.order_id, o.total_amount, o.created_on,
             o.shipped_on, o.status, c.name
  FROM       orders o
  INNER JOIN customer c
               ON o.customer_id = c.customer_id
  WHERE      o.status = inStatus
  ORDER BY   o.created_on DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_get_order_details` (IN `inOrderId` INT)  BEGIN
  SELECT order_id, product_id, attributes, product_name,
         quantity, unit_cost, (quantity * unit_cost) AS subtotal
  FROM   order_detail
  WHERE  order_id = inOrderId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_get_order_info` (IN `inOrderId` INT)  BEGIN
  SELECT     o.order_id, o.total_amount, o.created_on, o.shipped_on,
             o.status, o.comments, o.customer_id, o.auth_code,
             o.reference, o.shipping_id, s.shipping_type, s.shipping_cost,
             o.tax_id, t.tax_type, t.tax_percentage
  FROM       orders o
  INNER JOIN tax t
               ON t.tax_id = o.tax_id
  INNER JOIN shipping s
               ON s.shipping_id = o.shipping_id
  WHERE      o.order_id = inOrderId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_get_order_short_details` (IN `inOrderId` INT)  BEGIN
  SELECT      o.order_id, o.total_amount, o.created_on,
              o.shipped_on, o.status, c.name
  FROM        orders o
  INNER JOIN  customer c
                ON o.customer_id = c.customer_id
  WHERE       o.order_id = inOrderId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_get_shipping_info` (IN `inShippingRegionId` INT)  BEGIN
  SELECT shipping_id, shipping_type, shipping_cost, shipping_region_id
  FROM   shipping
  WHERE  shipping_region_id = inShippingRegionId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_set_auth_code` (IN `inOrderId` INT, IN `inAuthCode` VARCHAR(50), IN `inReference` VARCHAR(50))  BEGIN
  UPDATE orders
  SET    auth_code = inAuthCode, reference = inReference
  WHERE  order_id = inOrderId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_set_date_shipped` (IN `inOrderId` INT)  BEGIN
  UPDATE orders SET shipped_on = NOW() WHERE order_id = inOrderId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_update_order` (IN `inOrderId` INT, IN `inStatus` INT, IN `inComments` VARCHAR(255), IN `inAuthCode` VARCHAR(50), IN `inReference` VARCHAR(50))  BEGIN
  DECLARE currentDateShipped DATETIME;

  SELECT shipped_on
  FROM   orders
  WHERE  order_id = inOrderId
  INTO   currentDateShipped;

  UPDATE orders
  SET    status = inStatus, comments = inComments,
         auth_code = inAuthCode, reference = inReference
  WHERE  order_id = inOrderId;

  IF inStatus < 7 AND currentDateShipped IS NOT NULL THEN
    UPDATE orders SET shipped_on = NULL WHERE order_id = inOrderId;
  ELSEIF inStatus > 6 AND currentDateShipped IS NULL THEN
    UPDATE orders SET shipped_on = NOW() WHERE order_id = inOrderId;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orders_update_status` (IN `inOrderId` INT, IN `inStatus` INT)  BEGIN
  UPDATE orders SET status = inStatus WHERE order_id = inOrderId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_add_product` (IN `inCartId` CHAR(32), IN `inProductId` INT, IN `inAttributes` VARCHAR(1000))  BEGIN
  DECLARE productQuantity INT;

  -- Obtain current shopping cart quantity for the product
  SELECT quantity
  FROM   shopping_cart
  WHERE  cart_id = inCartId
         AND product_id = inProductId
         AND attributes = inAttributes
  INTO   productQuantity;

  -- Create new shopping cart record, or increase quantity of existing record
  IF productQuantity IS NULL THEN
    INSERT INTO shopping_cart(item_id, cart_id, product_id, attributes,
                              quantity, added_on)
           VALUES (UUID(), inCartId, inProductId, inAttributes, 1, NOW());
  ELSE
    UPDATE shopping_cart
    SET    quantity = quantity + 1, buy_now = true
    WHERE  cart_id = inCartId
           AND product_id = inProductId
           AND attributes = inAttributes;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_count_old_carts` (IN `inDays` INT)  BEGIN
  SELECT COUNT(cart_id) AS old_shopping_carts_count
  FROM   (SELECT   cart_id
          FROM     shopping_cart
          GROUP BY cart_id
          HAVING   DATE_SUB(NOW(), INTERVAL inDays DAY) >= MAX(added_on))
         AS old_carts;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_create_order` (IN `inCartId` CHAR(32), IN `inCustomerId` INT, IN `inShippingId` INT, IN `inTaxId` INT)  BEGIN
  DECLARE orderId INT;

  -- Insert a new record into orders and obtain the new order ID
  INSERT INTO orders (created_on, customer_id, shipping_id, tax_id) VALUES
         (NOW(), inCustomerId, inShippingId, inTaxId);
  -- Obtain the new Order ID
  SELECT LAST_INSERT_ID() INTO orderId;

  -- Insert order details in order_detail table
  INSERT INTO order_detail (order_id, product_id, attributes,
                            product_name, quantity, unit_cost)
  SELECT      orderId, p.product_id, sc.attributes, p.name, sc.quantity,
              COALESCE(NULLIF(p.discounted_price, 0), p.price) AS unit_cost
  FROM        shopping_cart sc
  INNER JOIN  product p
                ON sc.product_id = p.product_id
  WHERE       sc.cart_id = inCartId AND sc.buy_now;

  -- Save the order's total amount
  UPDATE orders
  SET    total_amount = (SELECT SUM(unit_cost * quantity)
                         FROM   order_detail
                         WHERE  order_id = orderId)
  WHERE  order_id = orderId;

  -- Clear the shopping cart
  CALL shopping_cart_empty(inCartId);

  -- Return the Order ID
  SELECT orderId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_delete_old_carts` (IN `inDays` INT)  BEGIN
  DELETE FROM shopping_cart
  WHERE  cart_id IN
          (SELECT cart_id
           FROM   (SELECT   cart_id
                   FROM     shopping_cart
                   GROUP BY cart_id
                   HAVING   DATE_SUB(NOW(), INTERVAL inDays DAY) >=
                            MAX(added_on))
                  AS sc);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_empty` (IN `inCartId` CHAR(32))  BEGIN
  DELETE FROM shopping_cart WHERE cart_id = inCartId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_get_products` (IN `inCartId` CHAR(32))  BEGIN
  SELECT     sc.item_id, p.name, sc.attributes,
             COALESCE(NULLIF(p.discounted_price, 0), p.price) AS price,
             sc.quantity,
             COALESCE(NULLIF(p.discounted_price, 0),
                      p.price) * sc.quantity AS subtotal
  FROM       shopping_cart sc
  INNER JOIN product p
               ON sc.product_id = p.product_id
  WHERE      sc.cart_id = inCartId AND sc.buy_now;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_get_recommendations` (IN `inCartId` CHAR(32), IN `inShortProductDescriptionLength` INT)  BEGIN
  PREPARE statement FROM
    "-- Returns the products that exist in a list of orders
     SELECT   od1.product_id, od1.product_name,
              IF(LENGTH(p.description) <= ?, p.description,
                 CONCAT(LEFT(p.description, ?), '...')) AS description
     FROM     order_detail od1
     JOIN     order_detail od2
                ON od1.order_id = od2.order_id
     JOIN     product p
                ON od1.product_id = p.product_id
     JOIN     shopping_cart
                ON od2.product_id = shopping_cart.product_id
     WHERE    shopping_cart.cart_id = ?
              -- Must not include products that already exist
              -- in the visitor's cart
              AND od1.product_id NOT IN
              (-- Returns the products in the specified
               -- shopping cart
               SELECT product_id
               FROM   shopping_cart
               WHERE  cart_id = ?)
     -- Group the product_id so we can calculate the rank
     GROUP BY od1.product_id
     -- Order descending by rank
     ORDER BY COUNT(od1.product_id) DESC
     LIMIT    5";

  SET @p1 = inShortProductDescriptionLength;
  SET @p2 = inCartId;

  EXECUTE statement USING @p1, @p1, @p2, @p2;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_get_saved_products` (IN `inCartId` CHAR(32))  BEGIN
  SELECT     sc.item_id, p.name, sc.attributes,
             COALESCE(NULLIF(p.discounted_price, 0), p.price) AS price
  FROM       shopping_cart sc
  INNER JOIN product p
               ON sc.product_id = p.product_id
  WHERE      sc.cart_id = inCartId AND NOT sc.buy_now;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_get_total_amount` (IN `inCartId` CHAR(32))  BEGIN
  SELECT     SUM(COALESCE(NULLIF(p.discounted_price, 0), p.price)
                 * sc.quantity) AS total_amount
  FROM       shopping_cart sc
  INNER JOIN product p
               ON sc.product_id = p.product_id
  WHERE      sc.cart_id = inCartId AND sc.buy_now;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_move_product_to_cart` (IN `inItemId` INT)  BEGIN
  UPDATE shopping_cart
  SET    buy_now = true, added_on = NOW()
  WHERE  item_id = inItemId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_remove_product` (IN `inItemId` INT)  BEGIN
  DELETE FROM shopping_cart WHERE item_id = inItemId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_save_product_for_later` (IN `inItemId` INT)  BEGIN
  UPDATE shopping_cart
  SET    buy_now = false, quantity = 1
  WHERE  item_id = inItemId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_update` (IN `inItemId` INT, IN `inQuantity` INT)  BEGIN
  IF inQuantity > 0 THEN
    UPDATE shopping_cart
    SET    quantity = inQuantity, added_on = NOW()
    WHERE  item_id = inItemId;
  ELSE
    CALL shopping_cart_remove_product(inItemId);
  END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `attribute`
--

CREATE TABLE `attribute` (
  `attribute_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `attribute`
--

INSERT INTO `attribute` (`attribute_id`, `name`) VALUES
(1, 'Size'),
(2, 'Color');

-- --------------------------------------------------------

-- Table structure for table `attribute_value`
--
--

CREATE TABLE `attribute_value` (
  `attribute_value_id` int(11) NOT NULL,
  `attribute_id` int(11) NOT NULL,
  `value` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `attribute_value`
--

INSERT INTO `attribute_value` (`attribute_value_id`, `attribute_id`, `value`) VALUES
(1, 1, 'S'),
(2, 1, 'M'),
(3, 1, 'L'),
(4, 1, 'XL'),
(5, 1, 'XXL'),
(6, 2, 'White'),
(7, 2, 'Black'),
(8, 2, 'Red'),
(9, 2, 'Orange'),
(10, 2, 'Yellow'),
(11, 2, 'Green'),
(12, 2, 'Blue'),
(13, 2, 'Indigo'),
(14, 2, 'Purple');

-- --------------------------------------------------------

--
-- Table structure for table `audit`
--

CREATE TABLE `audit` (
  `audit_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `created_on` datetime NOT NULL,
  `message` text NOT NULL,
  `code` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_id` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(1000) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_id`, `department_id`, `name`, `description`) VALUES
(1, 1, 'French', 'The French have always had an eye for beauty. One look at the T-shirts below and you\'ll see that same appreciation has been applied abundantly to their postage stamps. Below are some of our most beautiful and colorful T-shirts, so browse away! And don\'t forget to go all the way to the bottom - you don\'t want to miss any of them!'),
(2, 1, 'Italian', 'The full and resplendent treasure chest of art, literature, music, and science that Italy has given the world is reflected splendidly in its postal stamps. If we could, we would dedicate hundreds of T-shirts to this amazing treasure of beautiful images, but for now we will have to live with what you see here. You don\'t have to be Italian to love these gorgeous T-shirts, just someone who appreciates the finer things in life!'),
(3, 1, 'Irish', 'It was Churchill who remarked that he thought the Irish most curious because they didn\'t want to be English. How right he was! But then, he was half-American, wasn\'t he? If you have an Irish genealogy you will want these T-shirts! If you suddenly turn Irish on St. Patrick\'s Day, you too will want these T-shirts! Take a look at some of the coolest T-shirts we have!'),
(5, 2, 'Flower', 'These unique and beautiful flower T-shirts are just the item for the gardener, flower arranger, florist, or general lover of things beautiful. Surprise the flower in your life with one of the beautiful botanical T-shirts or just get a few for yourself!'),
(6, 3, 'Christmas', ' Because this is a unique Christmas T-shirt that you\'ll only wear a few times a year, it will probably last for decades (unless some grinch nabs it from you, of course). Far into the future, after you\'re gone, your grandkids will pull it out and argue over who gets to wear it. What great snapshots they\'ll make dressed in Grandpa or Grandma\'s incredibly tasteful and unique Christmas T-shirt! Yes, everyone will remember you forever and what a silly goof you were when you would wear only your Santa beard and cap so you wouldn\'t cover up your nifty T-shirt.'),
(7, 3, 'Valentine\'s', 'For the more timid, all you have to do is wear your heartfelt message to get it across. Buy one for you and your sweetie(s) today!');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` char(60) DEFAULT NULL,
  `facebook_id` varchar(100),
  `credit_card` text,
  `address_1` varchar(100) DEFAULT NULL,
  `address_2` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `postal_code` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `shipping_region_id` int(11) NOT NULL DEFAULT '1',
  `day_phone` varchar(100) DEFAULT NULL,
  `eve_phone` varchar(100) DEFAULT NULL,
  `mob_phone` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `name`, `email`, `password`, `facebook_id`, `credit_card`, `address_1`, `address_2`, `city`, `region`, `postal_code`, `country`, `shipping_region_id`, `day_phone`, `eve_phone`, `mob_phone`) VALUES
(20, 'oluwafemi', 'tiresssssd@gmail.com', '12345', 988798783748,NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `department_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(1000) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`department_id`, `name`, `description`) VALUES
(1, 'Regional', 'Proud of your country? Wear a T-shirt with a national symbol stamp!'),
(2, 'test category', 'test description'),
(3, 'Seasonal', 'Each time of the year has a special flavor. Our seasonal T-shirts express traditional symbols using unique postal stamp pictures.');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `created_on` datetime NOT NULL,
  `shipped_on` datetime DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `comments` varchar(255) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `auth_code` varchar(50) DEFAULT NULL,
  `reference` varchar(50) DEFAULT NULL,
  `shipping_id` int(11) DEFAULT NULL,
  `tax_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `total_amount`, `created_on`, `shipped_on`, `status`, `comments`, `customer_id`, `auth_code`, `reference`, `shipping_id`, `tax_id`) VALUES
(1, '1000.00', '2019-03-12 02:20:33', NULL, 0, NULL, 31, NULL, 'GVERS', 2, NULL),
(2, '1000.00', '2019-03-13 00:49:41', NULL, 0, NULL, 32, NULL, 'CDPVE', 2, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_detail`
--

CREATE TABLE `order_detail` (
  `item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `attributes` varchar(1000) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_cost` decimal(10,2) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `amount` bigint(20) NOT NULL,
  `currency` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `discounted_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `image` varchar(150) DEFAULT NULL,
  `image_2` varchar(150) DEFAULT NULL,
  `thumbnail` varchar(150) DEFAULT NULL,
  `display` smallint(6) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `name`, `description`, `price`, `discounted_price`, `image`, `image_2`, `thumbnail`, `display`) VALUES
(1, 'Arc d\'Triomphe', 'This beautiful and iconic T-shirt will no doubt lead you to your own triumph.', '14.99', '0.00', 'arc-d-triomphe.gif', 'arc-d-triomphe-2.gif', 'arc-d-triomphe-thumbnail.gif', 0),
(2, 'Chartres Cathedral', '\"The Fur Merchants\". Not all the beautiful stained glass in the great cathedrals depicts saints and angels! Lay aside your furs for the summer and wear this beautiful T-shirt!', '16.95', '15.95', 'chartres-cathedral.gif', 'chartres-cathedral-2.gif', 'chartres-cathedral-thumbnail.gif', 2),
(3, 'Coat of Arms', 'There\'s good reason why the ship plays a prominent part on this shield!', '14.50', '0.00', 'coat-of-arms.gif', 'coat-of-arms-2.gif', 'coat-of-arms-thumbnail.gif', 0),
(4, 'Gallic Cock', 'This fancy chicken is perhaps the most beloved of all French symbols. Unfortunately, there are only a few hundred left, so you\'d better get your T-shirt now!', '18.99', '16.99', 'gallic-cock.gif', 'gallic-cock-2.gif', 'gallic-cock-thumbnail.gif', 2),
(5, 'Marianne', 'She symbolizes the \"Triumph of the Republic\" and has been depicted many different ways in the history of France, as you will see below!', '15.95', '14.95', 'marianne.gif', 'marianne-2.gif', 'marianne-thumbnail.gif', 2),
(6, 'Alsace', 'It was in this region of France that Gutenberg perfected his movable type. If he could only see what he started!', '16.50', '0.00', 'alsace.gif', 'alsace-2.gif', 'alsace-thumbnail.gif', 0),
(7, 'Apocalypse Tapestry', 'One of the most famous tapestries of the Loire Valley, it dates from the 14th century. The T-shirt is of more recent vintage, however.', '20.00', '18.95', 'apocalypse-tapestry.gif', 'apocalypse-tapestry-2.gif', 'apocalypse-tapestry-thumbnail.gif', 0),
(8, 'Centaur', 'There were never any lady centaurs, so these guys had to mate with nymphs and mares. No wonder they were often in such bad moods!', '14.99', '0.00', 'centaur.gif', 'centaur-2.gif', 'centaur-thumbnail.gif', 0),
(9, 'Corsica', 'Borrowed from Spain, the \"Moor\'s head\" may have celebrated the Christians\' victory over the Moslems in that country.', '22.00', '0.00', 'corsica.gif', 'corsica-2.gif', 'corsica-thumbnail.gif', 0),
(10, 'Haute Couture', 'This stamp publicized the dress making industry. Use it to celebrate the T-shirt industry!', '15.99', '14.95', 'haute-couture.gif', 'haute-couture-2.gif', 'haute-couture-thumbnail.gif', 3),
(11, 'Iris', 'Iris was the Goddess of the Rainbow, daughter of the Titans Thaumas and Electra. Are you up to this T-shirt?!', '17.50', '0.00', 'iris.gif', 'iris-2.gif', 'iris-thumbnail.gif', 0),
(12, 'Lorraine', 'The largest American cemetery in France is located in Lorraine and most of the folks there still appreciate that fact.', '16.95', '0.00', 'lorraine.gif', 'lorraine-2.gif', 'lorraine-thumbnail.gif', 0),
(13, 'Mercury', 'Besides being the messenger of the gods, did you know that Mercury was also the god of profit and commerce? This T-shirt is for business owners!', '21.99', '18.95', 'mercury.gif', 'mercury-2.gif', 'mercury-thumbnail.gif', 2),
(14, 'County of Nice', 'Nice is so nice that it has been fought over for millennia, but now it all belongs to France.', '12.95', '0.00', 'county-of-nice.gif', 'county-of-nice-2.gif', 'county-of-nice-thumbnail.gif', 0),
(15, 'Notre Dame', 'Commemorating the 800th anniversary of the famed cathedral.', '18.50', '16.99', 'notre-dame.gif', 'notre-dame-2.gif', 'notre-dame-thumbnail.gif', 2),
(16, 'Paris Peace Conference', 'The resulting treaties allowed Italy, Romania, Hungary, Bulgaria, and Finland to reassume their responsibilities as sovereign states in international affairs and thus qualify for membership in the UN.', '16.95', '15.99', 'paris-peace-conference.gif', 'paris-peace-conference-2.gif', 'paris-peace-conference-thumbnail.gif', 2),
(17, 'Sarah Bernhardt', 'The \"Divine Sarah\" said this about Americans: \"You are younger than we as a race, you are perhaps barbaric, but what of it? You are still in the molding. Your spirit is superb. It is what helped us win the war.\" Perhaps we\'re still barbaric but we\'re still winning wars for them too!', '14.99', '0.00', 'sarah-bernhardt.gif', 'sarah-bernhardt-2.gif', 'sarah-bernhardt-thumbnail.gif', 0),
(18, 'Hunt', 'A scene from \"Les Tres Riches Heures,\" a medieval \"book of hours\" containing the text for each liturgical hour of the day. This scene is from a 14th century painting.', '16.99', '15.95', 'hunt.gif', 'hunt-2.gif', 'hunt-thumbnail.gif', 2),
(19, 'Italia', 'The War had just ended when this stamp was designed, and even so, there was enough optimism to show the destroyed oak tree sprouting again from its stump! What a beautiful T-shirt!', '22.00', '18.99', 'italia.gif', 'italia-2.gif', 'italia-thumbnail.gif', 2),
(20, 'Torch', 'The light goes on! Carry the torch with this T-shirt and be a beacon of hope for the world!', '19.99', '17.95', 'torch.gif', 'torch-2.gif', 'torch-thumbnail.gif', 2),
(21, 'Espresso', 'The winged foot of Mercury speeds the Special Delivery mail to its destination. In a hurry? This T-shirt is for you!', '16.95', '0.00', 'espresso.gif', 'espresso-2.gif', 'espresso-thumbnail.gif', 0),
(22, 'Galileo', 'This beautiful T-shirt does honor to one of Italy\'s (and the world\'s) most famous scientists. Show your appreciation for the education you\'ve received!', '14.99', '0.00', 'galileo.gif', 'galileo-2.gif', 'galileo-thumbnail.gif', 0),
(23, 'Italian Airmail', 'Thanks to modern Italian post, folks were able to reach out and touch each other. Or at least so implies this image. This is a very fast and friendly T-shirt--you\'ll make friends with it!', '21.00', '17.99', 'italian-airmail.gif', 'italian-airmail-2.gif', 'italian-airmail-thumbnail.gif', 0),
(24, 'Mazzini', 'Giuseppe Mazzini is considered one of the patron saints of the \"Risorgimiento.\" Wear this beautiful T-shirt to tell the world you agree!', '20.50', '18.95', 'mazzini.gif', 'mazzini-2.gif', 'mazzini-thumbnail.gif', 2),
(25, 'Romulus & Remus', 'Back in 753 BC, so the story goes, Romulus founded the city of Rome (in competition with Remus, who founded a city on another hill). Their adopted mother is shown in this image. When did they suspect they were adopted?', '17.99', '16.95', 'romulus-remus.gif', 'romulus-remus-2.gif', 'romulus-remus-thumbnail.gif', 2),
(26, 'Italy Maria', 'This beautiful image of the Virgin is from a work by Raphael, whose life and death it honors. It is one of our most popular T-shirts!', '14.00', '0.00', 'italy-maria.gif', 'italy-maria-2.gif', 'italy-maria-thumbnail.gif', 0),
(27, 'Italy Jesus', 'This image of Jesus teaching the gospel was issued to commemorate the third centenary of the \"propagation of the faith.\" Now you can do your part with this T-shirt!', '16.95', '0.00', 'italy-jesus.gif', 'italy-jesus-2.gif', 'italy-jesus-thumbnail.gif', 0),
(28, 'St. Francis', 'Here St. Francis is receiving his vision. This dramatic and attractive stamp was issued on the 700th anniversary of that event.', '22.00', '18.99', 'st-francis.gif', 'st-francis-2.gif', 'st-francis-thumbnail.gif', 2),
(29, 'Irish Coat of Arms', 'This was one of the first stamps of the new Irish Republic, and it makes a T-shirt you\'ll be proud to wear on St. Paddy\'s Day!', '14.99', '0.00', 'irish-coat-of-arms.gif', 'irish-coat-of-arms-2.gif', 'irish-coat-of-arms-thumbnail.gif', 0),
(30, 'Easter Rebellion', 'The Easter Rebellion of 1916 was a defining moment in Irish history. Although only a few hundred participated and the British squashed it in a week, its leaders were executed, which galvanized the uncommitted.', '19.00', '16.95', 'easter-rebellion.gif', 'easter-rebellion-2.gif', 'easter-rebellion-thumbnail.gif', 2),
(31, 'Guiness', 'Class! Who is this man and why is he important enough for his own T-shirt?!', '15.00', '0.00', 'guiness.gif', 'guiness-2.gif', 'guiness-thumbnail.gif', 0),
(32, 'St. Patrick', 'This stamp commemorated the 1500th anniversary of the revered saint\'s death. Is there a more perfect St. Patrick\'s Day T-shirt?!', '20.50', '17.95', 'st-patrick.gif', 'st-patrick-2.gif', 'st-patrick-thumbnail.gif', 0),
(33, 'St. Peter', 'This T-shirt commemorates the holy year of 1950.', '16.00', '14.95', 'st-peter.gif', 'st-peter-2.gif', 'st-peter-thumbnail.gif', 2),
(34, 'Sword of Light', 'This was the very first Irish postage stamp, and what a beautiful and cool T-shirt it makes for the Irish person in your life!', '14.99', '0.00', 'sword-of-light.gif', 'sword-of-light-2.gif', 'sword-of-light-thumbnail.gif', 0),
(35, 'Thomas Moore', 'One of the greatest if not the greatest of Irish poets and writers, Moore led a very interesting life, though plagued with tragedy in a somewhat typically Irish way. Remember \"The Last Rose of Summer\"?', '15.95', '14.99', 'thomas-moore.gif', 'thomas-moore-2.gif', 'thomas-moore-thumbnail.gif', 2),
(36, 'Visit the Zoo', 'This WPA poster is a wonderful example of the art produced by the Works Projects Administration during the Depression years. Do you feel like you sometimes live or work in a zoo? Then this T-shirt is for you!', '20.00', '16.95', 'visit-the-zoo.gif', 'visit-the-zoo-2.gif', 'visit-the-zoo-thumbnail.gif', 2),
(37, 'Sambar', 'This handsome Malayan Sambar was a pain in the neck to get to pose like this, and all so you could have this beautiful retro animal T-shirt!', '19.00', '17.99', 'sambar.gif', 'sambar-2.gif', 'sambar-thumbnail.gif', 2),
(38, 'Buffalo', 'Of all the critters in our T-shirt zoo, this is one of our most popular. A classic animal T-shirt for an individual like yourself!', '14.99', '0.00', 'buffalo.gif', 'buffalo-2.gif', 'buffalo-thumbnail.gif', 0),
(39, 'Mustache Monkey', 'This fellow is more than equipped to hang out with that tail of his, just like you\'ll be fit for hanging out with this great animal T-shirt!', '20.00', '17.95', 'mustache-monkey.gif', 'mustache-monkey-2.gif', 'mustache-monkey-thumbnail.gif', 2),
(40, 'Colobus', 'Why is he called \"Colobus,\" \"the mutilated one\"? He doesn\'t have a thumb, just four fingers! He is far from handicapped, however; his hands make him the great swinger he is. Speaking of swinging, that\'s what you\'ll do with this beautiful animal T-shirt!', '17.00', '15.99', 'colobus.gif', 'colobus-2.gif', 'colobus-thumbnail.gif', 2),
(41, 'Canada Goose', 'Being on a major flyway for these guys, we know all about these majestic birds. They hang out in large numbers on a lake near our house and fly over constantly. Remember what Frankie Lane said? \"I want to go where the wild goose goes!\" And when you go, wear this cool Canada goose animal T-shirt.', '15.99', '0.00', 'canada-goose.gif', 'canada-goose-2.gif', 'canada-goose-thumbnail.gif', 0),
(42, 'Congo Rhino', 'Among land mammals, this white rhino is surpassed in size only by the elephant. He has a big fan base too, working hard to make sure he sticks around. You\'ll be a fan of his, too, when people admire this unique and beautiful T-shirt on you!', '20.00', '18.99', 'congo-rhino.gif', 'congo-rhino-2.gif', 'congo-rhino-thumbnail.gif', 2),
(43, 'Equatorial Rhino', 'There\'s a lot going on in this frame! A black rhino is checking out that python slithering off into the bush--or is he eyeing you? You can bet all eyes will be on you when you wear this T-shirt!', '19.95', '17.95', 'equatorial-rhino.gif', 'equatorial-rhino-2.gif', 'equatorial-rhino-thumbnail.gif', 2),
(44, 'Ethiopian Rhino', 'Another white rhino is honored in this classic design that bespeaks the Africa of the early century. This pointillist and retro T-shirt will definitely turn heads!', '16.00', '0.00', 'ethiopian-rhino.gif', 'ethiopian-rhino-2.gif', 'ethiopian-rhino-thumbnail.gif', 0),
(45, 'Dutch Sea Horse', 'I think this T-shirt is destined to be one of our most popular simply because it is one of our most beautiful!', '12.50', '0.00', 'dutch-sea-horse.gif', 'dutch-sea-horse-2.gif', 'dutch-sea-horse-thumbnail.gif', 0),
(46, 'Dutch Swans', 'This stamp was designed in the middle of the Nazi occupation, as was the one above. Together they reflect a spirit of beauty that evil could not suppress. Both of these T-shirts will make it impossible to suppress your artistic soul, too!', '21.00', '18.99', 'dutch-swans.gif', 'dutch-swans-2.gif', 'dutch-swans-thumbnail.gif', 2),
(47, 'Ethiopian Elephant', 'From the same series as the Ethiopian Rhino and the Ostriches, this stylish elephant T-shirt will mark you as a connoisseur of good taste!', '18.99', '16.95', 'ethiopian-elephant.gif', 'ethiopian-elephant-2.gif', 'ethiopian-elephant-thumbnail.gif', 2),
(48, 'Laotian Elephant', 'This working guy is proud to have his own stamp, and now he has his own T-shirt!', '21.00', '18.99', 'laotian-elephant.gif', 'laotian-elephant-2.gif', 'laotian-elephant-thumbnail.gif', 0),
(49, 'Liberian Elephant', 'And yet another Jumbo! You need nothing but a big heart to wear this T-shirt (or a big sense of style)!', '22.00', '17.50', 'liberian-elephant.gif', 'liberian-elephant-2.gif', 'liberian-elephant-thumbnail.gif', 2),
(50, 'Somali Ostriches', 'Another in an old series of beautiful stamps from Ethiopia. These big birds pack quite a wallop, and so will you when you wear this uniquely retro T-shirt!', '12.95', '0.00', 'somali-ostriches.gif', 'somali-ostriches-2.gif', 'somali-ostriches-thumbnail.gif', 0),
(51, 'Tankanyika Giraffe', 'The photographer had to stand on a step ladder for this handsome portrait, but his efforts paid off with an angle we seldom see of this lofty creature. This beautiful retro T-shirt would make him proud!', '15.00', '12.99', 'tankanyika-giraffe.gif', 'tankanyika-giraffe-2.gif', 'tankanyika-giraffe-thumbnail.gif', 3),
(52, 'Ifni Fish', 'This beautiful stamp was issued to commemorate National Colonial Stamp Day (you can do that when you have a colony). When you wear this fancy fish T-shirt, your friends will think it\'s national T-shirt day!', '14.00', '0.00', 'ifni-fish.gif', 'ifni-fish-2.gif', 'ifni-fish-thumbnail.gif', 0),
(53, 'Sea Gull', 'A beautiful stamp from a small enclave in southern Morocco that belonged to Spain until 1969 makes a beautiful bird T-shirt.', '19.00', '16.95', 'sea-gull.gif', 'sea-gull-2.gif', 'sea-gull-thumbnail.gif', 2),
(54, 'King Salmon', 'You can fish them and eat them and now you can wear them with this classic animal T-shirt.', '17.95', '15.99', 'king-salmon.gif', 'king-salmon-2.gif', 'king-salmon-thumbnail.gif', 2),
(55, 'Laos Bird', 'This fellow is also known as the \"White Crested Laughing Thrush.\" What\'s he laughing at? Why, at the joy of being on your T-shirt!', '12.00', '0.00', 'laos-bird.gif', 'laos-bird-2.gif', 'laos-bird-thumbnail.gif', 0),
(56, 'Mozambique Lion', 'The Portuguese were too busy to run this colony themselves so they gave the Mozambique Company a charter to do it. I think there must be some pretty curious history related to that (the charter only lasted for 50 years)! If you\'re a Leo, or know a Leo, you should seriously consider this T-shirt!', '15.99', '14.95', 'mozambique-lion.gif', 'mozambique-lion-2.gif', 'mozambique-lion-thumbnail.gif', 2),
(57, 'Peru Llama', 'This image is nearly 100 years old! Little did this little llama realize that he was going to be made immortal on the Web and on this very unique animal T-shirt (actually, little did he know at all)!', '21.50', '17.99', 'peru-llama.gif', 'peru-llama-2.gif', 'peru-llama-thumbnail.gif', 2),
(58, 'Romania Alsatian', 'If you know and love this breed, there\'s no reason in the world that you shouldn\'t buy this T-shirt right now!', '15.95', '0.00', 'romania-alsatian.gif', 'romania-alsatian-2.gif', 'romania-alsatian-thumbnail.gif', 0),
(59, 'Somali Fish', 'This is our most popular fish T-shirt, hands down. It\'s a beauty, and if you wear this T-shirt, you\'ll be letting the world know you\'re a fine catch!', '19.95', '16.95', 'somali-fish.gif', 'somali-fish-2.gif', 'somali-fish-thumbnail.gif', 2),
(60, 'Trout', 'This beautiful image will warm the heart of any fisherman! You must know one if you\'re not one yourself, so you must buy this T-shirt!', '14.00', '0.00', 'trout.gif', 'trout-2.gif', 'trout-thumbnail.gif', 0),
(61, 'Baby Seal', 'Ahhhhhh! This little harp seal would really prefer not to be your coat! But he would like to be your T-shirt!', '21.00', '18.99', 'baby-seal.gif', 'baby-seal-2.gif', 'baby-seal-thumbnail.gif', 2),
(62, 'Musk Ox', 'Some critters you just don\'t want to fool with, and if I were facing this fellow I\'d politely give him the trail! That is, of course, unless I were wearing this T-shirt.', '15.50', '0.00', 'musk-ox.gif', 'musk-ox-2.gif', 'musk-ox-thumbnail.gif', 0),
(63, 'Suvla Bay', ' In 1915, Newfoundland sent its Newfoundland Regiment to Suvla Bay in Gallipoli to fight the Turks. This classic image does them honor. Have you ever heard of them? Share the news with this great T-shirt!', '12.99', '0.00', 'suvla-bay.gif', 'suvla-bay-2.gif', 'suvla-bay-thumbnail.gif', 0),
(64, 'Caribou', 'There was a time when Newfoundland was a self-governing dominion of the British Empire, so it printed its own postage. The themes are as typically Canadian as can be, however, as shown by this \"King of the Wilde\" T-shirt!', '21.00', '19.95', 'caribou.gif', 'caribou-2.gif', 'caribou-thumbnail.gif', 2),
(65, 'Afghan Flower', 'This beautiful image was issued to celebrate National Teachers Day. Perhaps you know a teacher who would love this T-shirt?', '18.50', '16.99', 'afghan-flower.gif', 'afghan-flower-2.gif', 'afghan-flower-thumbnail.gif', 2),
(66, 'Albania Flower', 'Well, these crab apples started out as flowers, so that\'s close enough for us! They still make for a uniquely beautiful T-shirt.', '16.00', '14.95', 'albania-flower.gif', 'albania-flower-2.gif', 'albania-flower-thumbnail.gif', 2),
(67, 'Austria Flower', 'Have you ever had nasturtiums on your salad? Try it--they\'re almost as good as having them on your T-shirt!', '12.99', '0.00', 'austria-flower.gif', 'austria-flower-2.gif', 'austria-flower-thumbnail.gif', 0),
(68, 'Bulgarian Flower', 'For your interest (and to impress your friends), this beautiful stamp was issued to honor the George Dimitrov state printing works. You\'ll need to know this when you wear the T-shirt.', '16.00', '14.99', 'bulgarian-flower.gif', 'bulgarian-flower-2.gif', 'bulgarian-flower-thumbnail.gif', 2),
(69, 'Colombia Flower', 'Celebrating the 75th anniversary of the Universal Postal Union, a date to mark on your calendar and on which to wear this T-shirt!', '14.50', '12.95', 'colombia-flower.gif', 'colombia-flower-2.gif', 'colombia-flower-thumbnail.gif', 1),
(70, 'Congo Flower', 'The Congo is not at a loss for beautiful flowers, and we\'ve picked a few of them for your T-shirts.', '21.00', '17.99', 'congo-flower.gif', 'congo-flower-2.gif', 'congo-flower-thumbnail.gif', 2),
(71, 'Costa Rica Flower', 'This national flower of Costa Rica is one of our most beloved flower T-shirts (you can see one on Jill, above). You will surely stand out in this T-shirt!', '12.99', '0.00', 'costa-rica-flower.gif', 'costa-rica-flower.gif', 'costa-rica-flower-thumbnail.gif', 0),
(72, 'Gabon Flower', 'The combretum, also known as \"jungle weed,\" is used in China as a cure for opium addiction. Unfortunately, when you wear this T-shirt, others may become hopelessly addicted to you!', '19.00', '16.95', 'gabon-flower.gif', 'gabon-flower-2.gif', 'gabon-flower-thumbnail.gif', 2),
(73, 'Ghana Flower', 'This is one of the first gingers to bloom in the spring--just like you when you wear this T-shirt!', '21.00', '18.99', 'ghana-flower.gif', 'ghana-flower-2.gif', 'ghana-flower-thumbnail.gif', 2),
(74, 'Israel Flower', 'This plant is native to the rocky and sandy regions of the western United States, so when you come across one, it really stands out. And so will you when you put on this beautiful T-shirt!', '19.50', '17.50', 'israel-flower.gif', 'israel-flower-2.gif', 'israel-flower-thumbnail.gif', 2),
(75, 'Poland Flower', 'A beautiful and sunny T-shirt for both spring and summer!', '16.95', '15.99', 'poland-flower.gif', 'poland-flower-2.gif', 'poland-flower-thumbnail.gif', 2),
(76, 'Romania Flower', 'Also known as the spring pheasant\'s eye, this flower belongs on your T-shirt this summer to help you catch a few eyes.', '12.95', '0.00', 'romania-flower.gif', 'romania-flower-2.gif', 'romania-flower-thumbnail.gif', 0),
(77, 'Russia Flower', 'Someone out there who can speak Russian needs to tell me what this plant is. I\'ll sell you the T-shirt for $10 if you can!', '21.00', '18.95', 'russia-flower.gif', 'russia-flower-2.gif', 'russia-flower-thumbnail.gif', 0),
(78, 'San Marino Flower', '\"A white sport coat and a pink carnation, I\'m all dressed up for the dance!\" Well, how about a white T-shirt and a pink carnation?!', '19.95', '17.99', 'san-marino-flower.gif', 'san-marino-flower-2.gif', 'san-marino-flower-thumbnail.gif', 2),
(79, 'Uruguay Flower', 'The Indian Queen Anahi was the ugliest woman ever seen. But instead of living a slave when captured by the Conquistadores, she immolated herself in a fire and was reborn the most beautiful of flowers: the ceibo, national flower of Uruguay. Of course, you won\'t need to burn to wear this T-shirt, but you may cause some pretty hot glances to be thrown your way!', '17.99', '16.99', 'uruguay-flower.gif', 'uruguay-flower-2.gif', 'uruguay-flower-thumbnail.gif', 2),
(80, 'Snow Deer', 'Tarmo has produced some wonderful Christmas T-shirts for us, and we hope to have many more soon.', '21.00', '18.95', 'snow-deer.gif', 'snow-deer-2.gif', 'snow-deer-thumbnail.gif', 2),
(81, 'Holly Cat', 'Few things make a cat happier at Christmas than a tree suddenly appearing in the house!', '15.99', '0.00', 'holly-cat.gif', 'holly-cat-2.gif', 'holly-cat-thumbnail.gif', 0),
(82, 'Christmas Seal', 'Is this your grandmother? It could be, you know, and I\'d bet she\'d recognize the Christmas seal on this cool Christmas T-shirt.', '19.99', '17.99', 'christmas-seal.gif', 'christmas-seal-2.gif', 'christmas-seal-thumbnail.gif', 2),
(83, 'Weather Vane', 'This weather vane dates from the 1830\'s and is still showing which way the wind blows! Trumpet your arrival with this unique Christmas T-shirt.', '15.95', '14.99', 'weather-vane.gif', 'weather-vane-2.gif', 'weather-vane-thumbnail.gif', 2),
(84, 'Mistletoe', 'This well-known parasite and killer of trees was revered by the Druids, who would go out and gather it with great ceremony. Youths would go about with it to announce the new year. Eventually more engaging customs were attached to the strange plant, and we\'re here to see that they continue with these cool Christmas T-shirts.', '19.00', '17.99', 'mistletoe.gif', 'mistletoe-2.gif', 'mistletoe-thumbnail.gif', 3),
(85, 'Altar Piece', 'This beautiful angel Christmas T-shirt is awaiting the opportunity to adorn your chest!', '20.50', '18.50', 'altar-piece.gif', 'altar-piece-2.gif', 'altar-piece-thumbnail.gif', 2),
(86, 'The Three Wise Men', 'This is a classic rendition of one of the season?s most beloved stories, and now showing on a Christmas T-shirt for you!', '12.99', '0.00', 'the-three-wise-men.gif', 'the-three-wise-men-2.gif', 'the-three-wise-men-thumbnail.gif', 0),
(87, 'Christmas Tree', 'Can you get more warm and folksy than this classic Christmas T-shirt?', '20.00', '17.95', 'christmas-tree.gif', 'christmas-tree-2.gif', 'christmas-tree-thumbnail.gif', 2),
(88, 'Madonna & Child', 'This exquisite image was painted by Filipino Lippi, a 15th century Italian artist. I think he would approve of it on a Going Postal Christmas T-shirt!', '21.95', '18.50', 'madonna-child.gif', 'madonna-child-2.gif', 'madonna-child-thumbnail.gif', 0),
(89, 'The Virgin Mary', 'This stained glass window is found in Glasgow Cathedral, Scotland, and was created by Gabriel Loire of France, one of the most prolific of artists in this medium--and now you can have it on this wonderful Christmas T-shirt.', '16.95', '15.95', 'the-virgin-mary.gif', 'the-virgin-mary-2.gif', 'the-virgin-mary-thumbnail.gif', 2),
(90, 'Adoration of the Kings', 'This design is from a miniature in the Evangelistary of Matilda in Nonantola Abbey, from the 12th century. As a Christmas T-shirt, it will cause you to be adored!', '17.50', '16.50', 'adoration-of-the-kings.gif', 'adoration-of-the-kings-2.gif', 'adoration-of-the-kings-thumbnail.gif', 2),
(91, 'A Partridge in a Pear Tree', 'The original of this beautiful stamp is by Jamie Wyeth and is in the National Gallery of Art. The next best is on our beautiful Christmas T-shirt!', '14.99', '0.00', 'a-partridge-in-a-pear-tree.gif', 'a-partridge-in-a-pear-tree-2.gif', 'a-partridge-in-a-pear-tree-thumbnail.gif', 0),
(92, 'St. Lucy', 'This is a tiny detail of a large work called \"Mary, Queen of Heaven,\" done in 1480 by a Flemish master known only as \"The Master of St. Lucy Legend.\" The original is in a Bruges church. The not-quite-original is on this cool Christmas T-shirt.', '18.95', '0.00', 'st-lucy.gif', 'st-lucy-2.gif', 'st-lucy-thumbnail.gif', 0),
(93, 'St. Lucia', 'Saint Lucia\'s tradition is an important part of Swedish Christmas, and an important part of that are the candles. Next to the candles in importance is this popular Christmas T-shirt!', '19.00', '17.95', 'st-lucia.gif', 'st-lucia-2.gif', 'st-lucia-thumbnail.gif', 2),
(94, 'Swede Santa', 'Santa as a child. You must know a child who would love this cool Christmas T-shirt!?', '21.00', '18.50', 'swede-santa.gif', 'swede-santa-2.gif', 'swede-santa-thumbnail.gif', 2),
(95, 'Wreath', 'Hey! I\'ve got an idea! Why not buy two of these cool Christmas T-shirts so you can wear one and tack the other one to your door?!', '18.99', '16.99', 'wreath.gif', 'wreath-2.gif', 'wreath-thumbnail.gif', 2),
(96, 'Love', 'Here\'s a Valentine\'s day T-shirt that will let you say it all in just one easy glance--there\'s no mistake about it!', '19.00', '17.50', 'love.gif', 'love-2.gif', 'love-thumbnail.gif', 2),
(97, 'Birds', 'Is your heart all aflutter? Show it with this T-shirt!', '21.00', '18.95', 'birds.gif', 'birds-2.gif', 'birds-thumbnail.gif', 2),
(98, 'Kat Over New Moon', 'Love making you feel lighthearted?', '14.99', '0.00', 'kat-over-new-moon.gif', 'kat-over-new-moon-2.gif', 'kat-over-new-moon-thumbnail.gif', 0),
(99, 'Thrilling Love', 'This girl\'s got her hockey hunk right where she wants him!', '21.00', '18.50', 'thrilling-love.gif', 'thrilling-love-2.gif', 'thrilling-love-thumbnail.gif', 2),
(100, 'The Rapture of Psyche', 'Now we\'re getting a bit more serious!', '18.95', '16.99', 'the-rapture-of-psyche.gif', 'the-rapture-of-psyche-2.gif', 'the-rapture-of-psyche-thumbnail.gif', 2);

-- --------------------------------------------------------

--
-- Table structure for table `product_attribute`
--

CREATE TABLE `product_attribute` (
  `product_id` int(11) NOT NULL,
  `attribute_value_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product_attribute`
--

INSERT INTO `product_attribute` (`product_id`, `attribute_value_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(2, 11),
(2, 12),
(2, 13),
(2, 14),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(3, 10),
(3, 11),
(3, 12),
(3, 13),
(3, 14),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(4, 9),
(4, 10),
(4, 11),
(4, 12),
(4, 13),
(4, 14),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(5, 5),
(5, 6),
(5, 7),
(5, 8),
(5, 9),
(5, 10),
(5, 11),
(5, 12),
(5, 13),
(5, 14),
(6, 1),
(6, 2),
(6, 3),
(6, 4),
(6, 5),
(6, 6),
(6, 7),
(6, 8),
(6, 9),
(6, 10),
(6, 11),
(6, 12),
(6, 13),
(6, 14),
(7, 1),
(7, 2),
(7, 3),
(7, 4),
(7, 5),
(7, 6),
(7, 7),
(7, 8),
(7, 9),
(7, 10),
(7, 11),
(7, 12),
(7, 13),
(7, 14),
(8, 1),
(8, 2),
(8, 3),
(8, 4),
(8, 5),
(8, 6),
(8, 7),
(8, 8),
(8, 9),
(8, 10),
(8, 11),
(8, 12),
(8, 13),
(8, 14),
(9, 1),
(9, 2),
(9, 3),
(9, 4),
(9, 5),
(9, 6),
(9, 7),
(9, 8),
(9, 9),
(9, 10),
(9, 11),
(9, 12),
(9, 13),
(9, 14),
(10, 1),
(10, 2),
(10, 3),
(10, 4),
(10, 5),
(10, 6),
(10, 7),
(10, 8),
(10, 9),
(10, 10),
(10, 11),
(10, 12),
(10, 13),
(10, 14),
(11, 1),
(11, 2),
(11, 3),
(11, 4),
(11, 5),
(11, 6),
(11, 7),
(11, 8),
(11, 9),
(11, 10),
(11, 11),
(11, 12),
(11, 13),
(11, 14),
(12, 1),
(12, 2),
(12, 3),
(12, 4),
(12, 5),
(12, 6),
(12, 7),
(12, 8),
(12, 9),
(12, 10),
(12, 11),
(12, 12),
(12, 13),
(12, 14),
(13, 1),
(13, 2),
(13, 3),
(13, 4),
(13, 5),
(13, 6),
(13, 7),
(13, 8),
(13, 9),
(13, 10),
(13, 11),
(13, 12),
(13, 13),
(13, 14),
(14, 1),
(14, 2),
(14, 3),
(14, 4),
(14, 5),
(14, 6),
(14, 7),
(14, 8),
(14, 9),
(14, 10),
(14, 11),
(14, 12),
(14, 13),
(14, 14),
(15, 1),
(15, 2),
(15, 3),
(15, 4),
(15, 5),
(15, 6),
(15, 7),
(15, 8),
(15, 9),
(15, 10),
(15, 11),
(15, 12),
(15, 13),
(15, 14),
(16, 1),
(16, 2),
(16, 3),
(16, 4),
(16, 5),
(16, 6),
(16, 7),
(16, 8),
(16, 9),
(16, 10),
(16, 11),
(16, 12),
(16, 13),
(16, 14),
(17, 1),
(17, 2),
(17, 3),
(17, 4),
(17, 5),
(17, 6),
(17, 7),
(17, 8),
(17, 9),
(17, 10),
(17, 11),
(17, 12),
(17, 13),
(17, 14),
(18, 1),
(18, 2),
(18, 3),
(18, 4),
(18, 5),
(18, 6),
(18, 7),
(18, 8),
(18, 9),
(18, 10),
(18, 11),
(18, 12),
(18, 13),
(18, 14),
(19, 1),
(19, 2),
(19, 3),
(19, 4),
(19, 5),
(19, 6),
(19, 7),
(19, 8),
(19, 9),
(19, 10),
(19, 11),
(19, 12),
(19, 13),
(19, 14),
(20, 1),
(20, 2),
(20, 3),
(20, 4),
(20, 5),
(20, 6),
(20, 7),
(20, 8),
(20, 9),
(20, 10),
(20, 11),
(20, 12),
(20, 13),
(20, 14),
(21, 1),
(21, 2),
(21, 3),
(21, 4),
(21, 5),
(21, 6),
(21, 7),
(21, 8),
(21, 9),
(21, 10),
(21, 11),
(21, 12),
(21, 13),
(21, 14),
(22, 1),
(22, 2),
(22, 3),
(22, 4),
(22, 5),
(22, 6),
(22, 7),
(22, 8),
(22, 9),
(22, 10),
(22, 11),
(22, 12),
(22, 13),
(22, 14),
(23, 1),
(23, 2),
(23, 3),
(23, 4),
(23, 5),
(23, 6),
(23, 7),
(23, 8),
(23, 9),
(23, 10),
(23, 11),
(23, 12),
(23, 13),
(23, 14),
(24, 1),
(24, 2),
(24, 3),
(24, 4),
(24, 5),
(24, 6),
(24, 7),
(24, 8),
(24, 9),
(24, 10),
(24, 11),
(24, 12),
(24, 13),
(24, 14),
(25, 1),
(25, 2),
(25, 3),
(25, 4),
(25, 5),
(25, 6),
(25, 7),
(25, 8),
(25, 9),
(25, 10),
(25, 11),
(25, 12),
(25, 13),
(25, 14),
(26, 1),
(26, 2),
(26, 3),
(26, 4),
(26, 5),
(26, 6),
(26, 7),
(26, 8),
(26, 9),
(26, 10),
(26, 11),
(26, 12),
(26, 13),
(26, 14),
(27, 1),
(27, 2),
(27, 3),
(27, 4),
(27, 5),
(27, 6),
(27, 7),
(27, 8),
(27, 9),
(27, 10),
(27, 11),
(27, 12),
(27, 13),
(27, 14),
(28, 1),
(28, 2),
(28, 3),
(28, 4),
(28, 5),
(28, 6),
(28, 7),
(28, 8),
(28, 9),
(28, 10),
(28, 11),
(28, 12),
(28, 13),
(28, 14),
(29, 1),
(29, 2),
(29, 3),
(29, 4),
(29, 5),
(29, 6),
(29, 7),
(29, 8),
(29, 9),
(29, 10),
(29, 11),
(29, 12),
(29, 13),
(29, 14),
(30, 1),
(30, 2),
(30, 3),
(30, 4),
(30, 5),
(30, 6),
(30, 7),
(30, 8),
(30, 9),
(30, 10),
(30, 11),
(30, 12),
(30, 13),
(30, 14),
(31, 1),
(31, 2),
(31, 3),
(31, 4),
(31, 5),
(31, 6),
(31, 7),
(31, 8),
(31, 9),
(31, 10),
(31, 11),
(31, 12),
(31, 13),
(31, 14),
(32, 1),
(32, 2),
(32, 3),
(32, 4),
(32, 5),
(32, 6),
(32, 7),
(32, 8),
(32, 9),
(32, 10),
(32, 11),
(32, 12),
(32, 13),
(32, 14),
(33, 1),
(33, 2),
(33, 3),
(33, 4),
(33, 5),
(33, 6),
(33, 7),
(33, 8),
(33, 9),
(33, 10),
(33, 11),
(33, 12),
(33, 13),
(33, 14),
(34, 1),
(34, 2),
(34, 3),
(34, 4),
(34, 5),
(34, 6),
(34, 7),
(34, 8),
(34, 9),
(34, 10),
(34, 11),
(34, 12),
(34, 13),
(34, 14),
(35, 1),
(35, 2),
(35, 3),
(35, 4),
(35, 5),
(35, 6),
(35, 7),
(35, 8),
(35, 9),
(35, 10),
(35, 11),
(35, 12),
(35, 13),
(35, 14),
(36, 1),
(36, 2),
(36, 3),
(36, 4),
(36, 5),
(36, 6),
(36, 7),
(36, 8),
(36, 9),
(36, 10),
(36, 11),
(36, 12),
(36, 13),
(36, 14),
(37, 1),
(37, 2),
(37, 3),
(37, 4),
(37, 5),
(37, 6),
(37, 7),
(37, 8),
(37, 9),
(37, 10),
(37, 11),
(37, 12),
(37, 13),
(37, 14),
(38, 1),
(38, 2),
(38, 3),
(38, 4),
(38, 5),
(38, 6),
(38, 7),
(38, 8),
(38, 9),
(38, 10),
(38, 11),
(38, 12),
(38, 13),
(38, 14),
(39, 1),
(39, 2),
(39, 3),
(39, 4),
(39, 5),
(39, 6),
(39, 7),
(39, 8),
(39, 9),
(39, 10),
(39, 11),
(39, 12),
(39, 13),
(39, 14),
(40, 1),
(40, 2),
(40, 3),
(40, 4),
(40, 5),
(40, 6),
(40, 7),
(40, 8),
(40, 9),
(40, 10),
(40, 11),
(40, 12),
(40, 13),
(40, 14),
(41, 1),
(41, 2),
(41, 3),
(41, 4),
(41, 5),
(41, 6),
(41, 7),
(41, 8),
(41, 9),
(41, 10),
(41, 11),
(41, 12),
(41, 13),
(41, 14),
(42, 1),
(42, 2),
(42, 3),
(42, 4),
(42, 5),
(42, 6),
(42, 7),
(42, 8),
(42, 9),
(42, 10),
(42, 11),
(42, 12),
(42, 13),
(42, 14),
(43, 1),
(43, 2),
(43, 3),
(43, 4),
(43, 5),
(43, 6),
(43, 7),
(43, 8),
(43, 9),
(43, 10),
(43, 11),
(43, 12),
(43, 13),
(43, 14),
(44, 1),
(44, 2),
(44, 3),
(44, 4),
(44, 5),
(44, 6),
(44, 7),
(44, 8),
(44, 9),
(44, 10),
(44, 11),
(44, 12),
(44, 13),
(44, 14),
(45, 1),
(45, 2),
(45, 3),
(45, 4),
(45, 5),
(45, 6),
(45, 7),
(45, 8),
(45, 9),
(45, 10),
(45, 11),
(45, 12),
(45, 13),
(45, 14),
(46, 1),
(46, 2),
(46, 3),
(46, 4),
(46, 5),
(46, 6),
(46, 7),
(46, 8),
(46, 9),
(46, 10),
(46, 11),
(46, 12),
(46, 13),
(46, 14),
(47, 1),
(47, 2),
(47, 3),
(47, 4),
(47, 5),
(47, 6),
(47, 7),
(47, 8),
(47, 9),
(47, 10),
(47, 11),
(47, 12),
(47, 13),
(47, 14),
(48, 1),
(48, 2),
(48, 3),
(48, 4),
(48, 5),
(48, 6),
(48, 7),
(48, 8),
(48, 9),
(48, 10),
(48, 11),
(48, 12),
(48, 13),
(48, 14),
(49, 1),
(49, 2),
(49, 3),
(49, 4),
(49, 5),
(49, 6),
(49, 7),
(49, 8),
(49, 9),
(49, 10),
(49, 11),
(49, 12),
(49, 13),
(49, 14),
(50, 1),
(50, 2),
(50, 3),
(50, 4),
(50, 5),
(50, 6),
(50, 7),
(50, 8),
(50, 9),
(50, 10),
(50, 11),
(50, 12),
(50, 13),
(50, 14),
(51, 1),
(51, 2),
(51, 3),
(51, 4),
(51, 5),
(51, 6),
(51, 7),
(51, 8),
(51, 9),
(51, 10),
(51, 11),
(51, 12),
(51, 13),
(51, 14),
(52, 1),
(52, 2),
(52, 3),
(52, 4),
(52, 5),
(52, 6),
(52, 7),
(52, 8),
(52, 9),
(52, 10),
(52, 11),
(52, 12),
(52, 13),
(52, 14),
(53, 1),
(53, 2),
(53, 3),
(53, 4),
(53, 5),
(53, 6),
(53, 7),
(53, 8),
(53, 9),
(53, 10),
(53, 11),
(53, 12),
(53, 13),
(53, 14),
(54, 1),
(54, 2),
(54, 3),
(54, 4),
(54, 5),
(54, 6),
(54, 7),
(54, 8),
(54, 9),
(54, 10),
(54, 11),
(54, 12),
(54, 13),
(54, 14),
(55, 1),
(55, 2),
(55, 3),
(55, 4),
(55, 5),
(55, 6),
(55, 7),
(55, 8),
(55, 9),
(55, 10),
(55, 11),
(55, 12),
(55, 13),
(55, 14),
(56, 1),
(56, 2),
(56, 3),
(56, 4),
(56, 5),
(56, 6),
(56, 7),
(56, 8),
(56, 9),
(56, 10),
(56, 11),
(56, 12),
(56, 13),
(56, 14),
(57, 1),
(57, 2),
(57, 3),
(57, 4),
(57, 5),
(57, 6),
(57, 7),
(57, 8),
(57, 9),
(57, 10),
(57, 11),
(57, 12),
(57, 13),
(57, 14),
(58, 1),
(58, 2),
(58, 3),
(58, 4),
(58, 5),
(58, 6),
(58, 7),
(58, 8),
(58, 9),
(58, 10),
(58, 11),
(58, 12),
(58, 13),
(58, 14),
(59, 1),
(59, 2),
(59, 3),
(59, 4),
(59, 5),
(59, 6),
(59, 7),
(59, 8),
(59, 9),
(59, 10),
(59, 11),
(59, 12),
(59, 13),
(59, 14),
(60, 1),
(60, 2),
(60, 3),
(60, 4),
(60, 5),
(60, 6),
(60, 7),
(60, 8),
(60, 9),
(60, 10),
(60, 11),
(60, 12),
(60, 13),
(60, 14),
(61, 1),
(61, 2),
(61, 3),
(61, 4),
(61, 5),
(61, 6),
(61, 7),
(61, 8),
(61, 9),
(61, 10),
(61, 11),
(61, 12),
(61, 13),
(61, 14),
(62, 1),
(62, 2),
(62, 3),
(62, 4),
(62, 5),
(62, 6),
(62, 7),
(62, 8),
(62, 9),
(62, 10),
(62, 11),
(62, 12),
(62, 13),
(62, 14),
(63, 1),
(63, 2),
(63, 3),
(63, 4),
(63, 5),
(63, 6),
(63, 7),
(63, 8),
(63, 9),
(63, 10),
(63, 11),
(63, 12),
(63, 13),
(63, 14),
(64, 1),
(64, 2),
(64, 3),
(64, 4),
(64, 5),
(64, 6),
(64, 7),
(64, 8),
(64, 9),
(64, 10),
(64, 11),
(64, 12),
(64, 13),
(64, 14),
(65, 1),
(65, 2),
(65, 3),
(65, 4),
(65, 5),
(65, 6),
(65, 7),
(65, 8),
(65, 9),
(65, 10),
(65, 11),
(65, 12),
(65, 13),
(65, 14),
(66, 1),
(66, 2),
(66, 3),
(66, 4),
(66, 5),
(66, 6),
(66, 7),
(66, 8),
(66, 9),
(66, 10),
(66, 11),
(66, 12),
(66, 13),
(66, 14),
(67, 1),
(67, 2),
(67, 3),
(67, 4),
(67, 5),
(67, 6),
(67, 7),
(67, 8),
(67, 9),
(67, 10),
(67, 11),
(67, 12),
(67, 13),
(67, 14),
(68, 1),
(68, 2),
(68, 3),
(68, 4),
(68, 5),
(68, 6),
(68, 7),
(68, 8),
(68, 9),
(68, 10),
(68, 11),
(68, 12),
(68, 13),
(68, 14),
(69, 1),
(69, 2),
(69, 3),
(69, 4),
(69, 5),
(69, 6),
(69, 7),
(69, 8),
(69, 9),
(69, 10),
(69, 11),
(69, 12),
(69, 13),
(69, 14),
(70, 1),
(70, 2),
(70, 3),
(70, 4),
(70, 5),
(70, 6),
(70, 7),
(70, 8),
(70, 9),
(70, 10),
(70, 11),
(70, 12),
(70, 13),
(70, 14),
(71, 1),
(71, 2),
(71, 3),
(71, 4),
(71, 5),
(71, 6),
(71, 7),
(71, 8),
(71, 9),
(71, 10),
(71, 11),
(71, 12),
(71, 13),
(71, 14),
(72, 1),
(72, 2),
(72, 3),
(72, 4),
(72, 5),
(72, 6),
(72, 7),
(72, 8),
(72, 9),
(72, 10),
(72, 11),
(72, 12),
(72, 13),
(72, 14),
(73, 1),
(73, 2),
(73, 3),
(73, 4),
(73, 5),
(73, 6),
(73, 7),
(73, 8),
(73, 9),
(73, 10),
(73, 11),
(73, 12),
(73, 13),
(73, 14),
(74, 1),
(74, 2),
(74, 3),
(74, 4),
(74, 5),
(74, 6),
(74, 7),
(74, 8),
(74, 9),
(74, 10),
(74, 11),
(74, 12),
(74, 13),
(74, 14),
(75, 1),
(75, 2),
(75, 3),
(75, 4),
(75, 5),
(75, 6),
(75, 7),
(75, 8),
(75, 9),
(75, 10),
(75, 11),
(75, 12),
(75, 13),
(75, 14),
(76, 1),
(76, 2),
(76, 3),
(76, 4),
(76, 5),
(76, 6),
(76, 7),
(76, 8),
(76, 9),
(76, 10),
(76, 11),
(76, 12),
(76, 13),
(76, 14),
(77, 1),
(77, 2),
(77, 3),
(77, 4),
(77, 5),
(77, 6),
(77, 7),
(77, 8),
(77, 9),
(77, 10),
(77, 11),
(77, 12),
(77, 13),
(77, 14),
(78, 1),
(78, 2),
(78, 3),
(78, 4),
(78, 5),
(78, 6),
(78, 7),
(78, 8),
(78, 9),
(78, 10),
(78, 11),
(78, 12),
(78, 13),
(78, 14),
(79, 1),
(79, 2),
(79, 3),
(79, 4),
(79, 5),
(79, 6),
(79, 7),
(79, 8),
(79, 9),
(79, 10),
(79, 11),
(79, 12),
(79, 13),
(79, 14),
(80, 1),
(80, 2),
(80, 3),
(80, 4),
(80, 5),
(80, 6),
(80, 7),
(80, 8),
(80, 9),
(80, 10),
(80, 11),
(80, 12),
(80, 13),
(80, 14),
(81, 1),
(81, 2),
(81, 3),
(81, 4),
(81, 5),
(81, 6),
(81, 7),
(81, 8),
(81, 9),
(81, 10),
(81, 11),
(81, 12),
(81, 13),
(81, 14),
(82, 1),
(82, 2),
(82, 3),
(82, 4),
(82, 5),
(82, 6),
(82, 7),
(82, 8),
(82, 9),
(82, 10),
(82, 11),
(82, 12),
(82, 13),
(82, 14),
(83, 1),
(83, 2),
(83, 3),
(83, 4),
(83, 5),
(83, 6),
(83, 7),
(83, 8),
(83, 9),
(83, 10),
(83, 11),
(83, 12),
(83, 13),
(83, 14),
(84, 1),
(84, 2),
(84, 3),
(84, 4),
(84, 5),
(84, 6),
(84, 7),
(84, 8),
(84, 9),
(84, 10),
(84, 11),
(84, 12),
(84, 13),
(84, 14),
(85, 1),
(85, 2),
(85, 3),
(85, 4),
(85, 5),
(85, 6),
(85, 7),
(85, 8),
(85, 9),
(85, 10),
(85, 11),
(85, 12),
(85, 13),
(85, 14),
(86, 1),
(86, 2),
(86, 3),
(86, 4),
(86, 5),
(86, 6),
(86, 7),
(86, 8),
(86, 9),
(86, 10),
(86, 11),
(86, 12),
(86, 13),
(86, 14),
(87, 1),
(87, 2),
(87, 3),
(87, 4),
(87, 5),
(87, 6),
(87, 7),
(87, 8),
(87, 9),
(87, 10),
(87, 11),
(87, 12),
(87, 13),
(87, 14),
(88, 1),
(88, 2),
(88, 3),
(88, 4),
(88, 5),
(88, 6),
(88, 7),
(88, 8),
(88, 9),
(88, 10),
(88, 11),
(88, 12),
(88, 13),
(88, 14),
(89, 1),
(89, 2),
(89, 3),
(89, 4),
(89, 5),
(89, 6),
(89, 7),
(89, 8),
(89, 9),
(89, 10),
(89, 11),
(89, 12),
(89, 13),
(89, 14),
(90, 1),
(90, 2),
(90, 3),
(90, 4),
(90, 5),
(90, 6),
(90, 7),
(90, 8),
(90, 9),
(90, 10),
(90, 11),
(90, 12),
(90, 13),
(90, 14),
(91, 1),
(91, 2),
(91, 3),
(91, 4),
(91, 5),
(91, 6),
(91, 7),
(91, 8),
(91, 9),
(91, 10),
(91, 11),
(91, 12),
(91, 13),
(91, 14),
(92, 1),
(92, 2),
(92, 3),
(92, 4),
(92, 5),
(92, 6),
(92, 7),
(92, 8),
(92, 9),
(92, 10),
(92, 11),
(92, 12),
(92, 13),
(92, 14),
(93, 1),
(93, 2),
(93, 3),
(93, 4),
(93, 5),
(93, 6),
(93, 7),
(93, 8),
(93, 9),
(93, 10),
(93, 11),
(93, 12),
(93, 13),
(93, 14),
(94, 1),
(94, 2),
(94, 3),
(94, 4),
(94, 5),
(94, 6),
(94, 7),
(94, 8),
(94, 9),
(94, 10),
(94, 11),
(94, 12),
(94, 13),
(94, 14),
(95, 1),
(95, 2),
(95, 3),
(95, 4),
(95, 5),
(95, 6),
(95, 7),
(95, 8),
(95, 9),
(95, 10),
(95, 11),
(95, 12),
(95, 13),
(95, 14),
(96, 1),
(96, 2),
(96, 3),
(96, 4),
(96, 5),
(96, 6),
(96, 7),
(96, 8),
(96, 9),
(96, 10),
(96, 11),
(96, 12),
(96, 13),
(96, 14),
(97, 1),
(97, 2),
(97, 3),
(97, 4),
(97, 5),
(97, 6),
(97, 7),
(97, 8),
(97, 9),
(97, 10),
(97, 11),
(97, 12),
(97, 13),
(97, 14),
(98, 1),
(98, 2),
(98, 3),
(98, 4),
(98, 5),
(98, 6),
(98, 7),
(98, 8),
(98, 9),
(98, 10),
(98, 11),
(98, 12),
(98, 13),
(98, 14),
(99, 1),
(99, 2),
(99, 3),
(99, 4),
(99, 5),
(99, 6),
(99, 7),
(99, 8),
(99, 9),
(99, 10),
(99, 11),
(99, 12),
(99, 13),
(99, 14),
(100, 1),
(100, 2),
(100, 3),
(100, 4),
(100, 5),
(100, 6),
(100, 7),
(100, 8),
(100, 9),
(100, 10),
(100, 11),
(100, 12),
(100, 13),
(100, 14),
(101, 1),
(101, 2),
(101, 3),
(101, 4),
(101, 5),
(101, 6),
(101, 7),
(101, 8),
(101, 9),
(101, 10),
(101, 11),
(101, 12),
(101, 13),
(101, 14);

-- --------------------------------------------------------

--
-- Table structure for table `product_category`
--

CREATE TABLE `product_category` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product_category`
--

INSERT INTO `product_category` (`product_id`, `category_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(15, 1),
(16, 1),
(17, 1),
(18, 1),
(19, 2),
(20, 2),
(21, 2),
(22, 2),
(23, 2),
(24, 2),
(25, 2),
(26, 2),
(27, 2),
(28, 2),
(29, 3),
(30, 3),
(31, 3),
(32, 3),
(33, 3),
(34, 3),
(35, 3),
(36, 4),
(37, 4),
(38, 4),
(39, 4),
(40, 4),
(41, 4),
(42, 4),
(43, 4),
(44, 4),
(45, 4),
(46, 4),
(47, 4),
(48, 4),
(49, 4),
(50, 4),
(51, 4),
(52, 4),
(53, 4),
(54, 4),
(55, 4),
(56, 4),
(57, 4),
(58, 4),
(59, 4),
(60, 4),
(61, 4),
(62, 4),
(63, 4),
(64, 4),
(65, 5),
(66, 5),
(67, 5),
(68, 5),
(69, 5),
(70, 5),
(71, 5),
(72, 5),
(73, 5),
(74, 5),
(75, 5),
(76, 5),
(77, 5),
(78, 5),
(79, 5),
(80, 6),
(81, 4),
(81, 6),
(82, 6),
(83, 6),
(84, 6),
(85, 6),
(86, 6),
(87, 6),
(88, 6),
(89, 6),
(90, 6),
(91, 6),
(92, 6),
(93, 6),
(94, 6),
(95, 6),
(96, 7),
(97, 4),
(97, 7),
(98, 4),
(98, 7),
(99, 7),
(100, 7),
(101, 7);

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `review_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `review` text NOT NULL,
  `rating` smallint(6) NOT NULL,
  `created_on` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `shipping`
--

CREATE TABLE `shipping` (
  `shipping_id` int(11) NOT NULL,
  `shipping_type` varchar(100) NOT NULL,
  `shipping_cost` decimal(10,2) NOT NULL,
  `shipping_region_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shipping`
--

INSERT INTO `shipping` (`shipping_id`, `shipping_type`, `shipping_cost`, `shipping_region_id`) VALUES
(1, 'Next Day Delivery ($20)', '20.00', 2),
(2, '3-4 Days ($10)', '10.00', 2),
(3, '7 Days ($5)', '5.00', 2),
(4, 'By air (7 days, $25)', '25.00', 3),
(5, 'By sea (28 days, $10)', '10.00', 3),
(6, 'By air (10 days, $35)', '35.00', 4),
(7, 'By sea (28 days, $30)', '30.00', 4);

-- --------------------------------------------------------

--
-- Table structure for table `shipping_region`
--

CREATE TABLE `shipping_region` (
  `shipping_region_id` int(11) NOT NULL,
  `shipping_region` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shipping_region`
--

INSERT INTO `shipping_region` (`shipping_region_id`, `shipping_region`) VALUES
(1, 'Please Select'),
(2, 'US / Canada'),
(3, 'Europe'),
(4, 'Rest of World');

-- --------------------------------------------------------

--
-- Table structure for table `shopping_cart`
--

CREATE TABLE `shopping_cart` (
  `item_id` int(11) NOT NULL,
  `cart_id` char(32) NOT NULL,
  `product_id` int(11) NOT NULL,
  `attributes` varchar(1000) NOT NULL,
  `quantity` int(11) NOT NULL,
  `buy_now` tinyint(1) NOT NULL DEFAULT '1',
  `added_on` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shopping_cart`
--

INSERT INTO `shopping_cart` (`item_id`, `cart_id`, `product_id`, `attributes`, `quantity`, `buy_now`, `added_on`) VALUES
(1, '1', 1, '2', 1, 2, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `tax`
--

CREATE TABLE `tax` (
  `tax_id` int(11) NOT NULL,
  `tax_type` varchar(100) NOT NULL,
  `tax_percentage` decimal(10,2) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tax`
--

INSERT INTO `tax` (`tax_id`, `tax_type`, `tax_percentage`) VALUES
(1, 'Sales Tax at 8.5%', '8.50'),
(2, 'No Tax', '0.00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attribute`
--
ALTER TABLE `attribute`
  ADD PRIMARY KEY (`attribute_id`);

--
-- Indexes for table `attribute_value`
--
ALTER TABLE `attribute_value`
  ADD PRIMARY KEY (`attribute_value_id`),
  ADD KEY `idx_attribute_value_attribute_id` (`attribute_id`);

--
-- Indexes for table `audit`
--
ALTER TABLE `audit`
  ADD PRIMARY KEY (`audit_id`),
  ADD KEY `idx_audit_order_id` (`order_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`),
  ADD KEY `idx_category_department_id` (`department_id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `idx_customer_email` (`email`),
  ADD KEY `idx_customer_shipping_region_id` (`shipping_region_id`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`department_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `idx_orders_customer_id` (`customer_id`),
  ADD KEY `idx_orders_shipping_id` (`shipping_id`),
  ADD KEY `idx_orders_tax_id` (`tax_id`);

--
-- Indexes for table `order_detail`
--
ALTER TABLE `order_detail`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `idx_order_detail_order_id` (`order_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);
ALTER TABLE `product` ADD FULLTEXT KEY `idx_ft_product_name_description` (`name`,`description`);

--
-- Indexes for table `product_attribute`
--
ALTER TABLE `product_attribute`
  ADD PRIMARY KEY (`product_id`,`attribute_value_id`);

--
-- Indexes for table `product_category`
--
ALTER TABLE `product_category`
  ADD PRIMARY KEY (`product_id`,`category_id`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `idx_review_customer_id` (`customer_id`),
  ADD KEY `idx_review_product_id` (`product_id`);

--
-- Indexes for table `shipping`
--
ALTER TABLE `shipping`
  ADD PRIMARY KEY (`shipping_id`),
  ADD KEY `idx_shipping_shipping_region_id` (`shipping_region_id`);

--
-- Indexes for table `shipping_region`
--
ALTER TABLE `shipping_region`
  ADD PRIMARY KEY (`shipping_region_id`);

--
-- Indexes for table `shopping_cart`
--
ALTER TABLE `shopping_cart`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `idx_shopping_cart_cart_id` (`cart_id`);

--
-- Indexes for table `tax`
--
ALTER TABLE `tax`
  ADD PRIMARY KEY (`tax_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attribute`
--
ALTER TABLE `attribute`
  MODIFY `attribute_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `attribute_value`
--
ALTER TABLE `attribute_value`
  MODIFY `attribute_value_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `audit`
--
ALTER TABLE `audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `department_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `order_detail`
--
ALTER TABLE `order_detail`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shipping`
--
ALTER TABLE `shipping`
  MODIFY `shipping_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `shipping_region`
--
ALTER TABLE `shipping_region`
  MODIFY `shipping_region_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `shopping_cart`
--
ALTER TABLE `shopping_cart`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `tax`
--
ALTER TABLE `tax`
  MODIFY `tax_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
