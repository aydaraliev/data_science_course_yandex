-- 1. Отобразите все записи из таблицы company по компаниям, которые закрылись.
SELECT * FROM company
WHERE status = 'closed';
-- 2. Отобразите количество привлечённых средств для новостных компаний США. 
--    Используйте данные из таблицы company. Отсортируйте таблицу по убыванию 
--    значений в поле funding_total.
SELECT   funding_total FROM company
WHERE    category_code = 'news'
AND      country_code  = 'USA'
ORDER BY funding_total DESC;
-- 3. Найдите общую сумму сделок по покупке одних компаний другими в долларах. 
--    Отберите сделки, которые осуществлялись только за наличные с 2011 по 2013 
--    год включительно.
SELECT SUM(price_amount)
FROM   acquisition
WHERE  term_code = 'cash'
AND    EXTRACT('YEAR' from acquired_at::date) BETWEEN 2011 AND 2013;
-- 4. Отобразите имя, фамилию и названия аккаунтов людей в поле network_username, 
--    у которых названия аккаунтов начинаются на 'Silver'.
SELECT first_name, last_name, network_username
FROM   people
WHERE  network_username LIKE 'Silver%';
-- 5. Выведите на экран всю информацию о людях, у которых названия аккаунтов в поле 
--    network_username содержат подстроку 'money', а фамилия начинается на 'K'.
SELECT *
FROM   people
WHERE  network_username LIKE '%money%'
AND    last_name        LIKE 'K%';
-- 6. Для каждой страны отобразите общую сумму привлечённых инвестиций, которые 
--    получили компании, зарегистрированные в этой стране. Страну, в которой 
--    зарегистрирована компания, можно определить по коду страны. Отсортируйте 
--    данные по убыванию суммы.
SELECT   SUM(funding_total) AS total_investment_by_country,
         country_code
FROM     company
GROUP BY country_code
ORDER BY total_investment_by_country DESC;
-- 7. Составьте таблицу, в которую войдёт дата проведения раунда, а также минимальное 
--    и максимальное значения суммы инвестиций, привлечённых в эту дату.
--    Оставьте в итоговой таблице только те записи, в которых минимальное значение суммы 
--    инвестиций не равно нулю и не равно максимальному значению.
SELECT   funded_at,
         MIN(raised_amount) AS min_i,
         MAX(raised_amount) AS max_i
FROM     funding_round
GROUP BY funded_at
HAVING   MIN(raised_amount) != MAX(raised_amount)
AND      MIN(raised_amount) != 0;
-- 8. Создайте поле с категориями:
--    * Для фондов, которые инвестируют в 100 и более компаний, назначьте категорию 
--      high_activity.
--    * Для фондов, которые инвестируют в 20 и более компаний до 100, назначьте категорию
--      middle_activity.
--    * Если количество инвестируемых компаний фонда не достигает 20, назначьте категорию 
--      low_activity.
--    * Отобразите все поля таблицы fund и новое поле с категориями.
SELECT *,
CASE 
    WHEN invested_companies >= 100 THEN 'high_activity'
    WHEN invested_companies >= 20  AND invested_companies < 100 THEN 'middle_activity'
    ELSE 'low_activity'
END
FROM fund;
-- 9. Для каждой из категорий, назначенных в предыдущем задании, посчитайте округлённое до 
--    ближайшего целого числа среднее количество инвестиционных раундов, в которых фонд принимал 
--    участие. Выведите на экран категории и среднее число инвестиционных раундов. Отсортируйте 
--    таблицу по возрастанию среднего.
SELECT
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity,
       ROUND(AVG(investment_rounds)) as average_rounds
FROM fund
GROUP BY activity
ORDER BY average_rounds;
-- 10. Проанализируйте, в каких странах находятся фонды, которые чаще всего инвестируют в стартапы. 
--     Для каждой страны посчитайте минимальное, максимальное и среднее число компаний, в которые 
--     инвестировали фонды этой страны, основанные с 2010 по 2012 год включительно. Исключите 
--     страны с фондами, у которых минимальное число компаний, получивших инвестиции, равно нулю. 
--     Выгрузите десять самых активных стран-инвесторов: отсортируйте таблицу по среднему количеству 
--     компаний от большего к меньшему. Затем добавьте сортировку по коду страны в лексикографическом 
--     порядке.
SELECT	 country_code,
	 MIN(invested_companies), 
	 MAX(invested_companies), 
	 AVG(invested_companies) 
FROM	 fund
WHERE 	 EXTRACT(year from founded_at) BETWEEN 2010 AND 2012
GROUP BY country_code
HAVING   MIN(invested_companies) > 0
ORDER BY AVG(invested_companies)  desc, country_code
LIMIT 10;
-- 11. Отобразите имя и фамилию всех сотрудников стартапов. Добавьте поле с названием учебного заведения, 
--     которое окончил сотрудник, если эта информация известна.
SELECT    p.first_name,
          p.last_name,
          e.institution
