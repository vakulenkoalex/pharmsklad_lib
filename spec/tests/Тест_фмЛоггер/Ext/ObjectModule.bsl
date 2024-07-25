﻿
// BSLLS:BeginTransactionBeforeTryCatch-off
// BSLLS:DuplicateStringLiteral-off
// BSLLS:MagicNumber-off
// BSLLS:PairingBrokenTransaction-off
// BSLLS:PublicMethodsDescription-off
// BSLLS:UsingServiceTag-off
// BSLLS:WrongUseOfRollbackTransactionMethod-off

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем КонтекстЯдра; // Контекст проигрывателя тестов
Перем Ожидаем; // Контекст плагина с методами проверки утверждений

Перем ФайлСЛогом; // Имя файла с логом

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область xUnitFor1C

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	
	НаборТестов.Добавить("Тест_ЛогПишетсяВФайлВФорматеJSON");
	НаборТестов.Добавить("Тест_ОтладочноеСообщениеПишетсяТолькоПриУстановкеПараметра");
	НаборТестов.Добавить("Тест_СложныеДанныеИзЛогаСохраняютсяВJson");
	НаборТестов.Добавить("Тест_ЛогированиеРаботаетПослеИсключенияПриЗаписиВБазу");
	НаборТестов.Добавить("Тест_ОтладкаРаботаетПослеИсключенияПриЗаписиВБазу");
	НаборТестов.Добавить("Тест_ОшибкаПриСохраненииДанныхОтличныхОтСтруктура");
	НаборТестов.Добавить("Тест_КонтекстДобавляетсяВДанныеСообщения");
	
КонецПроцедуры

#КонецОбласти

#Область ЮнитТесты

#Область ОбщиеПроцедурыТестов

Процедура ПередЗапускомТеста() Экспорт
	
	НачатьТранзакцию();
	
	МенеджерЗаписи = РегистрыСведений.фмПараметры.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИмяПараметра = "ЛоггерПутьКФайлу";
	МенеджерЗаписи.ЗначениеПараметра = ПолучитьИмяВременногоФайла("txt");
	МенеджерЗаписи.Записать();
	
	МенеджерЗаписи = РегистрыСведений.фмПараметры.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИмяПараметра = "ЛоггерВключитьСообщенияПользователю";
	МенеджерЗаписи.ЗначениеПараметра = "Тест";
	МенеджерЗаписи.Записать();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	ФайлСЛогом = Обработки.фмЛоггер.ПолучитьИмяФайлаСЛогом();
	УдалитьФайлы(ФайлСЛогом);
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
	УдалитьФайлы(ФайлСЛогом);
	
	Если ТранзакцияАктивна() Тогда
		ОтменитьТранзакцию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОписаниеТестов

Процедура Тест_ЛогПишетсяВФайлВФорматеJSON() Экспорт
	
	Файл = Новый Файл(ФайлСЛогом);
	Ожидаем.Что(Файл.Существует(), "файла с логом нет").ЭтоЛожь();
	
	Логгер = фмЛоггерКлиентСервер.СоздатьЛоггер("Тест");
	Логгер.Ошибка("Событие", "описание ошибки");
	Дата = ТекущаяДатаСеанса();
	
	Ожидаем.Что(Файл.Существует(), "файла с логом появился").ЭтоИстина();
	
	ТекстДок = Новый ТекстовыйДокумент;
	ТекстДок.Прочитать(ФайлСЛогом);
	
	Эталон = ПолучитьМакет("Эталон").ПолучитьТекст();
	Эталон = СтрЗаменить(Эталон, "%1", ЗаписатьДатуJSON(Дата, ФорматДатыJSON.ISO, ВариантЗаписиДатыJSON.ЛокальнаяДатаСоСмещением));
	Эталон = СтрЗаменить(Эталон, "%2", ИмяКомпьютера());
	Эталон = СтрЗаменить(Эталон, "%3", "");
	
	Ожидаем.Что(СокрЛП(ТекстДок.ПолучитьТекст()), "формат сообщения совпадает с эталоном").Равно(СокрЛП(Эталон));
	
КонецПроцедуры

Процедура Тест_ОтладочноеСообщениеПишетсяТолькоПриУстановкеПараметра() Экспорт
	
	Файл = Новый Файл(ФайлСЛогом);
	
	Ожидаем.Что(Файл.Существует(), "файла с логом нет").ЭтоЛожь();
	
	Логгер = фмЛоггерКлиентСервер.СоздатьЛоггер("Тест");
	Логгер.Отладка("Событие", "описание ошибки");
	
	Ожидаем.Что(Файл.Существует(), "файла с логом нет").ЭтоЛожь();
	
	МенеджерЗаписи = РегистрыСведений.фмПараметры.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИмяПараметра = "ЛоггерВключитьОтладку";
	МенеджерЗаписи.ЗначениеПараметра = "Обмен,Тест";
	МенеджерЗаписи.Записать();
	ОбновитьПовторноИспользуемыеЗначения();
	
	Логгер = фмЛоггерКлиентСервер.СоздатьЛоггер("Тест");
	Логгер.Отладка("Событие", "описание ошибки");
	
	Ожидаем.Что(Файл.Существует(), "файла с логом появился").ЭтоИстина();
	
КонецПроцедуры

Процедура Тест_СложныеДанныеИзЛогаСохраняютсяВJson() Экспорт

	Файл = Новый Файл(ФайлСЛогом);
	
	Ожидаем.Что(Файл.Существует(), "файла с логом нет").ЭтоЛожь();
	
	КлючЗаписи = РегистрыСведений.фмПараметры.СоздатьКлючЗаписи(Новый Структура("ИмяПараметра", "тест"));
	Дата = ТекущаяДатаСеанса();
	Логгер = фмЛоггерКлиентСервер.СоздатьЛоггер("Тест");
	Логгер.Ошибка("Событие", "описание ошибки", Новый Структура("Адрес, Склад", "новый", КлючЗаписи));
	
	Ожидаем.Что(Файл.Существует(), "файла с логом появился").ЭтоИстина();
	
	ТекстДок = Новый ТекстовыйДокумент();
	ТекстДок.Прочитать(ФайлСЛогом);
	СтрокаJson = ТекстДок.ПолучитьТекст();
	ТекстДок = Неопределено;
	
	Эталон = ПолучитьМакет("ЭталонСложныеДанные").ПолучитьТекст();
	Эталон = СтрЗаменить(Эталон, "%1", ЗаписатьДатуJSON(Дата, ФорматДатыJSON.ISO, ВариантЗаписиДатыJSON.ЛокальнаяДатаСоСмещением));
	Эталон = СтрЗаменить(Эталон, "%2", ИмяКомпьютера());
	Эталон = СтрЗаменить(Эталон, "%3", "");
	Ожидаем.Что(СокрЛП(СтрокаJson), "формат сообщения совпадает с эталоном").Равно(СокрЛП(Эталон));
	
	БылаОшибка = Ложь;
	Попытка
		Лог = фмСериализацияКлиентСервер.UnJSON(СтрокаJson);
		фмСериализацияКлиентСервер.UnJSON(Лог.Data);
	Исключение
		БылаОшибка = Истина;
	КонецПопытки;
	Ожидаем.Что(БылаОшибка, "ошибка преобразования сложных данных").Равно(Ложь);
	
КонецПроцедуры

Процедура Тест_ЛогированиеРаботаетПослеИсключенияПриЗаписиВБазу() Экспорт
	
	Файл = Новый Файл(ФайлСЛогом);
	Ожидаем.Что(Файл.Существует(), "файла с логом нет").ЭтоЛожь();
	
	Логгер = фмЛоггерКлиентСервер.СоздатьЛоггер("Тест");
	
	Попытка
		МенеджерЗаписи = РегистрыСведений.фмПараметры.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Записать();
	Исключение
		Ошибка = ИнформацияОбОшибке();
	КонецПопытки;
	
	Логгер.Ошибка("Событие", Ошибка);
	
	Ожидаем.Что(Файл.Существует(), "файла с логом появился").ЭтоИстина();
	
