-- *** company ***
WITH test_data(id, company_name, contacts) AS (
	SELECT
		generate_series(1, 100),
		md5(random()::text),
		md5(random()::text)
)
INSERT INTO company(company_name, contacts)
SELECT company_name, contacts
FROM test_data;



-- *** vacancy ***
WITH
area_leaf(area_id) AS (
	SELECT area_id FROM area
	WHERE is_leaf = true
),
specialty_leaf(specialty_id) AS (
	SELECT area_id FROM area
	WHERE is_leaf = true
),
test_data(id, vacancy_name, company_id, area_offset,
	dict_work_experience_id, dict_employment_type_id, dict_work_schedule_id,
	specialty_offset, salary, date_publication, is_active) AS (
	SELECT
		generate_series(1, 10000),
		md5(random()::text) AS vacancy_name,
		(random() * 99 + 1)::int AS company_id,
		(random() * 54)::int AS area_id, -- 55 total
		(random() * 4 + 1)::int AS dict_work_experience_id,
		(random() * 3 + 1)::int AS dict_employment_type_id,
		(random() * 4 + 1)::int AS dict_work_schedule_id,
		(random() * 24)::int AS specialty_offset, -- 25 total
		(random() * 50000 + 15000)::int AS salary,
		-- вакансии формируются за полтора года
		('1-1-2020'::date + '1 day'::interval*(random() * 548)::int)::date AS date_publication,
		true AS is_active
)
INSERT INTO vacancy(vacancy_name, company_id, area_id,
	dict_work_experience_id, dict_employment_type_id, dict_work_schedule_id,
	specialty_id, compensation_from, compensation_to,
	date_publication, is_active)
SELECT vacancy_name, company_id,
	(SELECT area_id FROM area_leaf LIMIT 1 OFFSET area_offset),
	dict_work_experience_id, dict_employment_type_id, dict_work_schedule_id,
	(SELECT specialty_id FROM specialty_leaf LIMIT 1 OFFSET specialty_offset),
	salary, salary + (random() * 30000)::int,
	date_publication, is_active
FROM test_data;



-- *** candidate ***
WITH
area_leaf(area_id) AS (
	SELECT area_id FROM area
	WHERE is_leaf = true
),
test_data(id, name_first, name_middle, name_last,
	birth_date, gender, area_offset) AS (
	SELECT
		generate_series(1, 20000),
		md5(random()::text) AS name_first,
		md5(random()::text) AS name_middle,
		md5(random()::text) AS name_last,
		('1-1-1970'::date + '1 day'::interval*(random() * 365 * 34)::int)::date AS birth_date,
		(array['M', 'F'])[(random()*1+1)::int]::enum_gender AS gender,
		(random() * 54)::int AS area_offset -- 55 total
)
INSERT INTO candidate(name_first, name_middle, name_last,
	birth_date, gender, area_id)
SELECT name_first, name_middle, name_last,
	birth_date, gender,
	(SELECT area_id FROM area_leaf LIMIT 1 OFFSET area_offset)
FROM test_data;



-- *** resume ***
WITH
specialty_leaf(specialty_id) AS (
	SELECT area_id FROM area
	WHERE is_leaf = true
),
test_data(id, resume_name, candidate_id,
	dict_employment_type_id, dict_work_schedule_id, specialty_offset,
	work_experience, education, about, date_publication, is_active) AS (
	SELECT
		generate_series(1, 100000),
		md5(random()::text) AS resume_name,
		(random() * 19999 + 1)::int AS candidate_id,
		(random() * 3 + 1)::int AS dict_employment_type_id,
		(random() * 4 + 1)::int AS dict_work_schedule_id,
		(random() * 24)::int AS specialty_offset, -- 25 total
		md5(random()::text) AS work_experience,
		md5(random()::text) AS education,
		md5(random()::text) AS about,
		('1-1-2020'::date + '1 day'::interval*(random() * 548)::int)::date AS date_publication,
		true AS is_active
)
INSERT INTO resume(resume_name, candidate_id,
	dict_employment_type_id, dict_work_schedule_id, specialty_id,
	work_experience, education, about, date_publication, is_active)
SELECT resume_name, candidate_id,
	dict_employment_type_id, dict_work_schedule_id,
	(SELECT specialty_id FROM specialty_leaf LIMIT 1 OFFSET specialty_offset),
	work_experience, education, about, date_publication, is_active
FROM test_data;



-- *** response ***
WITH cross_data(vacancy_id, resume_id, cover_letter, response_date) AS(
	SELECT
		vacancy_id,
		resume_id,
		md5(random()::text) AS cover_letter,
		-- отклики будут в пределах 30 дней
		(resume.date_publication + '1 day'::interval * (random() * 30 + 1)::int)::date AS response_date
	FROM resume
	-- обрезаем половину записей чтобы внести случайность и чтобы не было полного декартого произведения
	TABLESAMPLE BERNOULLI(50)
	CROSS JOIN vacancy
	JOIN candidate ON candidate.candidate_id = resume.candidate_id
	WHERE resume.date_publication > vacancy.date_publication
		AND candidate.area_id = vacancy.area_id
)
INSERT INTO response(vacancy_id, resume_id, cover_letter, response_date)
SELECT vacancy_id, resume_id, cover_letter, response_date
FROM cross_data;