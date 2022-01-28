WITH
vacancies_by_month(vacancy_mon, vacancy_count) AS (
	SELECT
		EXTRACT(MONTH FROM date_publication) AS vacancy_mon,
		COUNT(vacancy_id)
	FROM vacancy
	GROUP BY vacancy_mon
),
resumes_by_month(resume_mon, resume_count) AS (
	SELECT
		EXTRACT(MONTH FROM date_publication) AS resume_mon,
		COUNT(resume_id)
	FROM resume
	GROUP BY resume_mon
)
SELECT
	(
		SELECT vacancy_mon FROM vacancies_by_month
	 	WHERE vacancy_count = (SELECT MAX(vacancy_count) FROM vacancies_by_month)
	) AS max_vacancy_mon,
	(
		SELECT resume_mon FROM resumes_by_month
		WHERE resume_count = (SELECT MAX(resume_count) FROM resumes_by_month)
	) AS max_resume_mon