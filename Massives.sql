--создаем таблицу 
CREATE TABLE taxi (
	order_id Int32,
	phones Array(String), -- Массив
	num_car Array(String),
	order_start Datetime,
	order_end Datetime,
	price_order Array(Int32)
) ENGINE = MergeTree()
ORDER BY order_id

--вносим данные
INSERT INTO taxi (order_id, phones, num_car, order_start, order_end, price_order)
VALUES 
(1,
['+79684327418', '+79684327457'],
['A380TC', 'B324OT'],
'2025-10-25 14:30:56',
'2025-10-25 14:42:38',
['143', '25'])

SELECT * FROM taxi

--добавляем столбец с типом period
ALTER TABLE taxi ADD COLUMN order_time Int32 DEFAULT dateDiff('minute', order_start, order_end)

SELECT * FROM taxi


	