FROM      people p
LEFT JOIN education e ON p.id = e.person_id;
-- 12. Для каждой компании найдите количество учебных заведений, которые окончили её сотрудники. Выведите 
--     название компании и число уникальных названий учебных заведений. Составьте топ-5 компаний по количеству 
--     университетов.
SELECT
    comp.name AS company_name,
    COUNT(DISTINCT edu.instituition) AS unique_institutions_count
FROM
    company comp
JOIN people peo ON comp.id = peo.company_id
JOIN education edu ON peo.id = edu.person_id
GROUP BY
    comp.name
ORDER BY
    unique_institutions_count DESC
LIMIT 5;
-- 13. Составьте список с уникальными названиями закрытых компаний, для которых первый раунд финансирования 
--     оказался последним.
SELECT DISTINCT c.name
FROM   company c
JOIN   funding_round fr
ON     c.id = fr.company_id
WHERE fr.is_first_round = 1
AND   fr.is_last_round  = 1
AND   c.status = 'closed';
-- 14. Составьте список уникальных номеров сотрудников, которые работают в компаниях, отобранных в предыдущем задании.
WITH companies AS (
SELECT DISTINCT c.id
FROM   company c
JOIN   funding_round fr
ON     c.id = fr.company_id
WHERE fr.is_first_round = 1
AND   fr.is_last_round  = 1
AND   c.status = 'closed'
) SELECT p.id from people p 
WHERE p.company_id IN (SELECT * FROM companies);
-- 15. Составьте таблицу, куда войдут уникальные пары с номерами сотрудников из предыдущей задачи и учебным заведением, 
--     которое окончил сотрудник.
WITH people_ids AS (
WITH companies AS (
SELECT DISTINCT c.id
FROM   company c
JOIN   funding_round fr
ON     c.id = fr.company_id
WHERE fr.is_first_round = 1
AND   fr.is_last_round  = 1
AND   c.status = 'closed'
) SELECT p.id from people p 
WHERE p.company_id IN (SELECT * FROM companies)
) SELECT DISTINCT pi.id, e.instituition
FROM      people_ids pi
LEFT JOIN education e
ON pi.id = e.person_id
WHERE e.instituition IS NOT NULL;
-- 16. Посчитайте количество учебных заведений для каждого сотрудника из предыдущего задания. При подсчёте учитывайте, 
--     что некоторые сотрудники могли окончить одно и то же заведение дважды.
WITH people_ids AS (
WITH companies AS (
SELECT DISTINCT c.id
FROM   company c
JOIN   funding_round fr
ON     c.id = fr.company_id
WHERE fr.is_first_round = 1
AND   fr.is_last_round  = 1
AND   c.status = 'closed'
) SELECT p.id from people p 
WHERE p.company_id IN (SELECT * FROM companies)
) SELECT pi.id, COUNT(e.instituition)
FROM      people_ids pi
LEFT JOIN education e
ON pi.id = e.person_id
WHERE e.instituition IS NOT NULL
GROUP BY pi.id;
-- 17. Дополните предыдущий запрос и выведите среднее число учебных заведений (всех, не только уникальных), которые 
--     окончили сотрудники разных компаний. Нужно вывести только одну запись, группировка здесь не понадобится.
WITH higher_count AS (
WITH people_ids AS (
WITH companies AS (
SELECT DISTINCT c.id
FROM   company c
JOIN   funding_round fr
ON     c.id = fr.company_id
WHERE fr.is_first_round = 1
AND   fr.is_last_round  = 1
AND   c.status = 'closed'
) SELECT p.id from people p 
WHERE p.company_id IN (SELECT * FROM companies)
) SELECT pi.id, COUNT(e.instituition)
FROM      people_ids pi
LEFT JOIN education e
ON pi.id = e.person_id
WHERE e.instituition IS NOT NULL
GROUP BY pi.id
) SELECT AVG(hc.count)
FROM higher_count hc;
-- 18. Напишите похожий запрос: выведите среднее число учебных заведений (всех, не только уникальных), 
--     которые окончили сотрудники Socialnet.
SELECT AVG(t.total_instituition)
FROM (SELECT p.id, 
      COUNT(e.instituition) AS total_instituition
      FROM people AS p JOIN education AS e ON p.id = e.person_id
      WHERE company_id IN (SELECT id
                           FROM company 
                           WHERE name in ('Socialnet'))
      GROUP BY p.id) AS t;
-- 19. Составьте таблицу из полей:
--     	name_of_fund — название фонда;
--		name_of_company — название компании;
--		amount — сумма инвестиций, которую привлекла компания в раунде.
--	В таблицу войдут данные о компаниях, в истории которых было больше шести важных этапов, а 
--	раунды финансирования проходили с 2012 по 2013 год включительно.
SELECT fund.name AS name_of_fund,
       comp.name AS name_of_company,
       fr.raised_amount AS amount
