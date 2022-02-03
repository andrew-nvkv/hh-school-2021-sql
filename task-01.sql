CREATE TABLE dict_employment_type (
	dict_employment_type_id	serial primary key,
	title 					text not null
);

CREATE TABLE dict_work_schedule (
	dict_work_schedule_id	serial primary key,
	title                   text not null
);

CREATE TABLE dict_work_experience (
	dict_work_experience_id	serial primary key,
	title 					text not null
);

CREATE TYPE enum_gender AS ENUM ('M', 'F');



-- is_leaf не обязателен, но значительно оптимизирует поиск по таблице
-- для сохранения консистентности дерева нужно довольно много проверок посредством триггеров и процедур,
-- посчитал это выходящим за рамки задания
CREATE TABLE area (
	area_id		serial primary key,
	area_name	text not null,
	parent_id	integer REFERENCES area(area_id),
	is_leaf		boolean not null
);

-- специальности это не дерево, у одной специальности может быть несколько категорий
-- поэтому одной таблицей не обойтись
CREATE TABLE specialty (
	specialty_id	serial primary key,
	specialty_name	text not null,
	is_leaf			boolean not null
);

CREATE TABLE specialty_hierarchy (
	parent_id	integer REFERENCES specialty(specialty_id),
	child_id	integer REFERENCES specialty(specialty_id),
	
	PRIMARY KEY (parent_id, child_id)
);



CREATE TABLE company (
	company_id		serial primary key,
	company_name	text not null,
	contacts		text
);

-- сначала была идея разделить вакансию на 2 части - собственно текст и опубликованная вакансия,
-- в которой были бы меняющиеся параметры вроде региона, зарплаты (которая зависит от региона), и.т.д.
-- но решил не усложнять структуру таблиц, да и были слишком полей, которые могли бы меняться
CREATE TABLE vacancy (
	vacancy_id				serial primary key,
	vacancy_name			text not null,
	company_id				integer not null REFERENCES company(company_id),
	area_id					integer not null REFERENCES area(area_id),
	dict_work_experience_id	integer not null REFERENCES dict_work_experience(dict_work_experience_id),
	dict_employment_type_id	integer not null REFERENCES dict_employment_type(dict_employment_type_id),
	dict_work_schedule_id	integer not null REFERENCES dict_work_schedule(dict_work_schedule_id),
	specialty_id			integer not null REFERENCES specialty(specialty_id),
	compensation_from		integer CHECK (compensation_from >= 0),
	compensation_to			integer CHECK (compensation_to >= 0),
	date_publication		date not null,
	is_active				boolean not null
);



CREATE TABLE candidate (
	candidate_id	serial primary key,
	name_first		text not null,
	name_middle		text,
	name_last		text not null,
	birth_date		date not null,
	gender			enum_gender not null,
	area_id			integer not null REFERENCES area(area_id)
);

CREATE TABLE resume (
	resume_id				serial primary key,
	resume_name				text not null,
	candidate_id			integer not null REFERENCES candidate(candidate_id),
	dict_employment_type_id	integer not null REFERENCES dict_employment_type(dict_employment_type_id),
	dict_work_schedule_id	integer not null REFERENCES dict_work_schedule(dict_work_schedule_id),
	specialty_id			integer not null REFERENCES specialty(specialty_id),
	work_experience			text not null,
	education				text not null,
	about					text,
	date_publication		date not null,
	is_active				boolean not null
);



CREATE TABLE response (
	vacancy_id		integer REFERENCES vacancy(vacancy_id),
	resume_id		integer REFERENCES resume(resume_id),
	cover_letter	text,
	response_date	date not null,

	PRIMARY KEY (vacancy_id, resume_id)
);