DROP TABLE IF EXISTS raw_data;

CREATE TABLE raw_data ( 
    invoice_no VARCHAR(10),	
    stock_code VARCHAR(20),
    description text,	
    quantity int,	
    invoice_date timestamp,
    price numeric(10,2),
    customer_id float,
    country VARCHAR(50)
);
