# GraphDataDBs 

<br />
The graph example contains a traditional retail-system with products, orders, customers, suppliers and employes.

<img src="img/graph_ex.png">

<br />

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

<br />

# Database Import

Using cypher-shell (terminal):

`cat script.cypher| cypher-shell -u <username> -p <password>`

Or run script.cypher on neo4j Desktop app.


# Examples

1. Get the total ammount of orders:

		`MATCH (o:Orders) return count(o)`

# Queries for testin

1. Get all users who have ordered Arduino Nano
	

## Problems

In case that you have problems with the indexes that have not removed after a graph cleaning you sould use the followin script:

`DROP CONSTRAINT
ON (n:Order)
ASSERT n.orderID IS UNIQUE`

`DROP INDEX ON :Customer(customerID)`

`DROP INDEX ON :Category(categoryID)`

`DROP INDEX ON :Supplier(supplierID)`

`DROP INDEX ON :Product(productID)` 

Questions? [Please do not hesitate to ask me ( manoskoutoulak@gmai.com )]






 