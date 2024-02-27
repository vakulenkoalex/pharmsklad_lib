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

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область xddTestRunner

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	
	НаборТестов.Добавить("Тест_ДобавитьМинутыКДатеСГрафиком_КоличествоМинутМеньшеГрафика");
	НаборТестов.Добавить("Тест_ДобавитьМинутыКДатеСГрафиком_КоличествоМинутБольшеГрафика");
	НаборТестов.Добавить("Тест_ДатаВTimestamp_БезЧасовогоПояса");
	НаборТестов.Добавить("Тест_ДатаВTimestamp_СЧасовымПоясом");
	
КонецПроцедуры

#КонецОбласти

#Область ЮнитТесты

#Область ОбщиеПроцедурыТестов

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ОписаниеТестов

Процедура Тест_ДобавитьМинутыКДатеСГрафиком_КоличествоМинутМеньшеГрафика() Экспорт
	
	Результат = фмДатаВремяКлиентСервер.ДобавитьМинутыКДатеСГрафиком(Дата('20171010100000'), 120, Дата('00010101080000'), Дата('00010101210000'));
	Ожидаем.Что(Результат, "дата должна получится в этот же день").Равно(Дата('20171010120000'));
	
КонецПроцедуры

Процедура Тест_ДобавитьМинутыКДатеСГрафиком_КоличествоМинутБольшеГрафика() Экспорт
	
	Результат = фмДатаВремяКлиентСервер.ДобавитьМинутыКДатеСГрафиком(Дата('20171010100000'), 2400, Дата('00010101080000'), Дата('00010101210000'));
	Ожидаем.Что(Результат, "дата должна получится на следующие дни").Равно(Дата('20171013110000'));
	
КонецПроцедуры

Процедура Тест_ДатаВTimestamp_БезЧасовогоПояса() Экспорт
	
	Результат = фмДатаВремяКлиентСервер.ДатаВTimestamp('20240221');
	Ожидаем.Что(Результат, "результат").Равно(1708459200);
	
КонецПроцедуры

Процедура Тест_ДатаВTimestamp_СЧасовымПоясом() Экспорт
	
	Результат = фмДатаВремяКлиентСервер.ДатаВTimestamp('20240221', "GMT+0");
	Ожидаем.Что(Результат, "результат").Равно(1708473600);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли