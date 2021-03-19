// Create orders
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/manoskout/GraphDataDBsAssignment/main/orders.csv' AS row
MERGE (order:Order {orderID: row.OrderID})
  	ON CREATE SET order.customerID= row.CustomerID,
		order.orderDate= row.OrderDate,
		order.requiredDate= row.RequiredDate,
		order.shippedDate= row.ShippedDate,
		order.deliveryMethod= row.DeliveryMethod,
		order.shipAddress= row.ShipAddress,
		order.shipCity= row.ShipCity,
		order.shipPostalCode= row.ShipPostalCode,
		order.productID= row.ProductID,
		order.quantity= row.Quantity,
		order.discount= row.Discountl;
 
// Create products
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/manoskout/GraphDataDBsAssignment/main/products.csv' AS row
MERGE (product:Product {productID: row.ProductID})
  	ON CREATE SET product.productName = row.ProductName, 
	  	product.unitPrice = toFloat(row.Price), 
	  	product.categoryID=row.CategoryID, 
	  	product.supplierID=row.SupplierID,
	  	product.unitsInStock= row.UnitsInStock,
	  	product.unitsInOrder= row.UnitsOnOrder;

 // Create suppliers
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/manoskout/GraphDataDBsAssignment/main/suppliers.csv' AS row
MERGE (supplier:Supplier {supplierID: row.SupplierID})
	ON CREATE SET supplier.companyName = row.CompanyName,
  		supplier.address = row.Address,
  		supplier.city = row.City,
  		supplier.postalCode = row.PostalCode,
  		supplier.phone = row.Phone;


// Create categories
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/manoskout/GraphDataDBsAssignment/main/categories.csv' AS row
MERGE (category:Category {categoryID: row.CategoryID})
  	ON CREATE SET category.categoryName = row.CategoryName, 
  		category.description = row.Description;

// Create Customers
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/manoskout/GraphDataDBsAssignment/main/customers.csv' AS row
MERGE (customer:Customer {customerID: row.CustomerID})
  	ON CREATE SET customer.fullName = row.FullName,
	  	customer.address = row.Address,
	  	customer.city = row.City,
	  	customer.postalCode = row.PostalCode,
	  	customer.phone = row.Phone,
	  	customer.email = row.Email;

// Relationships between nodes
// We will create indexes for any nodes according to their unique value (in our occasion we use their IDs)
// This process is important to ensure the lookup of nodes is optimized
// Creation of constraints
//CREATE INDEX product_id FOR (p:Product) ON (p.productID);
//CREATE INDEX product_name FOR (p:Product) ON (p.productName);
//CREATE INDEX supplier_id FOR (s:Supplier) ON (s.supplierID);
//CREATE INDEX customer_id FOR (c:Customer) ON (c.customerID);
//CREATE INDEX category_id FOR (ca:Category) ON (ca.categoryID);
// We disallow orders with the same id from getting created using UNIQUE command
//CREATE CONSTRAINT order_id ON (o:Order) ASSERT o.orderID IS UNIQUE;
// The index insertion happens asychronously, thus the next command is used to block until they are populated
//CALL db.awaitIndexes(); 

// Create relationships between orders and products
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/manoskout/GraphDataDBsAssignment/main/orders.csv' AS row
MATCH (order:Order {orderID: row.OrderID})
MATCH (product:Product {productID: row.ProductID})
MERGE (order)-[op:CONTAINS]->(product)
  	ON CREATE SET op.unitPrice = toFloat(row.UnitPrice), 
  		op.quantity = toFloat(row.Quantity);

// Create relationships between orders and customer
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/manoskout/GraphDataDBsAssignment/main/orders.csv' AS row
MATCH (order:Order {orderID: row.OrderID})
MATCH (customer:Customer {customerID: row.CustomerID})
MERGE (customer)-[op:MADE]->(order);

// Create relationships between products and suppliers
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/manoskout/GraphDataDBsAssignment/main/products.csv' AS row
MATCH (product:Product {productID: row.ProductID})
MATCH (supplier:Supplier {supplierID: row.SupplierID})
MERGE (supplier)-[:SUPPLIES]->(product);

// Create relationships between products and categories
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/manoskout/GraphDataDBsAssignment/main/products.csv' AS row
MATCH (product:Product {productID: row.ProductID})
MATCH (category:Category {categoryID: row.CategoryID})
MERGE (product)-[:PART_OF]->(category);