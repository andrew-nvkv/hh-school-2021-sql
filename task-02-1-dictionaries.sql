INSERT INTO dict_employment_type(title)
VALUES
('Полная занятость'),
('Частичная занятость'),
('Стажировка'),
('Проектная работа');

INSERT INTO dict_work_schedule(title)
VALUES
('Полный день'),
('Сменный график'),
('Гибкий график'),
('Удаленная работа'),
('Вахтовый метод');

INSERT INTO dict_work_experience(title)
VALUES
('Не имеет значения'),
('Нет опыта'),
('От 1 года до 3 лет'),
('От 3 до 6 лет'),
('Более 6 лет');


-- *** area ***
INSERT INTO area(area_name, parent_id, is_leaf)
VALUES
('Россия', NULL, false);

WITH t(area_name, is_leaf) AS (VALUES
	('Москва', true),
	('Санкт-Петербург', true),
	('Владимирская область', false),
	('Ярославская область', false)
)
INSERT INTO area(area_name, parent_id, is_leaf)
SELECT t.area_name, area.area_id, t.is_leaf
FROM t, area
WHERE area.area_name = 'Россия';

WITH t(area_name) AS (VALUES
('Александров'),
('Балакирево'),
('Владимир'),
('Вольгинский'),
('Вязники'),
('Гороховец'),
('Гусь-Хрустальный'),
('Камешково'),
('Карабаново'),
('Киржач'),
('Ковров'),
('Кольчугино'),
('Костерево'),
('Красная Горбатка'),
('Красный Октябрь'),
('Курлово'),
('Лакинск'),
('Меленки'),
('Муром'),
('Петушки'),
('Покров'),
('Радужный (Владимирская область)'),
('Собинка'),
('Ставрово'),
('Струнино'),
('Судогда'),
('Суздаль'),
('Юрьев-Польский'),
('Городищи')
)
INSERT INTO area(area_name, parent_id, is_leaf)
SELECT t.area_name, area.area_id, true
FROM t, area
WHERE area.area_name = 'Владимирская область';



WITH t(area_name) AS (VALUES
('Большое Село'),
('Борисоглебский'),
('Брейтово'),
('Гаврилов-Ям'),
('Данилов'),
('Константиновский'),
('Красные Ткачи'),
('Любим'),
('Мышкин'),
('Нагорный'),
('Некрасовское'),
('Новый Некоуз'),
('Переславль-Залесский'),
('Петровское (Ярославская область)'),
('Пошехонье'),
('Пречистое'),
('Ростов (Ярославская область)'),
('Рыбинск'),
('Семибратово'),
('Тутаев'),
('Углич'),
('Щедрино'),
('Ярославль'),
('Левашово')
)
INSERT INTO area(area_name, parent_id, is_leaf)
SELECT t.area_name, area.area_id, true
FROM t, area
WHERE area.area_name = 'Ярославская область';



-- *** specialty ***
WITH t(specialty_name) AS (VALUES
('Автомобильный бизнес'),
('Рабочий персонал'),
('Домашний, обслуживающий персонал')
)
INSERT INTO specialty(specialty_name, is_leaf)
SELECT t.specialty_name, false
FROM t;

WITH t(specialty_name) AS (VALUES
('Автомойщик'),
('Автослесарь, автомеханик'),
('Администратор'),
('Водитель'),
('Грузчик'),
('Дворник'),
('Кладовщик'),
('Курьер'),
('Маляр, штукатур'),
('Мастер-приемщик'),
('Машинист'),
('Менеджер по продажам, менеджер по работе с клиентами'),
('Монтажник'),
('Оператор производственной линии'),
('Оператор станков с ЧПУ'),
('Официант, бармен, бариста'),
('Охранник'),
('Разнорабочий'),
('Сварщик'),
('Сервисный инженер, механик'),
('Слесарь'),
('Токарь, фрезеровщик, шлифовщик'),
('Уборщица, уборщик'),
('Упаковщик, комплектовщик'),
('Электромонтажник')
)
INSERT INTO specialty(specialty_name, is_leaf)
SELECT t.specialty_name, true
FROM t;



-- *** specialty_hierarchy ***
WITH t_child(specialty_name) AS (VALUES
('Автомойщик'),
('Автослесарь, автомеханик'),
('Мастер-приемщик'),
('Менеджер по продажам, менеджер по работе с клиентами')
),
t_parent(parent_id) AS (
	SELECT specialty_id FROM specialty
	WHERE specialty_name = 'Автомобильный бизнес'
)
INSERT INTO specialty_hierarchy(parent_id, child_id)
SELECT t_parent.parent_id, specialty.specialty_id
FROM t_child
CROSS JOIN t_parent
JOIN specialty ON t_child.specialty_name = specialty.specialty_name;


WITH t_child(specialty_name) AS (VALUES
('Автослесарь, автомеханик'),
('Водитель'),
('Грузчик'),
('Кладовщик'),
('Маляр, штукатур'),
('Машинист'),
('Монтажник'),
('Оператор производственной линии'),
('Оператор станков с ЧПУ'),
('Разнорабочий'),
('Сварщик'),
('Сервисный инженер, механик'),
('Слесарь'),
('Токарь, фрезеровщик, шлифовщик'),
('Упаковщик, комплектовщик'),
('Электромонтажник')
),
t_parent(parent_id) AS (
	SELECT specialty_id FROM specialty
	WHERE specialty_name = 'Рабочий персонал'
)
INSERT INTO specialty_hierarchy(parent_id, child_id)
SELECT t_parent.parent_id, specialty.specialty_id
FROM t_child
CROSS JOIN t_parent
JOIN specialty ON t_child.specialty_name = specialty.specialty_name;



WITH t_child(specialty_name) AS (VALUES
('Администратор'),
('Водитель'),
('Дворник'),
('Курьер'),
('Официант, бармен, бариста'),
('Охранник'),
('Уборщица, уборщик')
),
t_parent(parent_id) AS (
	SELECT specialty_id FROM specialty
	WHERE specialty_name = 'Домашний, обслуживающий персонал'
)
INSERT INTO specialty_hierarchy(parent_id, child_id)
SELECT t_parent.parent_id, specialty.specialty_id
FROM t_child
CROSS JOIN t_parent
JOIN specialty ON t_child.specialty_name = specialty.specialty_name;