КонецПроцедуры

Процедура Тест_ОтладкаРаботаетПослеИсключенияПриЗаписиВБазу() Экспорт
	
	МенеджерЗаписи = РегистрыСведений.фмПараметры.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИмяПараметра = "ЛоггерВключитьОтладку";
	МенеджерЗаписи.ЗначениеПараметра = "Тест";
	МенеджерЗаписи.Записать();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Файл = Новый Файл(ФайлСЛогом);
	Ожидаем.Что(Файл.Существует(), "файла с логом нет").ЭтоЛожь();
	
	Логгер = фмЛоггерКлиентСервер.СоздатьЛоггер("Тест");
	
	Попытка
		МенеджерЗаписи = РегистрыСведений.фмПараметры.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Записать();
	Исключение
		Ошибка = ИнформацияОбОшибке();
	КонецПопытки;
	
	Логгер.Отладка("Событие", Ошибка);
	
	Ожидаем.Что(Файл.Существует(), "файла с логом появился").ЭтоИстина();
	
КонецПроцедуры

Процедура Тест_КонтекстДобавляетсяВДанныеСообщения() Экспорт
	
	ИмяКлюча = "НовыйКлюч";
	ЗначениеКлюча = "новое значение";
	
	Данные = Новый Структура();
	Данные.Вставить("Тест1", "тест1");
	Данные.Вставить("Тест2", "тест2");
	
	Логгер = фмЛоггерКлиентСервер.СоздатьЛоггер("Тест");
	Логгер.ДобавитьКонтекст(ИмяКлюча, ЗначениеКлюча);
	Логгер.Ошибка("Событие", "описание ошибки", Данные);
	
	ТекстДок = Новый ТекстовыйДокумент();
	ТекстДок.Прочитать(ФайлСЛогом);
	СтрокаJson = ТекстДок.ПолучитьТекст();
	ТекстДок = Неопределено;
	
	БылаОшибка = Ложь;
	Попытка
		Лог = фмСериализацияКлиентСервер.UnJSON(СтрокаJson);
		Data = фмСериализацияКлиентСервер.UnJSON(Лог.Data);
	Исключение
		БылаОшибка = Истина;
	КонецПопытки;
	Ожидаем.Что(БылаОшибка, "ошибка преобразования сложных данных").Равно(Ложь);
	
	ИмяКлючаДляПроверки = "__" + ИмяКлюча;
	Ожидаем.Что(Data.Свойство(ИмяКлючаДляПроверки), "ключ НовыйКлюч существует").Равно(Истина);
	Ожидаем.Что(Data[ИмяКлючаДляПроверки], "значение ключа НовыйКлюч").Равно(ЗначениеКлюча);
	Ожидаем.Что(Data.Свойство("Тест1"), "ключ Тест1 существует").Равно(Истина);
	Ожидаем.Что(Data["Тест1"], "значение ключа Тест1").Равно("тест1");
	Ожидаем.Что(Data.Свойство("Тест2"), "ключ Тест2 существует").Равно(Истина);
	Ожидаем.Что(Data["Тест2"], "значение ключа Тест2").Равно("тест2");
	
	Ожидаем.Что(Данные.Количество(), "количество ключей не изменилось").Равно(2);
	
КонецПроцедуры

Процедура Тест_ОшибкаПриСохраненииДанныхОтличныхОтСтруктура() Экспорт
	
	Логгер = фмЛоггерКлиентСервер.СоздатьЛоггер("Тест");
	
	БылаОшибка = Ложь;
	Попытка
		Логгер.Ошибка("Событие", "описание ошибки", "1");
	Исключение
		БылаОшибка = Истина;
	КонецПопытки;
	Ожидаем.Что(БылаОшибка, "ошибка записи простых данных").Равно(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли
