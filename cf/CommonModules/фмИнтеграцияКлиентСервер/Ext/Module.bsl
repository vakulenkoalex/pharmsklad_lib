﻿
#Область ПрограммныйИнтерфейс

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
	
	ТипЗначения = ТипЗнч(Тело);
	Если ТипЗначения <> Тип("Строка") Тогда
		ВызватьИсключение СтрШаблон("Тип параметра ""%1"" равен ""%2""", "Тело", Строка(ТипЗначения));
	КонецЕсли;
	
	HTTPЗапрос = ПолучитьHTTPЗапрос(АдресРесурса, ЗаголовкиЗапроса);
	
	ДобавитьЗаголовокТелоВФорматеJSON(HTTPЗапрос);
	Если Не ПустаяСтрока(Тело) Тогда
		HTTPЗапрос.УстановитьТелоИзСтроки(Тело);
	КонецЕсли;
	
	HTTPОтвет = Соединение.ВызватьHTTPМетод(HTTPМетод, HTTPЗапрос);
	Если Не фмКодыСостоянияHTTPКлиентСерверПовтИсп.УспешныйКодОтветаСервиса(HTTPОтвет.КодСостояния) Тогда
		ВызватьИсключение ОписаниеHTTPОтвета(HTTPОтвет);
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

// Проверить что сервис отвечает на запросы OPTIONS.
// Можно использовать как ping сервиса.
// Если не отвечает, то вызываем исключение.
//
// Параметры:
//  Соединение       - HTTPСоединение - HTTP Соединение.
//  АдресРесурса     - Строка - Адрес ресурса, к которому будет происходить HTTP-запрос.
//  ЗаголовкиЗапроса - Соответствие - Заголовки HTTP-запроса.
//
Процедура ЗапросOPTIONSКСервисуОбработан(Знач Соединение, Знач АдресРесурса, Знач ЗаголовкиЗапроса = Неопределено) Экспорт
	
	HTTPЗапрос = ПолучитьHTTPЗапрос(АдресРесурса, ЗаголовкиЗапроса);
	HTTPОтвет = Соединение.ВызватьHTTPМетод("OPTIONS", HTTPЗапрос);
	
	Если HTTPОтвет.КодСостояния <> фмКодыСостоянияHTTPКлиентСерверПовтИсп.КодыОтветаСервиса().NO_CONTENT Тогда
		ВызватьИсключение ОписаниеHTTPОтвета(HTTPОтвет);
	КонецЕсли;
	
КонецПроцедуры

// Отправить данные по FTP через ПотокВПамяти.
//
// Параметры:
//  СоединениеFTP	 - FTPСоединение - FTP соединение.
//  СодержаниеФайла	 - Строка - содержание файла.
//  ИмяФайла		 - Строка - имя файла на FTP.
//  КодировкаФайла	 - КодировкаТекста, Строка - кодировка файла см. ЗаписьДанных.
//
Процедура ОтправитьДанныеПоFTP(Знач СоединениеFTP, Знач СодержаниеФайла, Знач ИмяФайла, Знач КодировкаФайла) Экспорт
	
	ПотокВПамяти  = Новый ПотокВПамяти();
	ЗаписьДанных = Новый ЗаписьДанных(ПотокВПамяти, КодировкаФайла);
	ЗаписьДанных.ЗаписатьСтроку(СодержаниеФайла);
	ЗаписьДанных.Закрыть();
	ПотокВПамяти.Перейти(0, ПозицияВПотоке.Начало);
	
	Попытка
		СоединениеFTP.Записать(ИмяФайла, ПотокВПамяти);
		ПотокВПамяти.Закрыть();
	Исключение
		ПотокВПамяти.Закрыть();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьHTTPЗапрос(Знач АдресРесурса, Знач ЗаголовкиЗапроса = Неопределено)
	
	Если ЗаголовкиЗапроса = Неопределено Тогда
		HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса);
	Иначе
		HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса, ЗаголовкиЗапроса);
	КонецЕсли;
	
	Возврат HTTPЗапрос;
	
КонецФункции

#КонецОбласти