WITH
popular_vacancies(vacancy_id) AS (
	SELECT
		response.vacancy_id
	FROM response
	JOIN vacancy ON vacancy.vacancy_id = response.vacancy_id
	WHERE (response.response_date - vacancy.date_publication) BETWEEN 0 AND 7
	GROUP BY response.vacancy_id
	HAVING COUNT(response.vacancy_id) > 5
)
SELECT vacancy.vacancy_id, vacancy_name
FROM popular_vacancies
JOIN vacancy ON vacancy.vacancy_id = popular_vacancies.vacancy_id