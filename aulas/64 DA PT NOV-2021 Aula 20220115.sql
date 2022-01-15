-- Exploração inicial das tabelas
SELECT
	*
FROM 
	ironhack.bookings.bookings
LIMIT 50;

SELECT
	*
FROM 
	ironhack.bookings.tickets
LIMIT 50;

SELECT
	*
FROM 
	ironhack.bookings.ticket_flights
LIMIT 50;

SELECT
	*
FROM 
	ironhack.bookings.flights
LIMIT 50;

-- Exploração do valor de booking e tickets
SELECT
	t1.book_ref,
	t1.total_amount,
	t2.ticket_no,
	t3.flight_id,
	t3.amount 
FROM
	ironhack.bookings.bookings AS t1 INNER JOIN
	ironhack.bookings.tickets AS t2 ON t1.book_ref = t2.book_ref INNER JOIN
	ironhack.bookings.ticket_flights AS t3 ON  t2.ticket_no=t3.ticket_no
ORDER BY 
	t1.book_ref;

SELECT
	t1.book_ref,
	AVG(t1.total_amount) AS book_amount,
	SUM(t3.amount) AS ticket_amount,
	ABS(AVG(t1.total_amount) - SUM(t3.amount)) AS diff_amount
FROM
	ironhack.bookings.bookings AS t1 INNER JOIN
	ironhack.bookings.tickets AS t2 ON t1.book_ref = t2.book_ref INNER JOIN
	ironhack.bookings.ticket_flights AS t3 ON  t2.ticket_no=t3.ticket_no
GROUP BY 
	t1.book_ref;


-- Análise de % de atrasos e ticket médio por status de atraso
SELECT
	t1.book_ref,
	t1.total_amount,
	t2.ticket_no,
	t3.flight_id,
	t3.amount,
	t4.status,
	t4.actual_departure, 
	t4.scheduled_departure,
	t4.actual_arrival,
	t4.scheduled_arrival
FROM
	ironhack.bookings.bookings AS t1 INNER JOIN
	ironhack.bookings.tickets AS t2 ON t1.book_ref = t2.book_ref INNER JOIN
	ironhack.bookings.ticket_flights AS t3 ON  t2.ticket_no=t3.ticket_no INNER JOIN 
	ironhack.bookings.flights AS t4 ON t3.flight_id = t4.flight_id;

SELECT 
	DISTINCT t1.status
FROM 
	ironhack.bookings.flights AS t1;

SELECT
	t1.book_ref,
	t1.total_amount,
	t2.ticket_no,
	t3.flight_id,
	t3.amount,
	t4.actual_departure, 
	t4.scheduled_departure,
	t4.actual_departure - t4.scheduled_departure AS atraso_saida
FROM
	ironhack.bookings.bookings AS t1 INNER JOIN
	ironhack.bookings.tickets AS t2 ON t1.book_ref = t2.book_ref INNER JOIN
	ironhack.bookings.ticket_flights AS t3 ON  t2.ticket_no=t3.ticket_no INNER JOIN 
	ironhack.bookings.flights AS t4 ON t3.flight_id = t4.flight_id
WHERE 
	t4.status = 'Departed' OR 
	t4.status = 'Arrived';

SELECT
	t1.book_ref,
	t1.total_amount,
	t2.ticket_no,
	t3.flight_id,
	t3.amount,
	CASE WHEN t4.actual_departure > t4.scheduled_departure + INTERVAL '2 hours' THEN 'ATRASO'
		 ELSE 'PONTUAL' END AS classif_atraso
FROM
	ironhack.bookings.bookings AS t1 INNER JOIN
	ironhack.bookings.tickets AS t2 ON t1.book_ref = t2.book_ref INNER JOIN
	ironhack.bookings.ticket_flights AS t3 ON  t2.ticket_no=t3.ticket_no INNER JOIN 
	ironhack.bookings.flights AS t4 ON t3.flight_id = t4.flight_id
WHERE 
	t4.status = 'Departed' OR 
	t4.status = 'Arrived';

SELECT 
	tb_classif_atraso.classif_atraso,
	COUNT(tb_classif_atraso.flight_id) AS num_voo_atrasado,
	AVG(tb_classif_atraso.amount) AS ticket_medio_atraso
FROM
	(
	SELECT
		t1.book_ref,
		t1.total_amount,
		t2.ticket_no,
		t3.flight_id,
		t3.amount,
		CASE WHEN t4.actual_departure > t4.scheduled_departure + INTERVAL '2 hours' THEN 'ATRASO'
			 ELSE 'PONTUAL' END AS classif_atraso
	FROM
		ironhack.bookings.bookings AS t1 INNER JOIN
		ironhack.bookings.tickets AS t2 ON t1.book_ref = t2.book_ref INNER JOIN
		ironhack.bookings.ticket_flights AS t3 ON  t2.ticket_no=t3.ticket_no INNER JOIN 
		ironhack.bookings.flights AS t4 ON t3.flight_id = t4.flight_id
	WHERE 
		t4.status = 'Departed' OR 
		t4.status = 'Arrived'
	) AS tb_classif_atraso
GROUP BY 
	classif_atraso;
	
CREATE OR REPLACE VIEW ironhack.bookings.tb_atrasos AS
SELECT 
	tb_classif_atraso.classif_atraso,
	COUNT(tb_classif_atraso.flight_id) AS num_voo_atrasado,
	AVG(tb_classif_atraso.amount) AS ticket_medio_atraso
FROM
	(
	SELECT
		t1.book_ref,
		t1.total_amount,
		t2.ticket_no,
		t3.flight_id,
		t3.amount,
		CASE WHEN t4.actual_departure IS NULL THEN 'CANCELADO'
			 WHEN t4.actual_departure > t4.scheduled_departure + INTERVAL '2 hours' THEN 'ATRASO'
			 ELSE 'PONTUAL' END AS classif_atraso
	FROM
		ironhack.bookings.bookings AS t1 INNER JOIN
		ironhack.bookings.tickets AS t2 ON t1.book_ref = t2.book_ref INNER JOIN
		ironhack.bookings.ticket_flights AS t3 ON  t2.ticket_no=t3.ticket_no INNER JOIN 
		ironhack.bookings.flights AS t4 ON t3.flight_id = t4.flight_id
	WHERE 
		t4.status = 'Departed' OR 
		t4.status = 'Arrived'
	) AS tb_classif_atraso
GROUP BY 
	classif_atraso;
	
SELECT * FROM ironhack.bookings.tb_atrasos;