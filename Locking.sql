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

SELECT * FROM Prices p 

--блокировка таблиц
--блокировка для DDL операций
ALTER TABLE Prices UPDATE Commodity = 'Carrot' WHERE Min_Price = 800;

--блокировки запросов
SELECT * FROM Prices p  

INSERT INTO Prices(Commodity, Min_Price, Max_Price, Modal_Price) 
VALUES ('Apple', 2000.00, 3000.00, 2500.00)

--системные блокировки 
--блокировка таблицы для обслуживания 
SYSTEM STOP MERGES Prices;
SYSTEM START MERGES Prices;

--блокировка репликации
SYSTEM STOP FETCHES Prices;
SYSTEM START FETCHES Prices;

--блокировка отправки данных
SYSTEM STOP REPLICATED SENDS;
SYSTEM START REPLICATED SENDS;

--блокировки транзакций
BEGIN TRANSACTION;
INSERT INTO Prices(Commodity, Min_Price, Max_Price, Modal_Price) 
VALUES ('Mash', 1000.00, 3000.00, 2000.00);
INSERT INTO Prices(Commodity, Min_Price, Max_Price, Modal_Price) 
VALUES ('Grips', 600.00, 1000.00, 800.00);
COMMIT 