FROM investment AS invest
JOIN company AS comp ON invest.company_id=comp.id
JOIN fund AS fund ON invest.fund_id=fund.id
JOIN funding_round AS fr ON invest.funding_round_id=fr.id
WHERE EXTRACT(YEAR from CAST(fr.funded_at AS date)) BETWEEN 2012 AND 2013
AND comp.milestones > 6
-- 20. Выгрузите таблицу, в которой будут такие поля:
--		название компании-покупателя;
--		сумма сделки;
--		название компании, которую купили;
--		сумма инвестиций, вложенных в купленную компанию;
--		доля, которая отображает, во сколько раз сумма покупки превысила сумму вложенных в 
--		компанию инвестиций, округлённая до ближайшего целого числа.
--	Не учитывайте те сделки, в которых сумма покупки равна нулю. Если сумма инвестиций в компанию равна нулю, 
--	исключите такую компанию из таблицы. Отсортируйте таблицу по сумме сделки от большей к меньшей, 
--	а затем по названию купленной компании в лексикографическом порядке. Ограничьте таблицу первыми десятью записями.
SELECT 
     c_1.name AS acquiring_company,
     ac.price_amount,
     c_2.name AS acquired_company,
     c_2.funding_total,
     ROUND(ac.price_amount / c_2.funding_total) 
FROM acquisition AS ac
LEFT JOIN company AS c_1 ON ac.acquiring_company_id = c_1.id
LEFT JOIN company AS c_2 ON ac.acquired_company_id = c_2.id
WHERE ac.price_amount > 0
    AND c_2.funding_total > 0
ORDER BY ac.price_amount DESC, acquired_company 
LIMIT 10
-- 21. Выгрузите таблицу, в которую войдут названия компаний из категории social, получившие финансирование с 2010 по 2013 год 
--     включительно. Проверьте, что сумма инвестиций не равна нулю. Выведите также номер месяца, в котором проходил раунд финансирования.
WITH comp AS (
SELECT  id,
        name,
        funding_total
FROM  company
WHERE category_code = 'social'
)
SELECT c.name,
       EXTRACT(MONTH FROM fr.funded_at)
FROM   comp c
JOIN   funding_round fr ON c.id = fr.company_id
WHERE  fr.raised_amount <> 0
AND    EXTRACT(YEAR FROM fr.funded_at) BETWEEN 2010 AND 2013
-- 22. Отберите данные по месяцам с 2010 по 2013 год, когда проходили инвестиционные раунды. Сгруппируйте данные по номеру месяца и получите 
--     таблицу, в которой будут поля:
--		номер месяца, в котором проходили раунды;
--		количество уникальных названий фондов из США, которые инвестировали в этом месяце;
--		количество компаний, купленных за этот месяц;
--		общая сумма сделок по покупкам в этом месяце.
SELECT tab1.month,
       count_fund,
       count,
       sum
FROM (
SELECT EXTRACT(MONTH FROM fr.funded_at) AS month, COUNT(DISTINCT(f.name)) as count_fund
FROM investment AS i
JOIN funding_round AS fr ON i.funding_round_id=fr.id
JOIN fund AS f ON i.fund_id =f.id
WHERE EXTRACT(YEAR FROM fr.funded_at) BETWEEN 2010 AND 2013 AND f.country_code ='USA'
GROUP BY EXTRACT(MONTH FROM fr.funded_at)
) AS tab1
JOIN (SELECT EXTRACT(MONTH FROM acquired_at) AS month, COUNT(acquired_company_id), SUM(price_amount)
FROM acquisition
WHERE EXTRACT(YEAR FROM acquired_at) BETWEEN 2010 AND 2013
GROUP BY EXTRACT(MONTH FROM acquired_at )
) AS tab2 ON tab1.month=tab2.month
-- 23. Составьте сводную таблицу и выведите среднюю сумму инвестиций для стран, в которых есть стартапы, зарегистрированные в 2011, 2012 и 2013 годах. 
--     Данные за каждый год должны быть в отдельном поле. Отсортируйте таблицу по среднему значению инвестиций за 2011 год от большего к меньшему.
WITH
     inv_2011 AS (SELECT country_code AS country,
                         AVG(funding_total) AS funding_11
                  FROM company
                  WHERE EXTRACT(YEAR FROM CAST(founded_at AS DATE)) = '2011'
                  GROUP BY country),
     inv_2012 AS (SELECT country_code AS country,
                         AVG(funding_total) AS funding_12
                  FROM company
                  WHERE EXTRACT(YEAR FROM CAST(founded_at AS DATE)) = '2012'
                  GROUP BY country),
     inv_2013 AS (SELECT country_code AS country,
                         AVG(funding_total) AS funding_13
                  FROM company
                  WHERE EXTRACT(YEAR FROM CAST(founded_at AS DATE)) = '2013'
                  GROUP BY country),
SELECT inv_2011.country,
       funding_11,
       funding_12,
       funding_13

FROM inv_2011
INNER JOIN inv_2012 ON inv_2011.country = inv_2012.country
INNER JOIN inv_2013 ON inv_2012.country = inv_2013.country
ORDER BY funding_11 DESC;




