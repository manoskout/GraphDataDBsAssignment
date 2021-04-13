# GraphDataDBs 


The graph example contains a traditional retail-system with products, orders, customers, suppliers and employes.

<img src="img/graph_ex.png">


# Nodes 

1. `User` : (or customer) Customers who order product from the shop
2. `Order` : Sales order transaction taking place between the customer and the shop
3. `Product` : Product information
4. `Category` : All the products are listing according to their type of usage
5. `Supplier` : Suppliers of the product

Nodes are imported from a specific CSV files for each node. Furthermore, in all CSV files have implemented additional info for each node as 

# Relationships

1. `(:User)-[:MADE]->(:Order)`
2. `(:Order)-[:CONTAINS]->(:Product)`
3. `(:Product)-[:PART_OF]->(:Category)`
4. `(:Product)-[:SUPPLIED]->(:Supplier)`


# Database Import

Using cypher-shell (terminal):

`cat script.cypher| cypher-shell -u <username> -p <password>`

Or run `script.cypher` on neo4j Desktop app. (recommened)


# Examples

You can trigger the script below only when you have successfully implemented the dataset into the neo4j broswer.

1. Get the total ammount of orders:

	`MATCH (o:Order) return count(o)`

<img src="img/1_out.png">

2. Get the total ammount of orders from a specific Customer:

	`MATCH (c:Customer)-[:MADE]->(o:Order) WHERE c.fullName="Panos Markou" RETURN count(o)`

<img src="img/2_out.png">

3. Create a new user named George Michael:

	`CREATE (:Customer {
    address:"Hellinic Street 24",
    city: "Athens",
    customerID: "geoM",
    email: "asdqwe@test.com",
    fullName: "George Michael",
    phone: "12341234",
    postalCode: "19482" })`

<img src="img/3_out.png">

4. Create yet another order na make the relationship with the user:

	`MATCH (c:Customer)
	WHERE c.fullName="George Michael"
	CREATE (:Order {shipCity: "Heraklion",
	quantity: "5",
	productID: "23",
	deliveryMethod: "Shipping",
	orderID: "55",
	discount: "0",
	requiredDate: "2021-08-01",
	shipPostalCode: "12345",
	shipAddress: "Methodiou 12",
	customerID: c.customerID,
	shippedDate: "2021-07-22",
	orderDate: "2021-07-02"})<-[:MADE]-(c)`
<img src="img/4_out.png">

5. Create relationship between a specific Order (orderId=55) and specific product (productID=23)

	`MATCH (o:Order), (p:Product) 
	WHERE o.orderID="55" AND o.productID=p.productID
		CREATE (o)-[:CONTAINS]->(p) 
	RETURN o`
<img src="img/5_out.png">

6. Change the type of the orderID (String to Integer)

	`MATCH (n:Order)
	WHERE toString(n.orderID) = n.orderID
	SET n.orderID = toInteger(n.orderID)`

<img src="img/6_out.png">

7. Find the Customer with up to 3 orders
	
	`MATCH (c:Customer)-[:MADE]->(o:Order)
	WITH c, count(o) as cnt
	RETURN c.fullName as CustomerName, cnt as SumOfOrders
	WHERE cnt<3
	`

<img src="img/7_out.png">

8. Delete all but one of the dublicated customers in our graph (i.e we have accidentaly created 2 more users with the same properties)
	
	`MATCH (c:Customer)
WITH c.customerID AS c_id, COLLECT(c) AS customers
WHERE SIZE(customers) > 1
FOREACH (n IN TAIL(customers) | DETACH DELETE n);`

<img src="img/8_out.png">

# Homework 1 Scripting for practising

According to the dataset you have, find and execute the queries below

1. Find customers who have purchased a product twice.
2. In node Orders there are three dates properties (requiredDate, orderDate, shippedDate). Those dates are string type, change the type of these values to DATE
3. When you make this change, find the orders that have been placed on the date ("08-07-2021"). 
4. There is a mistake in our graph, Apple Macbook Pro is in the smartphone category, move this product to the Laptops category

# Homework 2 Graph Design

We have a **"mini"** social net graph. You should design the graph according to the data below.

1. Create a node Users (You should import the username as a constraint)
	
| username      | firstName     | lastName      | sex           | city          | nationality   |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| manosk        | Manos         | Koutoulakis   | male          | Heraklion     | Greece        |
| georget       | George        | Testakis      | male          | Heraklion     | Greece        |

2. Create the FRIENDSHIP of Manos and George, since date("02-05-2019")
3. Create the nodes Message which are connected with the users (MessageOwner and MessageID are unique constraints)

| messageOwner  | messageID     | messageContent                                | date             | 
| ------------- | ------------- | --------------------------------------------- | ---------------- | 
| manosk        | 1             | Please prepare the lab computers              | 03/03/2021 13:00 |
| georget       | 1             | Any problems should be sent to me by email    | 03/03/2021 13:01 |
| georget       | 2             | Students should use code 1234 to access neo4j | 03/03/2021 13:05 |

4. Create the nodes Comments 

| commentOwner  | commentID     | messageID     | messageOwner  | commentContent                                                                   | date             |
| ------------- | ------------- | ------------- | ------------- | -------------------------------------------------------------------------------- | ---------------- |
| georget       | 1             | 1             | manosk        | I have already installed neo4j on all computers.                                 | 03/03/2021 18:10 |
| manosk        | 2             | 1             | manosk        | Fine, I hope everything goes well this semester.                                 | 03/03/2021 18:10 |
| georget       | 1             | 2             | georget       | Update, password for login to Neo4j has changed. Use 4321 to access the database | 03/03/2021 18:10 |

5. Set likes as relationships between User and Message

| user          | messageOwner  | messageID     |  
| ------------- | ------------- | ------------- |  
| georget       | manosk        | 1             | 
| manosk        | manosk        | 1             |  
| georget       | manosk        | 2             |  




## Possible problems you will encounter

In case that you have problems with the indexes that have not removed after a graph cleaning you sould use the following script:

`DROP CONSTRAINT
ON (n:Order)
ASSERT n.orderID IS UNIQUE`

`DROP INDEX ON :Customer(customerID)`

`DROP INDEX ON :Category(categoryID)`

`DROP INDEX ON :Supplier(supplierID)`

`DROP INDEX ON :Product(productName)` 

Questions? [Please do not hesitate to ask me any question you have ( manoskoutoulak@gmai.com )]






 
