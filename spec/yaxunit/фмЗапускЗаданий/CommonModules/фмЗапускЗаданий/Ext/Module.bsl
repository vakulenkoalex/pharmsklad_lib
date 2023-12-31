﻿
#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
	
	ЮТТесты
		.УдалениеТестовыхДанных()
		.ДобавитьСерверныйТест("ЗаданияЗапускаютсяПоПорядку", "Задания запускаются в том же порядка как указано в ПараметрыЗапуска")
		.ДобавитьСерверныйТест("ОдновременноРаботаютНеБольшеЧемУказаноВПараметрах", "Одновременно работают ограниченное количество заданий")
		.ДобавитьСерверныйТест("СообщенияВПроцессеВыполненияЗаданийПередаютсяПроцедуреЗапуска", "Сообщения из фоновых заданий прокидываются наверх")
		.ДобавитьСерверныйТест("ЕслиФоновоеЗаданиеАварийноЗавершаетсяТоПередаемПроцедуреЗапуска", "Задания завершенные аварийно прокидываются наверх");
	
КонецПроцедуры

#КонецОбласти

#Область Тесты

Процедура ЗаданияЗапускаютсяПоПорядку() Экспорт
	
	КоличествоПотоков = 3;
	ПараметрыЗапуска = СоздатьПараметрыЗапуска();
	
	ДатаЗапуска = ТекущаяДатаСеанса();
	Обработки.фмЗапускЗаданий.Старт(ПараметрыЗапуска, КоличествоПотоков, Истина);
	
	ТаблицаДляПроверки = ДанныеФоновыхЗаданий(ДатаЗапуска);
	ТаблицаДляПроверки.Сортировать("Начало, Наименование");
	
	Счетчик = 1;
	Для Каждого СтрокаПроверки Из ТаблицаДляПроверки Цикл
		ЮТест
			.ОжидаетЧто(СтрокаПроверки.Наименование, "наименование задание")
			.Равно(НаименованиеЗадания() + Формат(Счетчик, "ЧГ="));
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОдновременноРаботаютНеБольшеЧемУказаноВПараметрах() Экспорт
	
	КоличествоПотоков = 3;
	ПараметрыЗапуска = СоздатьПараметрыЗапуска();
	
	ДатаЗапуска = ТекущаяДатаСеанса();
	Обработки.фмЗапускЗаданий.Старт(ПараметрыЗапуска, КоличествоПотоков, Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДат", ДанныеФоновыхЗаданий(ДатаЗапуска));
	Запрос.УстановитьПараметр("КоличествоПотоков", КоличествоПотоков);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаДат.Начало КАК ДатаНачала,
	               |	ТаблицаДат.Конец КАК ДатаКонца
	               |ПОМЕСТИТЬ ТаблицаДат
	               |ИЗ
	               |	&ТаблицаДат КАК ТаблицаДат
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МИНИМУМ(ТаблицаДат.ДатаНачала) КАК МинимальнаяДата
	               |ПОМЕСТИТЬ ДатаМинимум
	               |ИЗ
	               |	ТаблицаДат КАК ТаблицаДат
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МАКСИМУМ(ТаблицаДат.ДатаКонца) КАК МаксимальнаяДата
	               |ПОМЕСТИТЬ ДатаМаксимум
	               |ИЗ
	               |	ТаблицаДат КАК ТаблицаДат
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	0 КАК Х
	               |ПОМЕСТИТЬ Регистр1
	               |
	               |ОБЪЕДИНИТЬ
	               |
	               |ВЫБРАТЬ
	               |	1
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Младшие.Х + 2 * Старшие.Х КАК Х
	               |ПОМЕСТИТЬ Регистр2
	               |ИЗ
	               |	Регистр1 КАК Младшие,
	               |	Регистр1 КАК Старшие
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Младшие.Х + 4 * Старшие.Х КАК Х
	               |ПОМЕСТИТЬ Регистр4
	               |ИЗ
	               |	Регистр2 КАК Младшие,
	               |	Регистр2 КАК Старшие
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Младшие.Х + 16 * Старшие.Х КАК Х
	               |ПОМЕСТИТЬ ДобавитьСекунды
	               |ИЗ
	               |	Регистр4 КАК Младшие,
	               |	Регистр4 КАК Старшие
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ДОБАВИТЬКДАТЕ(ДатаМинимум.МинимальнаяДата, СЕКУНДА, ДобавитьСекунды.Х) КАК ПроверяемаяСекунда
	               |ПОМЕСТИТЬ Секунды
	               |ИЗ
	               |	ДатаМинимум КАК ДатаМинимум,
	               |	ДатаМаксимум КАК ДатаМаксимум,
	               |	ДобавитьСекунды КАК ДобавитьСекунды
	               |ГДЕ
	               |	ДОБАВИТЬКДАТЕ(ДатаМинимум.МинимальнаяДата, СЕКУНДА, ДобавитьСекунды.Х) < ДатаМаксимум.МаксимальнаяДата
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДОБАВИТЬКДАТЕ(ДатаМинимум.МинимальнаяДата, СЕКУНДА, ДобавитьСекунды.Х)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Секунды.ПроверяемаяСекунда КАК ПроверяемаяСекунда,
	               |	КОЛИЧЕСТВО(Секунды.ПроверяемаяСекунда) КАК ВсегоЗаданий
	               |ПОМЕСТИТЬ ЗаданияКаждуюСекунду
	               |ИЗ
	               |	Секунды КАК Секунды
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаДат КАК ТаблицаДат
	               |		ПО Секунды.ПроверяемаяСекунда >= ТаблицаДат.ДатаНачала
	               |			И Секунды.ПроверяемаяСекунда < ТаблицаДат.ДатаКонца
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Секунды.ПроверяемаяСекунда
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЗаданияКаждуюСекунду.ВсегоЗаданий КАК ВсегоЗаданий
	               |ИЗ
	               |	ЗаданияКаждуюСекунду КАК ЗаданияКаждуюСекунду
	               |ГДЕ
	               |	ЗаданияКаждуюСекунду.ВсегоЗаданий > &КоличествоПотоков";
	ЮТест
		.ОжидаетЧто(Запрос.Выполнить().Пустой(), "запрос по интервалам работы заданий")
		.ЭтоИстина();
	
КонецПроцедуры

Процедура СообщенияВПроцессеВыполненияЗаданийПередаютсяПроцедуреЗапуска() Экспорт
	
	Перем СообщенияФоновыхЗаданий;
	
	КоличествоПотоков = 3;
	ПараметрыЗапуска = СоздатьПараметрыЗапуска(1);
	
	Обработки.фмЗапускЗаданий.Старт(ПараметрыЗапуска, КоличествоПотоков, Истина, СообщенияФоновыхЗаданий);
	
	ЮТест
		.ОжидаетЧто(СообщенияФоновыхЗаданий.Количество(), "количество переданных сообщений")
		.Больше(0);
	
КонецПроцедуры

Процедура ЕслиФоновоеЗаданиеАварийноЗавершаетсяТоПередаемПроцедуреЗапуска() Экспорт
	
	Перем ЗаданияЗавершенныеАварийно;
	
	КоличествоПотоков = 3;
	ПараметрыЗапуска = СоздатьПараметрыЗапуска(-1);
	
	Обработки.фмЗапускЗаданий.Старт(ПараметрыЗапуска, КоличествоПотоков, Истина, , ЗаданияЗавершенныеАварийно);
	
	ЮТест
		.ОжидаетЧто(ЗаданияЗавершенныеАварийно.Количество(), "количество аварийных заданий")
		.Больше(0);
	
КонецПроцедуры

#КонецОбласти

#Область События

Процедура ПередВсемиТестами() Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НаименованиеЗадания()
	Возврат "ЗапускДлительнойОперацииДляТеста";
КонецФункции

Функция СоздатьПараметрыЗапуска(Знач ТипТеста = 0)
	
	ИмяМетода = "Обработки.фмЗапускЗаданий.ЗапускДлительнойОперацииДляТеста";
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(ТипТеста);
	ПараметрыЗапуска = Обработки.фмЗапускЗаданий.ПараметрыЗапуска();
	Для Счетчик = 1 По 6 Цикл
		НоваяСтрока = ПараметрыЗапуска.Добавить();
		НоваяСтрока.Наименование = НаименованиеЗадания() + Формат(Счетчик, "ЧГ=");
	КонецЦикла;
	ПараметрыЗапуска.ЗаполнитьЗначения(ПараметрыМетода, "Параметры");
	ПараметрыЗапуска.ЗаполнитьЗначения(ИмяМетода, "ИмяМетода");
	
	Возврат ПараметрыЗапуска;
	
КонецФункции

Функция ДанныеФоновыхЗаданий(Знач ДатаЗапуска, Знач КоличествоЗаданий = 6)
	
	НайденныеЗадания = НайтиФоновоеЗадания(ДатаЗапуска);
	ЮТест
		.ОжидаетЧто(НайденныеЗадания.Количество(), "количество созданных заданий")
		.Равно(КоличествоЗаданий);
	
	ТаблицаДляПроверки = Новый ТаблицаЗначений;
	ТаблицаДляПроверки.Колонки.Добавить("Начало", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
	ТаблицаДляПроверки.Колонки.Добавить("Конец", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
	ТаблицаДляПроверки.Колонки.Добавить("Наименование");
	Для Каждого Задание Из НайденныеЗадания Цикл
		НоваяСтрока = ТаблицаДляПроверки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Задание);
	КонецЦикла;
	
	Возврат ТаблицаДляПроверки;
	
КонецФункции

Функция НайтиФоновоеЗадания(Знач ДатаЗапуска, Знач Состояние = Неопределено)
	
	ОтборЗаданий = Новый Структура;
	ОтборЗаданий.Вставить("ИмяМетода", "ОбщегоНазначения.ВыполнитьМетодКонфигурации");
	ОтборЗаданий.Вставить("Начало", ДатаЗапуска);
	Если Состояние <> Неопределено Тогда
		ОтборЗаданий.Вставить("Состояние ", Состояние);
	Иначе
		ОтборЗаданий.Вставить("Состояние ", СостояниеФоновогоЗадания.Завершено);
	КонецЕсли;
	
	НайденныеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(ОтборЗаданий);
	
	Возврат НайденныеЗадания;
	
КонецФункции

#КонецОбласти