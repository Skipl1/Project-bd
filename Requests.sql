-- Этот запрос выводит всех пользователей, у которых в "address" указана Москва
SELECT user_id, name, email
FROM Users
WHERE address ILIKE '%Москва%';

-- Этот запрос выводит количество заказов для каждого пользователя
SELECT u.user_id, u.name, COUNT(o.order_id) AS total_orders
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name;

-- Этот запрос выводит количество единиц товаров по категориям, 
-- но только для тех категорий, по которым суммарно заказано более 2 единиц
SELECT pc.category_name, SUM(oi.quantity) AS total_ordered_items
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id
JOIN ProductCategories pc ON p.category_id = pc.category_id
GROUP BY pc.category_name
HAVING SUM(oi.quantity) > 2;

-- Этот запрос выводит 10 самых последних заказов
SELECT order_id, user_id, order_date, total_amount
FROM Orders
ORDER BY order_date DESC
LIMIT 10;

-- Этот запрос выводит детали по каждому товару в заказах:
-- т.е. название товара, количество и цену на момент покупки
SELECT o.order_id, p.name AS product_name, oi.quantity, oi.price_at_purchase
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Products p ON oi.product_id = p.product_id;

-- Этот запрос выводит список товаров с их категориями
SELECT p.name AS product_name, pc.category_name
FROM Products p
LEFT JOIN ProductCategories pc ON p.category_id = pc.category_id;

-- Этот запрос выводит заказ с самой большой суммой среди всех заказов
SELECT *
FROM Orders
WHERE total_amount = (
    SELECT MAX(total_amount) FROM Orders
);

-- Этот запрос выводит рейтинг пользователей по общей сумме потраченных средств
SELECT user_id, total_amount,
       RANK() OVER (ORDER BY total_amount DESC) AS rank_by_spending
FROM (
    SELECT o.user_id, SUM(o.total_amount) AS total_amount
    FROM Orders o
    GROUP BY o.user_id
) sub;

-- Этот запрос выводит заказы, которые имеют статус "Доставлено" в истории заказов
SELECT o.order_id, o.order_date
FROM Orders o
WHERE EXISTS (
    SELECT 1
    FROM OrderHistory oh
    WHERE oh.order_id = o.order_id
      AND oh.status = 'Доставлено'
);

-- Этот запрос выводит 4 товара, начиная с девятого по счёту
SELECT product_id, name, price
FROM Products
ORDER BY product_id
LIMIT 4 OFFSET 8;


