# План workshop  
1. Общая информация о стуктуре станицы и хранении данных
    1. Создаем таблицу, добавляем данные, смотрим структуру таблицы.
    2. TOAST. Смотрим какие поля туда уходят.
2. Уровни изоляции.
    1. Рассматриваем каждый уровень изолации в отдельности.
    2. Проверяем как работает конкурентное обновление. 
    3. Смотрим на sqew read / update.
3. Транзакции
    1. Смотрим как заполняются поля x_min, x_max
    2. Смотрим про снепшоты. Как они создаются.
    3. Немного про page prunning.
4. Autovacuum
    1. Полный / неполный и остальные режимы.