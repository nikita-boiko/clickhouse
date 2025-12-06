--создаем таблицу расположения магазинов
CREATE TABLE Markets(
	id UUID DEFAULT generateUUIDv4(), 
	State String,
	District String,
	Market String)
ENGINE = MergeTree
ORDER BY (id) --первыичный ключ

-- Загружаем данные из CSV
INSERT INTO Markets (State, District, Market)
SELECT DISTINCT State, District, Market
FROM file('2025.csv', CSVWithNames);

--создаем список продуктов
CREATE TABLE Products (
	Products_id UUID DEFAULT generateUUIDv4(), 
	Commodity String)
ENGINE = MergeTree
ORDER BY (Products_id) --первичный ключ

INSERT INTO Products (Commodity)
SELECT DISTINCT Commodity
FROM file('2025.csv', CSVWithNames);

--создаем таблицу с ценами
CREATE TABLE Prices (
	Products_id UUID, --внешний ключ
	Arrival_Date Datetime,
	Min_Price Float32,
	Max_Price Float32,
	Modal_Price Float32,
	id UUID) --внешний ключ
ENGINE = MergeTree
ORDER BY (Products_id)

SELECT * From Prices

INSERT INTO Prices (Products_id, id, Arrival_Date, Min_Price, Max_Price, Modal_Price)
SELECT
    p.Products_id,
    m.id,
    c.Arrival_Date,
    c.Min_Price,
    c.Max_Price,
    c.Modal_Price
FROM file(
    '2025.csv', 
    CSVWithNames,
    'State String, District String, Market String, Commodity String, Variety String, Grade String, Arrival_Date Date, Min_Price Float32, Max_Price Float32, Modal_Price Float32, Quantity Int32'
) c
JOIN Markets m ON (c.State = m.State AND c.District = m.District AND c.Market = m.Market)
JOIN Products p ON c.Commodity = p.Commodity;

--создаем материализованное представление 
CREATE MATERIALIZED VIEW clicks_daily_mv
ENGINE =  SummingMergeTree() --специальный движок для агрегации
ORDER BY (day)
POPULATE --ЗАПОЛНЯЕМ СУЩЕСТВУЮЩИМИ ДАННЫМИ 
AS
SELECT 
	toDate(Arrival_Date) AS day,
	avg(Modal_Price) AS avg_price
FROM Prices
GROUP BY day

INSERT INTO Prices (
	Arrival_Date,
    Min_Price,
    Max_Price,
    Modal_Price) 
    VALUES ('2022-01-22', 3500.00, 4000.00, 3750.00)

SELECT * FROM clicks_daily_mv






