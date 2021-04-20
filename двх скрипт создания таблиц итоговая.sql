create database dwh_dz;

create schema bookings_dwh_dz;

create table Dim_Calendar 
as
with dates as (
	select dd::date as dt
	from generate_series 
		('2010-01-01' :: timestamp,
		'2030-01-01' :: timestamp,
		'1 day' :: interval) dd
		)
select
	to_char (dt, 'YYYYMMDD'):: int as id,
	dt as date,
	to_char (dt, 'YYYY-MM-DD') as ansi_date,
	date_part ('isodow', dt) :: int as day,
	date_part ('week', dt) :: int as week_number,
	date_part ('month', dt) :: int as month,
	date_part ('isoyear', dt) :: int as year
from dates 
order by dt;

alter table Dim_Calendar add primary key (id);

create table Dim_Passengers(
passenger_id varchar (20) not null,
passenger_name text not null,
phone text,
email text,
primary key (passenger_id)
);

create table Dim_Aircrafts(
aircraft_code char (3) not null,
model_ru text not null,
model_en text not null,
"range" int not null,
primary key (aircraft_code)
);

create table Dim_Airports(
airport_code char (3) not null,
airport_name_ru text not null,
airport_name_en text not null,
city_ru text not null,
city_en text not null,
coordinates text not null,
timezone text not null,
primary key (airport_code)
);

create table Dim_Tariff(
id serial,
fare_conditions varchar (10) not null,
primary key (id) 
);



create table Fact_Flights(
id serial8 not null,
flight_id int not null,
passenger_key varchar (20) not null references Dim_Passengers (passenger_id),
scheduled_departure int not null references Dim_Calendar (id),
scheduled_arrival int not null references Dim_Calendar (id),
actual_departure_sec int,
actual_arrival_sec int,
aircraft_key char (3) not null references Dim_Aircrafts (aircraft_code),
departure_airport_key char (3) not null references Dim_Airports (airport_code),
arrival_airport_key char (3) not null references Dim_Airports (airport_code),
tarif_key int not null references Dim_Tariff (id),
amount bigint not null,
primary key (id)
);





create table rejected_dim_passengers(
passenger_id text,
passenger_name text,
phone text,
email text
);


create table rejected_dim_aircrafts(
aircraft_code text,
model_ru text,
model_en text,
"range" int
);


create table rejected_dim_airports(
airport_code text,
airport_name_ru text,
airport_name_en text,
city_ru text,
city_en text,
coordinates text,
timezone text
);


create table rejected_dim_tariff(
id serial,
fare_conditions text
);


create table rejected_fact_flights(
id serial8 not null,
flight_id text,
passenger_key text,
scheduled_departure text,
scheduled_arrival text,
actual_departure_sec text,
actual_arrival_sec text,
aircraft_key text,
departure_airport_key text,
arrival_airport_key text,
tarif_key text,
amount text
);
















