### В этом репозитории содержаться проекты с курса по data science от яндекса практикума который я проходил в 2023 году.

#### Немного информации о курсе:

* Курс рассчитан на 8 месяцев с нагрузкой 15 часов в неделю.
* Один проект по основам SQL добавить в репозиторий не удалось так как он был сделан и изначально рассчитан на выполнение целиком в тренажере яндекса.
* Проекты `05_module_1_project.ipynb` и `09_module_2_project.ipynb` являются сборными и включают в себя все пройденные перед модулем темы.
* К репозиторию прилагаются сертификаты на русском и английском языках.
* К сожалению политика яндекса не позволяет делиться исходными данными которые использовались в проектах, так что только `.ipynb` ноутбуки.

#### Общие впечатления от курса:
Курс рассчитан на новичков, по крайней мере в начале, поэтому на проектах по основам Python, подготовке и исследовательскому анализу данных пока люди осваивали pandas мне было скучновато. В меньшей степени скучно было на SQL. Потом становится сложнее и интереснее. Есть претензии к тренажеру яндекса, так как он не всегда учитывает альтернативные варианты решений задачи. Иногда зависает jupyter ноутбук в облаке яндекса и другие мелкие баги.

#### Описание проектов:
| Filename                                | Description |
|-----------------------------------------|-------------|
| 01_base_python.ipynb                    | Сравнение музыкальных предпочтений между слушателями в Москве и Питере. Базовый Python с pandas. |
| 02_data_preparation_project_p1.ipynb    | Проверка влияния семейного положения и количества детей клиента на погашение кредита в срок. В первой части в основном манипуляции с таблицей, удаление аномалий, заполнение пропусков и.т.п. |
| 02_data_preparation_project_p2.ipynb    | Проверка влияния семейного положения и количества детей клиента на погашение кредита в срок. Необходимо ответить на ряд поставленных вопросов в основном на выявление зависимостей между переменными. |
| 03_exploratory_data_analysis_project.ipynb | Учимся определять рыночную стоимость недвижимости на основе данных из сервиса Яндекс Недвижимость. При помощи графиков типа barchart, boxplot, scatter и stacked barchart выявляем факторы имеющие наибольшее влияние на цену недвижимости. |
| 04_statistics_project.ipynb            | Проверка гипотез, данные от сервиса аренды самокатов. Одна из гипотез, которые нужно проверить говорит что пользователи с подпиской тратят больше времени на поездки и выгоднее для компании. Строим графики распределения, считаем p-value. |
| 05_module_1_project.ipynb               | Для интернет-магазина компьютерных игр нужно выявить закономерности влияющие на успешность игры. Применяем всё что выучили за первые 4 темы. |
| 06_intro_to_machine_learning_project.ipynb | Задача классификации. Для мобильного оператора необходимо построить модель, которая будет предлагать подходящий тариф абонентам. Сравнивал RandomForest и DecisionTree по метрике accuracy. Бонусом проверил модель на адекватность. |
| 07_supervised_learning_project.ipynb    | Необходимо спрогнозировать отток клиентов из банка. Для сдачи проекта необходимо достигнуть F1-меры в 0.59 а также построить AUC-ROC кривую. Использовал дерево решений, случайный лес и логистическую регрессию. На этапе подготовки данных использовал стандартное шкалирование и кодировщик OneHot. Для борьбы с дисбалансом в выборке применил подходы SMOTE и ADASYN. |
| 08_machine_learning_in_business.ipynb   | Построить модель для определения региона с максимальной суммарной прибылью от добычи нефти, дано 3 региона. Для сдачи проекта необходимо использовать Bootstrap. Для модели взял линейную регрессию, для оценки качества модели применил кросс-валидацию. Разобрался с классом sklearn Pipeline. |
| 09_module_2_project.ipynb               | Модель должна предсказать коэффициент восстановления золота из золотосодержащей руды. Задача сложная потому что сложный тех. процесс, несколько этапов в которых разные реагенты. Попробовал модели Ridge, Lasso, LinearRegression и RandomForest. Для проверки на адекватность использовал DummyRegressor. |
| 10_linear_algebra_project.ipynb         | Необходимо преобразовать данные страховой компании так что-бы из них было сложно восстановить первоначальные данные, но при этом машинное обучение не ухудшилось. Решение - умножение на обратимую матрицу, так как такое умножение меняет данные, но в то же время является просто сменой системы координат. |
| 11_numerical_methods_project.ipynb      | Бизнесу необходима модель которая может определять цену автомобиля основываясь на характеристиках автомобиля и ценах других автомобилей. |
| 12_time_series_project.ipynb            | Построить модель для предсказания количества заказов такси на следующий час. Сгруппировал данные по часам, добавил лаги, затем применил 3 регрессора: LightGBM, CatBoost и RandomForest. |
| 13_machine_learning_for_texts_project.ipynb | Задача классификации комментариев в интернет магазине на позитивные и негативные. Токенизируем, считаем эмбеддинги, далее задача сводится к обычной классификации. В данном случае использовал логистическую регрессию(поскольку её можно использовать для задач бинарной классификации), RandomForestClassifier и XGBClassifier. Также попробовал использовать BERT для предсказания, но у меня не получилось, так как не хватило мощности, а на сервере яндекса, где идёт проверка проекта, мощности и подавно бы не хватило. |
| 14_computer_vision_project.ipynb        | Построить модель, которая по фотографии определит приблизительный возраст человека для супермаркета. Файл получился разорванный на несколько кусков, потому что часть кода пришлось запускать на одном сервере яндекса, а другую часть на другом, а вывод результата работы модели вообще вставлять руками. Для работы была взята библиотека tensorflow.keras. Для аугментации датасета был использован ImageDataGenerator. Модель была построена послойно, при помощи класcа Sequential, за базовый уровень была взята пре-тренированная модель ResNet50. Далее было добавлено ещё несколько слоёв. |
| 15_final_project_telecom.ipynb          | Оператор связи хочет предлагать бонусы абонентам которые хотят уйти. Необходима модель которая будет предсказывать разорвет ли абонент договор. Была использована логистическая регрессия, LGBMClassifier и RandomForestClassifier. Всё завернуто в пайплайны, шкалировано и закодировано. Для оценки рассчитаны accuracy_score, roc_auc_score и построена матрица ошибок. Для выявления взаимосвя
