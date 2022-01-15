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
	classif_atraso