﻿
#Область ПрограммныйИнтерфейс

#Если Не ВебКлиент Тогда

// Записать ошибку.
//
// Параметры:
//  ИерархияСобытия - Строка - иерархия события.
//  ИмяСобытия      - Строка - имя события.
//  Сообщение       - Строка - произвольная строка комментария к событию.
//  Данные          - ЛюбаяСсылка, Число, Строка, Дата, Булево - данные, с которыми связано событие.
//
Процедура Ошибка(Знач ИерархияСобытия, Знач ИмяСобытия, Знач Сообщение, Знач Данные = Неопределено) Экспорт
	фмЛоггерВызовСервера.Ошибка(ИмяКомпьютера(), ИерархияСобытия, ИмяСобытия, ПреобразоватьСообщение(Сообщение), Данные);
КонецПроцедуры

// Записать информацию.
//
// Параметры:
//  ИерархияСобытия - Строка - иерархия события.
//  ИмяСобытия      - Строка - имя события.
//  Сообщение       - Строка - произвольная строка комментария к событию.
//  Данные          - ЛюбаяСсылка, Число, Строка, Дата, Булево - данные, с которыми связано событие.
//
Процедура Информация(Знач ИерархияСобытия, Знач ИмяСобытия, Знач Сообщение, Знач Данные = Неопределено) Экспорт
	фмЛоггерВызовСервера.Информация(ИмяКомпьютера(), ИерархияСобытия, ИмяСобытия, ПреобразоватьСообщение(Сообщение), Данные);
КонецПроцедуры

// Записать отладочную информацию.
//
// Параметры:
//  ИерархияСобытия - Строка - иерархия события.
//  ИмяСобытия      - Строка - имя события.
//  Сообщение       - Строка - произвольная строка комментария к событию.
//  Данные          - ЛюбаяСсылка, Число, Строка, Дата, Булево - данные, с которыми связано событие.
//
Процедура Отладка(Знач ИерархияСобытия, Знач ИмяСобытия, Знач Сообщение, Знач Данные = Неопределено) Экспорт
	фмЛоггерВызовСервера.Отладка(ИмяКомпьютера(), ИерархияСобытия, ИмяСобытия, ПреобразоватьСообщение(Сообщение), Данные);
КонецПроцедуры

#КонецЕсли

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПреобразоватьСообщение(Знач Сообщение)
	
	Результат = Сообщение;
	
	Если ТипЗнч(Сообщение) = Тип("ИнформацияОбОшибке") Тогда
		Результат =  Новый Структура("КраткоеПредставление, ПодробноеПредставление",
		                             КраткоеПредставлениеОшибки(Сообщение),
		                             ПодробноеПредставлениеОшибки(Сообщение));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
