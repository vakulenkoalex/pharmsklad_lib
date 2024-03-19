﻿
#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
	
	ЮТТесты
		.ДобавитьСерверныйТест("ЕстьЗадвоенность", "Если есть задвоенность, то сообщение пользователю")
		.ДобавитьСерверныйТест("НетЗадвоенность", "Если нет задвоенности, то нет сообщений пользователю");
	
КонецПроцедуры

#КонецОбласти

#Область Тесты

Процедура ЕстьЗадвоенность() Экспорт
	
	ПустоеЗначениеРеквизита = "";
	
	ДокументОбъект = Документы.фмпз_Документ.СоздатьДокумент();
	ДокументОбъект.Дата = ТекущаяДатаСеанса();
	НоваяСтрока1 = ДокументОбъект.Таблица.Добавить();
	НоваяСтрока1.Колонка = "1";
	НоваяСтрока2 = ДокументОбъект.Таблица.Добавить();
	НоваяСтрока2.Колонка = ПустоеЗначениеРеквизита;
	НоваяСтрока3 = ДокументОбъект.Таблица.Добавить();
	НоваяСтрока3.Колонка = "1";
	
	Отказ = Ложь;
	фмПроверкиЗаполнения.ПроверитьЗадвоенностьРеквизитаВТаблице(ДокументОбъект, "Таблица", "Колонка", Отказ, ПустоеЗначениеРеквизита);
	
	ЮТест
		.ОжидаетЧто(Отказ, "Отказ")
		.Равно(Истина);
	ЮТест
		.ОжидаетЧто(фмОбработкаСообщенийПользователю.СообщенияПользователюВСтроку(), "сообщения")
		.Содержит("В таблице ""Таблица"" для реквизита ""Колонка"" со значением ""1"" найдено несколько строк");
	
КонецПроцедуры

Процедура НетЗадвоенность() Экспорт
	
	ПустоеЗначениеРеквизита = "";
	
	ДокументОбъект = Документы.фмпз_Документ.СоздатьДокумент();
	ДокументОбъект.Дата = ТекущаяДатаСеанса();
	НоваяСтрока1 = ДокументОбъект.Таблица.Добавить();
	НоваяСтрока1.Колонка = "1";
	НоваяСтрока2 = ДокументОбъект.Таблица.Добавить();
	НоваяСтрока2.Колонка = ПустоеЗначениеРеквизита;
	
	Отказ = Ложь;
	фмПроверкиЗаполнения.ПроверитьЗадвоенностьРеквизитаВТаблице(ДокументОбъект, "Таблица", "Колонка", Отказ, ПустоеЗначениеРеквизита);
	
	ЮТест
		.ОжидаетЧто(Отказ, "Отказ")
		.Равно(Ложь);
	
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