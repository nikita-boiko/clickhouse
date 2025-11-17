-- Создаем таблицу из CSV файла
CREATE TABLE Prices
(
    id UInt64,
    State String,
    Commodity String,
    Min_Price Decimal64(2),
    Max_Price Decimal64(2),
    Modal_Price Decimal64(2)
    -- добавьте другие колонки по необходимости
) ENGINE = MergeTree()
PARTITION BY (State) --создаем партиции
ORDER BY (id) -- определяем первичный ключ;

-- Загружаем данные из CSV
INSERT INTO Prices
SELECT 
    rowNumberInAllBlocks() AS id,
    * 
FROM file('2025.csv', CSVWithNames);

SELECT * FROM Prices p 

--Индексы пропуска данных
--minmax индекс  
ALTER TABLE Prices ADD INDEX Max_Price_index Max_Price TYPE minmax GRANULARITY 4;
SELECT * FROM Prices WHERE Max_Price BETWEEN 1000 AND 2000

--bloom_filter для текстовых полей
ALTER TABLE Prices ADD INDEX State_index State TYPE bloom_filter(0.025) GRANULARITY 4;
SELECT * FROM Prices WHERE State = 'Tamil Nadu'

--set индекс для малого числа значений
ALTER TABLE Prices ADD INDEX State_index_set State TYPE set(10) GRANULARITY 2;
SELECT * FROM Prices WHERE State = 'Madhya Pradesh'