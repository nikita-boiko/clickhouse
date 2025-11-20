-- Создаем таблицу из CSV файла
CREATE TABLE Prices
(
    id UInt64,
    Commodity String,
    Min_Price Decimal64(2),
    Max_Price Decimal64(2),
    Modal_Price Decimal64(2)
) ENGINE = MergeTree()
ORDER BY (id);

--Добавляем столбец с датами
ALTER TABLE Prices ADD COLUMN Arrival_Date Date

-- Загружаем данные из CSV
INSERT INTO Prices
SELECT 
    rowNumberInAllBlocks() AS id,
    * 
FROM file('2025.csv', CSVWithNames);

SELECT * FROM Prices p 

--Текущее время
SELECT now(), today(), yesterday()

--Форматирование времени
SELECT formatDateTime(now(), '%Y-%m-%d %H:%i:%S')

--Извлечение компонентов времени 
SELECT 
 	toYear(now()) as year,
    toMonth(now()) as month,
    toDayOfMonth(now()) as day,
    toHour(now()) as hour
    
--Группировка по временным интервалам 
SELECT
	toStartOfMonth(Arrival_Date) as Month_start,
	count(Commodity) as events,
	avg(Modal_Price) as Avg_price
FROM Prices
GROUP BY Month_start
ORDER BY Month_start

    
    