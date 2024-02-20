/* 
Following Quickstart for dbt Cloud and Snowflake guide located here:
https://docs.getdbt.com/guides/snowflake?step=3
 */

 -- Creating objects to compute and store jaffle shop data
create warehouse transforming;
create database raw;
create database analytics;
create schema raw.jaffle_shop;
create schema raw.stripe;

-- Creating customers table and loading data
create table raw.jaffle_shop.customers 
( id integer,
  first_name varchar,
  last_name varchar
);

-- Loading data from s3 bucket
copy into raw.jaffle_shop.customers (id, first_name, last_name)
from 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

-- Creating orders table and loading data
create table raw.jaffle_shop.orders
( id integer,
  user_id integer,
  order_date date,
  status varchar,
  _etl_loaded_at timestamp default current_timestamp
);

-- Loading data from s3 bucket
copy into raw.jaffle_shop.orders (id, user_id, order_date, status)
from 's3://dbt-tutorial-public/jaffle_shop_orders.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

-- Creating payment table and loading data
create table raw.stripe.payment 
( id integer,
  orderid integer,
  paymentmethod varchar,
  status varchar,
  amount integer,
  created date,
  _batched_at timestamp default current_timestamp
);

-- Loading data from s3 bucket
copy into raw.stripe.payment (id, orderid, paymentmethod, status, amount, created)
from 's3://dbt-tutorial-public/stripe_payments.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

-- Confirming load for all 3 tables
select * from raw.jaffle_shop.customers;
select * from raw.jaffle_shop.orders;
select * from raw.stripe.payment;   