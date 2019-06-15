# Ecommerce API  🛍 🛒 

Standard scalable E-commerce API built with Node.js. Users can search items, add items to their shopping cart, create orders, and checkout successfully.

## 📖 Getting started

1. Clone this repository into your local machine:
```
git clone https://github.com/SirPhemmiey/ecommerce-api.git
```
2. Install dependencies by running
```
yarn
```
3. Rename the .env.example file to .env and add your configuration details

4. Start your the project on your machine by running
```
yarn start
```
5. You can test the endpoints by checking out this documentation: https://documenter.getpostman.com/view/3567325/S1Zw8AzK?version=latest

6. Checkout the live api here: https://explorer-ecommerce-api.herokuapp.com/

7. To test the code run the jest command
```
jest
```


# System Architecture  🏢
![Overview of Ecommerce Architecture](https://github.com/mayorcoded/ecommerce-api/blob/master/architecture.jpg)

The system design is rather straighforward from the architecture diagram above. API reuqests made from various clients hits the Express controller. A middleware first checks if the same request has been cached and returns the response from the cache. However, if the request has not been cached or cleared from the cache, the controller calls the right service to handle the request and returns the result back to the controller which then sends a response to the clients. In some cases, a service may fire an event which would kick off a background job. These jobs are added to a job queue and a worker picks each job from the queue and executes them. When a worker is done with a jobs, an event is fired which triggers the right service for corresponding action. Logging is a cross-cutting concern in the application and it is done appropriately. 

# Project Features 📸

Here are some of the pictures of the ecommerce API

➠ Users can view all items when by calling the APIs

➠ Items are displayed properly based on the selected department and category

➠ Users can search items through search query with pagination support

➠ Users can see item details by requesting a specific item details

➠ Users can add items to their shopping carts

➠ Users can register/login using api custom forms, or social login libraries

➠ Users can update personal profiles with shipping addresses and other info using the APIs

➠ Users can checkout with payment gateway: Stripe. 

➠ Users will get confirmations over emails about their orders

➠ Clear unused shopping cart frequently

# Technologies Used 🖥 📲

- **Framework and Programming language**
        
    - JavaScript, ES6.
    - Node.js, Express Framework.

- **Database and Database client**

    - MySql Database.
    - Promise-MySql, MySql client.

- **Apllication Performacnce Montitor**
    
    - New Relic APM.

- **Logging**

    - Winston, logging library.

- **Secure Http Headers**

    - Helmet, secure http header library.

- **Rate Limting**

    - Express Rate Limit library.

- **Caching**

    - Redis
    - Flat-cache library

- **Background Jobs, Queuing and Scheduling**

    - Bull, redis-based queuing libary.
    - Node Schedule library

- **Testing**

    - Test with **Jest**, leave the rest.

## Author
* **Mayowa Tudonu @mayorcoded**

## License 
This project is licensed under the MIT License

## Acknowledgements
* Hats off to all the technologies I used and all the artciles I read.
