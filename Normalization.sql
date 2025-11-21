CREATE TABLE Markets(
	id UUID DEFAULT generateUUIDv4(), 
	State String,
	District String,
	Market String)
ENGINE = MergeTree
ORDER BY (id)

-- Загружаем данные из CSV
INSERT INTO Markets (State, District, Market)
SELECT DISTINCT State, District, Market
FROM file('2025.csv', CSVWithNames);

CREATE TABLE Products (
	Products_id UUID DEFAULT generateUUIDv4(), 
	Commodity String)
ENGINE = MergeTree
ORDER BY (Products_id)

INSERT INTO Products (Commodity)
SELECT DISTINCT Commodity
FROM file('2025.csv', CSVWithNames);

CREATE TABLE Prices (
	Products_id UUID, 
	Arrival_Date Datetime,
	Min_Price Float32,
	Max_Price Float32,
	Modal_Price Float32,
	id UUID)
ENGINE = MergeTree
ORDER BY (Products_id)

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




