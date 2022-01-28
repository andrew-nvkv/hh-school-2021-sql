SELECT
	area_name,
	AVG(compensation_from)::int,
	AVG(compensation_to)::int,
	AVG((compensation_to + compensation_from)/2)::int
FROM area
JOIN vacancy ON area.area_id = vacancy.area_id
WHERE compensation_from IS NOT NULL AND compensation_to IS NOT NULL
GROUP BY area_name