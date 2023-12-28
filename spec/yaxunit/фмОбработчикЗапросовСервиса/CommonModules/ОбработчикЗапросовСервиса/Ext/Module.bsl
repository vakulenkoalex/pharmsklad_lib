﻿
#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
	
	ЮТТесты
		.УдалениеТестовыхДанных()
		.ДобавитьСерверныйТест("ПроверитьСоединение", "Проверка соединения")
		.ДобавитьСерверныйТест("ОбработкаИсключения", "Исключения передаются с 500 ошибкой")
		.ДобавитьСерверныйТест("НеопределеноПередаетсяКакПустаяСтрока", "Если функция возвращает Неопределено, то в теле ответа будет пустая строка");
	
КонецПроцедуры

#КонецОбласти

#Область Тесты

Процедура ПроверитьСоединение() Экспорт
	
	Ответ = фмОбработчикЗапросовСервиса.ОбработатьЗапрос(Новый HTTPЗапрос(), "фмОбработчикЗапросовСервиса.ПроверитьСоединение");
	
	ЮТест
		.ОжидаетЧто(Ответ.ПолучитьТелоКакСтроку(), "тело ответа")
		.Содержит("OK");
	ЮТест
		.ОжидаетЧто(Ответ.КодСостояния, "тело ответа")
		.Равно(200);
	
КонецПроцедуры

Процедура ОбработкаИсключения() Экспорт
	
	Сообщение = "НужноеСообщение";
	ОбщегоНазначения.СообщитьПользователю(Сообщение);
	
	Ответ = фмОбработчикЗапросовСервиса.ОбработатьЗапрос(Новый HTTPЗапрос(), "фмДатаВремяКлиентСервер.ДобавитьМинутыКДатеСГрафиком");
	
	ЮТест
		.ОжидаетЧто(Ответ.ПолучитьТелоКакСтроку(), "тело ответа")
		.Содержит("Недостаточно фактических параметров")
		.Содержит(Сообщение);
	ЮТест
		.ОжидаетЧто(Ответ.КодСостояния, "тело ответа")
		.Равно(500);
		
КонецПроцедуры

Процедура НеопределеноПередаетсяКакПустаяСтрока() Экспорт
	
	Ответ = фмОбработчикЗапросовСервиса.ОбработатьЗапрос(Новый HTTPЗапрос(), "ОбработчикЗапросовСервиса.Тестирование");
	
	ЮТест
		.ОжидаетЧто(Ответ.ПолучитьТелоКакСтроку(), "тело ответа")
		.Содержит("");
	ЮТест
		.ОжидаетЧто(Ответ.КодСостояния, "тело ответа")
		.Равно(200);
	
КонецПроцедуры

#КонецОбласти

#Область События

Процедура ПередВсемиТестами() Экспорт
	
	Описание = Новый Структура();
	Описание.Вставить("ИмяПараметра", "ЛоггерВключитьОтладку");
	Описание.Вставить("ЗначениеПараметра", "фмОбработчикЗапросовСервиса");
	ЮТест.Данные().СоздатьДокумент(РегистрыСведений.фмПараметры, Описание);
	
	Описание = Новый Структура();
	Описание.Вставить("ИмяПараметра", "ЛоггерВключитьСообщенияПользователю");
	Описание.Вставить("ЗначениеПараметра", "фмОбработчикЗапросовСервиса");
	ЮТест.Данные().СоздатьДокумент(РегистрыСведений.фмПараметры, Описание);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция Тестирование(Знач Запрос) Экспорт
	Возврат Неопределено;
КонецФункции

#КонецОбласти