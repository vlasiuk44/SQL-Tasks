/*
ФИО: Власюк Максим Владимирович
Вариант 19
Описание предметной области
Описание таксопарка. Включает в себя: автомобили, водителей, тарифы, заказы, информацию об оплате. Описания автомобилей состоят из: марки, класса (бизнес, эконом), госномера автомобиля, цвета, года выпуска. Водитель описывается: фамилией, именем, отчеством, датой рождения, ИНН, серией и номером паспорта. Описания тарифов состоят из: названия, указания времени суток (день/ночь), указания дальности поездки с точки зрения удалённости от центра Москвы (в пределах МКАД, за МКАД, Подмосковье), цена за километр пути. Заказы описываются: датой, временем, адресом подачи такси, предположительным адресом следования такси, количеством пассажиров, ориентировочной длиной маршрута. Информация об оплате состоит из указания заказа, указания тарифа, километража, стоимости. 
В одном заказе тарифы могут комбинироваться (в этом случае, для каждого тарифа собственная информация об оплате). Каждый водитель на все заказы ездит на одной и той же машине, но у разных водителей машины могут быть разными.

Task:
Выберите автомобили (все поля таблицы), зарегистрированные в московском регионе.
Выберите для каждого автомобиля (госномер) число заказов, в которых он участвовал, кроме автомобилей с нулевым числом заказов.
*/

-- 1. СОЗДАНИЕ СТРУКТУРЫ БД

CREATE TABLE Cars (
    plate_number VARCHAR(15) PRIMARY KEY,
    brand VARCHAR(100),
    car_class VARCHAR(20) CHECK (car_class IN ('бизнес', 'эконом')),
    color VARCHAR(50),
    year_produced INT CHECK (year_produced > 1900)
);

CREATE TABLE Drivers (
    inn VARCHAR(12) PRIMARY KEY,
    last_name VARCHAR(100),
    first_name VARCHAR(100),
    middle_name VARCHAR(100),
    birth_date DATE,
    passport_series VARCHAR(4),
    passport_number VARCHAR(6),
    car_plate VARCHAR(15),
    FOREIGN KEY (car_plate) REFERENCES Cars(plate_number)
);

CREATE TABLE Tariffs (
    tariff_name VARCHAR(100) PRIMARY KEY,
    time_of_day VARCHAR(10) CHECK (time_of_day IN ('день', 'ночь')),
    zone VARCHAR(50) CHECK (zone IN ('в пределах МКАД', 'за МКАД', 'Подмосковье')),
    price_per_km DECIMAL(10, 2) DEFAULT 0
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE DEFAULT (CURRENT_DATE),
    order_time TIME DEFAULT (CURRENT_TIME),
    pickup_address TEXT,
    destination_address TEXT,
    passenger_count INT DEFAULT 1 CHECK (passenger_count > 0),
    estimated_length DECIMAL(10, 2),
    driver_inn VARCHAR(12),
    FOREIGN KEY (driver_inn) REFERENCES Drivers(inn)
);

CREATE TABLE Order_Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT,
    tariff_name VARCHAR(100),
    distance DECIMAL(10, 2) CHECK (distance >= 0),
    total_cost DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (tariff_name) REFERENCES Tariffs(tariff_name)
);


-- 2. ЗАПОЛНЕНИЕ ДАННЫМИ 

INSERT INTO Cars (plate_number, brand, car_class, color, year_produced) VALUES
('А777АА77', 'Mercedes Benz E-Class', 'бизнес', 'черный', 2022),
('К197ХК197', 'Hyundai Solaris', 'эконом', 'белый', 2020),
('М999ММ99', 'BMW x5', 'бизнес', 'белый', 2021),
('Е555КХ777', 'Kia Rio', 'эконом', 'красный', 2019),
('В123ОР750', 'Skoda Karoq', 'эконом', 'серый', 2021);

INSERT INTO Drivers (inn, last_name, first_name, middle_name, birth_date, passport_series, passport_number, car_plate) VALUES
('770123456789', 'Иванов', 'Сергей', 'Петрович', '1985-05-12', '4510', '123459', 'А777АА77'),
('770987654321', 'Петров', 'Алексей', 'Игоревич', '1990-10-20', '4512', '654321', 'К197ХК197'),
('770111222333', 'Сидоров', 'Дмитрий', 'Олегович', '1982-03-15', '4508', '111223', 'М999ММ99'),
('770444555666', 'Кузнецов', 'Андрей', 'Васильевич', '1988-07-30', '4515', '556444', 'Е555КХ777'),
('500123987456', 'Смирнов', 'Михаил', 'Юрьевич', '1993-12-01', '4610', '987623', 'В123ОР750');

INSERT INTO Tariffs (tariff_name, time_of_day, zone, price_per_km) VALUES
('Эконом День МКАД', 'день', 'в пределах МКАД', 25.00),
('Бизнес День МКАД', 'день', 'в пределах МКАД', 60.00),
('Бизнес Ночь МКАД', 'ночь', 'в пределах МКАД', 80.00),
('Загородный Эконом', 'день', 'за МКАД', 45.00),
('Подмосковье', 'день', 'Подмосковье', 55.00);

INSERT INTO Orders (order_id, order_date, order_time, pickup_address, destination_address, passenger_count, estimated_length, driver_inn) VALUES
(1, '2026-01-10', '10:00:00', 'ул. Тверская, 1', 'Красная Площадь, 3', 1, 3.5, '770123456789'),
(2, '2026-01-10', '11:30:00', 'Аэропорт Шереметьево', 'Отель Метрополь', 2, 32.0, '770123456789'),
(3, '2026-01-11', '23:00:00', 'Пресненская наб., 12', 'ул. Профсоюзная, 45', 1, 15.0, '770987654321'),
(4, '2026-01-12', '09:00:00', 'Арбат, 10', 'Киевский вокзал', 3, 5.0, '770111222333'),
(5, '2026-01-12', '15:00:00', 'Ленинградский пр-т, 39', 'Сколково', 1, 20.0, '770444555666');

INSERT INTO Order_Payments (order_id, tariff_name, distance, total_cost) VALUES
(1, 'Бизнес День МКАД', 3.5, 210.00),
(2, 'Бизнес День МКАД', 32.0, 1920.00),
(3, 'Эконом День МКАД', 15.0, 375.00),
(4, 'Бизнес День МКАД', 5.0, 300.00),
(5, 'Эконом День МКАД', 20.0, 500.00);


-- 3. ВЫБОРКА ДАННЫХ 
-- Автомобили московского региона (77, 99, 197, 777, 797, 799)
SELECT * FROM Cars 
WHERE plate_number LIKE '%77' 
   OR plate_number LIKE '%99' 
   OR plate_number LIKE '%197' 
   OR plate_number LIKE '%777' 
   OR plate_number LIKE '%797' 
   OR plate_number LIKE '%799';

-- Число заказов для каждого автомобиля (кроме автомобилей с нулевым числом заказов)
SELECT 
    c.plate_number, 
    COUNT(o.order_id) AS total_orders
FROM Cars c
JOIN Drivers d ON c.plate_number = d.car_plate
JOIN Orders o ON d.inn = o.driver_inn
GROUP BY c.plate_number
HAVING COUNT(o.order_id) > 0;