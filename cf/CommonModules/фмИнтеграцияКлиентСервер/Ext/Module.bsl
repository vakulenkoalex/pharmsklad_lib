﻿
#Область ПрограммныйИнтерфейс

#Если Не ВебКлиент Тогда

// Прочитать JSON.
//
// Параметры:
//  СтрокаJSON - Строка - строка для чтения.
// 
// Возвращаемое значение:
//  Произвольный - результат.
//
Функция UnJSON(Знач СтрокаJSON) Экспорт
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	Данные = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	Возврат Данные;
	
КонецФункции

// Сохранить данные в формате JSON.
//
// Параметры:
//  Данные - Произвольный - данные для сохранения.
// 
// Возвращаемое значение:
//  Строка - json представление.
//
Функция JSON(Знач Данные) Экспорт
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, Данные);
	СтрокаJSON = ЗаписьJSON.Закрыть();
	
	Возврат СтрокаJSON;
	
КонецФункции

#КонецЕсли

// Описание HTTP ответа сервиса.
//
// Параметры:
//  HTTPОтвет - HTTPОтвет - http ответ сервиса.
// 
// Возвращаемое значение:
//  Строка - описание ответа.
//
Функция ОписаниеHTTPОтвета(Знач HTTPОтвет) Экспорт
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("КодСостояния: %1, описание: ""%2"".",
																		HTTPОтвет.КодСостояния,
																		HTTPОтвет.ПолучитьТелоКакСтроку());
КонецФункции

// Добавить заголовок, что тело запроса в формате JSON.
//
// Параметры:
//  HTTPЗапрос - HTTPЗапрос, HTTPСервисОтвет - http запрос или ответ. 
//
Процедура ДобавитьЗаголовокТелоВФорматеJSON(HTTPЗапрос) Экспорт
	HTTPЗапрос.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
КонецПроцедуры

// Отправить HTTPЗапрос и получить тело 200-го ответа, иначе падаем с ошибкой.
//
// Параметры:
//  Соединение       - HTTPСоединение - HTTP Соединение.
//  HTTPМетод        - Строка - Строка, содержащая имя HTTP-метода для запроса.
//  АдресРесурса     - Строка - Адрес ресурса, к которому будет происходить HTTP-запрос.
//  Тело             - Строка - Тело запроса в виде строки.
//  ЗаголовкиЗапроса - Соответствие - Заголовки HTTP-запроса.
// 
// Возвращаемое значение:
//  Строка - тело ответа.
//
Функция ПолучитьУспешныйОтветНаЗапрос(Знач Соединение, Знач HTTPМетод, Знач АдресРесурса, Знач Тело = "", Знач ЗаголовкиЗапроса = Неопределено) Экспорт
	
	Если ЗаголовкиЗапроса = Неопределено Тогда
		HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса);
	Иначе
		HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса, ЗаголовкиЗапроса);
	КонецЕсли;
	
	фмИнтеграцияКлиентСервер.ДобавитьЗаголовокТелоВФорматеJSON(HTTPЗапрос);
	Если Не ПустаяСтрока(Тело) Тогда
		HTTPЗапрос.УстановитьТелоИзСтроки(Тело);
	КонецЕсли;
	
	HTTPОтвет = Соединение.ВызватьHTTPМетод(HTTPМетод, HTTPЗапрос);
	Если Не фмКодыСостоянияHTTPКлиентСерверПовтИсп.УспешныйКодОтветаСервиса(HTTPОтвет.КодСостояния) Тогда
		ВызватьИсключение фмИнтеграцияКлиентСервер.ОписаниеHTTPОтвета(HTTPОтвет);
	КонецЕсли;
	
	Возврат HTTPОтвет.ПолучитьТелоКакСтроку();
	
КонецФункции

// Добавить заголовок, что ответ не нужно кэшировать.
//
// Параметры:
//  HTTPЗапрос - HTTPЗапрос, HTTPСервисОтвет - http запрос или ответ. 
//
Процедура ДобавитьЗаголовокВыключенияКэширования(HTTPЗапрос) Экспорт
	HTTPЗапрос.Заголовки.Вставить("Cache-Control", "no-cache");
КонецПроцедуры

#КонецОбласти
