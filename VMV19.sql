/*
ФИО: Власюк Максим Владимирович
Вариант 19
Описание предметной области
Описание таксопарка. Включает в себя: автомобили, водителей, тарифы, заказы, информацию об оплате. Описания автомобилей состоят из: марки, класса (бизнес, эконом), госномера автомобиля, цвета, года выпуска. Водитель описывается: фамилией, именем, отчеством, датой рождения, ИНН, серией и номером паспорта. Описания тарифов состоят из: названия, указания времени суток (день/ночь), указания дальности поездки с точки зрения удалённости от центра Москвы (в пределах МКАД, за МКАД, Подмосковье), цена за километр пути. Заказы описываются: датой, временем, адресом подачи такси, предположительным адресом следования такси, количеством пассажиров, ориентировочной длиной маршрута. Информация об оплате состоит из указания заказа, указания тарифа, километража, стоимости. 
В одном заказе тарифы могут комбинироваться (в этом случае, для каждого тарифа собственная информация об оплате). Каждый водитель на все заказы ездит на одной и той же машине, но у разных водителей машины могут быть разными.
*/


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
