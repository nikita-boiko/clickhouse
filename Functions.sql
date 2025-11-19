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

-- Загружаем данные из CSV
INSERT INTO Prices
SELECT 
    rowNumberInAllBlocks() AS id,
    * 
FROM file('2025.csv', CSVWithNames);

SELECT * FROM Prices p 

SELECT 
	count(*),
	sum(Modal_Price),
	avg(Modal_Price),
	countIf(Modal_Price > 5000)
FROM
	Prices p 