﻿
#Область ПрограммныйИнтерфейс

// Обработать запрос сервиса.
//
// Параметры:
//  Запрос - HTTPСервисЗапрос - Запрос.
//  Обработчик - Строка - Имя экспортной процедуры для обработки запроса.
// 
// Возвращаемое значение:
//  HTTPСервисОтвет - Ответ на запрос.
//
Функция ОбработатьЗапрос(Знач Запрос, Знач Обработчик) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Логгер = фмЛоггерКлиентСервер.СоздатьЛоггер(Метаданные.ОбщиеМодули.фмОбработчикЗапросовСервиса);
	УникальныйКодЗапроса = Строка(Новый УникальныйИдентификатор());
	ДанныеЗапроса = ДанныеЛоггера(Обработчик, Запрос);
	Логгер.Отладка("Запрос", УникальныйКодЗапроса, ДанныеЗапроса);
	
	Попытка
		РезультатФункции = ОбщегоНазначения.ВызватьФункциюКонфигурации(
								Обработчик,
								ОбщегоНазначенияКлиентСервер.МассивЗначений(Запрос));
		JSON = СериализацияОтвета(РезультатФункции);
		Результат = ОтветНаЗапрос(фмКодыСостоянияHTTPКлиентСерверПовтИсп.КодыОтветаСервиса().OK, JSON);
	Исключение 
		
		Ошибка = ИнформацияОбОшибке();
		СообщенияПользователю = фмОбработкаСообщенийПользователю.СообщенияПользователюВСтроку();
		
		Логгер.Ошибка("Запрос", УникальныйКодЗапроса, ДанныеЗапроса);
		ДанныеЛоггера = Новый Структура("ОписаниеОшибки", СообщениеДляЛоггера(Ошибка, СообщенияПользователю));
		Логгер.Ошибка("ОбработатьЗапрос", УникальныйКодЗапроса, ДанныеЛоггера);
		
		ОшибкаДляОтвета = ОшибкиДляОтветаСервисом(Ошибка, СообщенияПользователю);
		JSON = СериализацияОтвета(ОшибкаДляОтвета);
		Результат = ОтветНаЗапрос(фмКодыСостоянияHTTPКлиентСерверПовтИсп.КодыОтветаСервиса().INTERNAL_SERVER_ERROR, JSON);
		
	КонецПопытки;
	
	Логгер.Отладка("Ответ", УникальныйКодЗапроса, Новый Структура("ОтветНаЗапрос", JSON));
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Проверить соединение.
//
// Параметры:
//  Запрос - HTTPСервисЗапрос - запрос.
// 
// Возвращаемое значение:
//  Массив - массив.
//
Функция ПроверитьСоединение(Знач Запрос) Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.МассивЗначений("OK");
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Сформировать ответ на запрос.
//
// Параметры:
//  КодСостояния - Число - код состояния.
//  СтрокаДляОтвета - Строка - результат, который помещается в тело.
// 
// Возвращаемое значение:
//  HTTPСервисОтвет - ответ на запрос.
//
Функция ОтветНаЗапрос(Знач КодСостояния, Знач СтрокаДляОтвета)
	
	Ответ = Новый HTTPСервисОтвет(КодСостояния);
	фмИнтеграцияКлиентСервер.ДобавитьЗаголовокТелоВФорматеJSON(Ответ);
	фмИнтеграцияКлиентСервер.ДобавитьЗаголовокВыключенияКэширования(Ответ);
	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	Возврат Ответ;
	
КонецФункции

Функция ДанныеЛоггера(Знач Обработчик, Знач Запрос)
	
	Результат = Новый Структура();
	Результат.Вставить("Обработчик", Обработчик);
	Результат.Вставить("ЗапросЗаголовки", ЗначениеСоответствияВСтроку(Запрос.Заголовки));
	
	Если ТипЗнч(Запрос) = Тип("HTTPСервисЗапрос")
			Или ТипЗнч(Запрос) = Тип("HTTPЗапрос") Тогда
		Результат.Вставить("ЗапросТело", Запрос.ПолучитьТелоКакСтроку());
	КонецЕсли;
	
	Если ТипЗнч(Запрос) = Тип("HTTPСервисЗапрос") Тогда
		Результат.Вставить("ЗапросHTTPМетод", Запрос.HTTPМетод);
		Результат.Вставить("ЗапросОтносительныйURL", Запрос.ОтносительныйURL);
		Результат.Вставить("ЗапросПараметрыЗапроса", ЗначениеСоответствияВСтроку(Запрос.ПараметрыЗапроса));
		Результат.Вставить("ЗапросПараметрыURL", ЗначениеСоответствияВСтроку(Запрос.ПараметрыURL));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеСоответствияВСтроку(Знач Соответствие)
	
	Строка = Новый Массив();
	Для Каждого КлючЗначение Из Соответствие Цикл
		Строка.Добавить(СтрШаблон("%1: %2", КлючЗначение.Ключ, КлючЗначение.Значение));
	КонецЦикла;
	
	Возврат СтрСоединить(Строка, Символы.ПС);
	
КонецФункции

Функция СообщениеДляЛоггера(Знач ИнформацияОбОшибке, Знач СообщенияПользователю)
	
	Массив = Новый Массив();
	Массив.Добавить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	Если Не ПустаяСтрока(СообщенияПользователю) Тогда
		Массив.Добавить(СообщенияПользователю);
	КонецЕсли;
	
	Возврат СтрСоединить(Массив, Символы.ПС);
	
КонецФункции

Функция СериализацияОтвета(Знач Ответ)
	
	Результат = "";
	
	Если Ответ <> Неопределено Тогда
		Результат = фмСериализацияКлиентСервер.JSON(Ответ);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОшибкиДляОтветаСервисом(Знач ИнформацияОбОшибке, Знач СообщенияПользователю)
	
	Массив = Новый Массив();
	Массив.Добавить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	Если Не ПустаяСтрока(СообщенияПользователю) Тогда
		Массив.Добавить(СообщенияПользователю);
	КонецЕсли;
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти
