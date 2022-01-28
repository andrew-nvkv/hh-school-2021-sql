-- Все мелкие словари и небольшие таблицы вроде area и specialty индексировать не имеет смысла. То же самое относится к длинным текстовым полям вроде описания вакансии или соответствующих полей в резюме.
-- Для всех первичных ключей уже созданы индексы автоматически.

-- Все даты должны быть индексированы, так как по ним всегда осуществляется сортировка (обычно в убывающем порядке) и отбор (например, за последнюю неделю).
CREATE INDEX vacancy_date_index ON vacancy (date_publication DESC);
CREATE INDEX resume_date_index ON resume (date_publication DESC);
CREATE INDEX response_date_index ON response (response_date DESC);

-- Названия сущностей должны быть индексированы, так как по ним ведется текстовый поиск.
CREATE INDEX company_name_index ON company (company_name);
CREATE INDEX vacancy_name_index ON vacancy (vacancy_name);
CREATE INDEX resume_name_index ON resume (resume_name);

-- Индексы зарплат, как и в лекции.
CREATE INDEX compensation_index ON vacancy (compensation_from, compensation_to)


-- Имеется несколько агрегатных функций, которые можно оптимизировать. Это количество элементов сгруппированных по: региону, специализации, словарным параметрам (график работы, и.т.д.). Если посмотреть на фильтр на сайте hh, то можно видеть количество вакансий напротив каждого элемента фильтра.
-- для vacancy это будут поля area_id, dict_work_experience_id, dict_employment_type_id, dict_work_schedule_id, specialty_id
-- полагаю, для resume фильтр выглядит похожим образом
-- Данные COUNT(поля) хранятся в отдельных таблицах (агрегатнах таблице), которые представляют собой либо обычную таблицу которая обновляется через триггеры повешенные на таблицы resume и vacancy, которые прибавляют или вычитают значения в агрегатной таблице при вставке или удалении записей в исходных таблицах.
-- Либо данные хранятся в MATERIALIZED VIEW, которые периодически обновляются (например, раз в час). Нам не обязательно знать количество вакансий по регионам с абсолютной точностью, и данные не слишком волатильны, поэтому MATERIALIZED VIEW вполне подойдет.
-- Пример такой таблицы для регионов:
CREATE MATERIALIZED VIEW count_resume_vacancy AS
SELECT area_id, COUNT(area_id) AS area_count
FROM vacancy
GROUP BY area_id;
-- все запросы COUNT затем берут данные из этой таблицы