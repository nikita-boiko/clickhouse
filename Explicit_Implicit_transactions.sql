-- Создаем таблицу из CSV файла
CREATE TABLE Prices
(
    id UInt64,
    Commodity String,
    Min_Price Decimal64(2),
    Max_Price Decimal64(2),
    Modal_Price Decimal64(2)
    -- добавьте другие колонки по необходимости
) ENGINE = MergeTree()
ORDER BY (id);

-- Загружаем данные из CSV
INSERT INTO Prices
SELECT 
    rowNumberInAllBlocks() AS id,
    * 
FROM file('2025.csv', CSVWithNames);

--Создаем явную транзакцию
BEGIN TRANSACTION;
UPDATE Prices SET Min_Price = Min_Price + 100 WHERE Commodity = "Potato";
UPDATE Prices SET Max_Price = Max_Price + 100 WHERE Commodity = "Potato";
UPDATE Prices SET Modal_Price = (Max_Price + Min_Price)/2 WHERE Commodity = "Potato";
COMMIT;

--Создаем неявную транзацкию 
ALTER TABLE Prices 
UPDATE  Min_Price = 150, Max_Price = 250, Modal_Price = 200 
WHERE id = 123;
