-- Görev 3: Northwind çoklu tablo sorguları (data/northwind.db3)

-- Her ürünün adı ve kategorisi (77 satır).
SELECT p.ProductName, c.CategoryName
FROM Product AS p
JOIN Category AS c ON c.Id = p.CategoryId;

-- 9 Ağustos 2012 tarihinden önceki siparişler ve göndericileri (429 satır).
SELECT o.Id, s.CompanyName
FROM "Order" AS o
JOIN Shipper AS s ON s.Id = o.ShipVia
WHERE o.OrderDate < '2012-08-09';

-- 10251 numaralı siparişteki ürün miktarları ve adları (3 satır).
SELECT od.Quantity, p.ProductName
FROM OrderDetail AS od
JOIN Product AS p ON p.Id = od.ProductId
WHERE od.OrderId = 10251
ORDER BY p.ProductName;

-- Her siparişin müşteri şirketi ve görevli çalışanı (16.789 satır).
SELECT o.Id AS OrderId,
       c.CompanyName AS CustomerCompanyName,
       e.LastName AS EmployeeLastName
FROM "Order" AS o
JOIN Customer AS c ON c.Id = o.CustomerId
JOIN Employee AS e ON e.Id = o.EmployeeId;

-- Görev 4: aynı Northwind verileriyle esnek sorgular.

-- Gönderici başına gönderilen sipariş sayısı.
SELECT s.CompanyName AS ShipperName, COUNT(o.Id) AS ShipmentCount
FROM Shipper AS s
LEFT JOIN "Order" AS o ON o.ShipVia = s.Id
GROUP BY s.Id, s.CompanyName
ORDER BY ShipmentCount DESC;

-- Sipariş adedine göre ilk beş çalışan.
SELECT e.Id AS EmployeeId, e.FirstName, e.LastName,
       COUNT(o.Id) AS OrderCount
FROM Employee AS e
JOIN "Order" AS o ON o.EmployeeId = e.Id
GROUP BY e.Id, e.FirstName, e.LastName
ORDER BY OrderCount DESC, e.Id
LIMIT 5;

-- Sipariş kalemlerinin indirim sonrası gelire göre ilk beş çalışanı.
SELECT e.Id AS EmployeeId, e.FirstName, e.LastName,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue
FROM Employee AS e
JOIN "Order" AS o ON o.EmployeeId = e.Id
JOIN OrderDetail AS od ON od.OrderId = o.Id
GROUP BY e.Id, e.FirstName, e.LastName
ORDER BY Revenue DESC, e.Id
LIMIT 5;

-- En az gelir getiren kategori.
SELECT c.CategoryName,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue
FROM Category AS c
JOIN Product AS p ON p.CategoryId = c.Id
JOIN OrderDetail AS od ON od.ProductId = p.Id
GROUP BY c.Id, c.CategoryName
ORDER BY Revenue ASC, c.Id
LIMIT 1;

-- En fazla sipariş veren müşterilerin ülkesi.
SELECT c.Country, COUNT(o.Id) AS OrderCount
FROM Customer AS c
JOIN "Order" AS o ON o.CustomerId = c.Id
GROUP BY c.Country
ORDER BY OrderCount DESC, c.Country
LIMIT 1;
