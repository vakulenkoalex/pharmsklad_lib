﻿
#Область ПрограммныйИнтерфейс

// Получить имя узла для записи в тег Node.
// 
// Возвращаемое значение:
//  Строка - имя узла.
//
Функция ПолучитьИмяУзла() Экспорт
	Возврат "";
КонецФункции

// Путь к папке с логом.
// 
// Возвращаемое значение:
//  Строка - путь.
//
Функция ПутьКФайлу() Экспорт
	Возврат фмПараметрыКлиентСерверПовтИсп.ПрочитатьЗначениеПараметра("ЛоггерПутьКФайлу", "");
КонецФункции

// Нужно писать отладочные сообщения.
//
// Параметры:
//  ИерархияСобытия - Строка, ОбъектМетаданных - иерархия события.
// 
// Возвращаемое значение:
//  Булево - если Истина, то отладка включена.
//
Функция ОтладкаВключена(Знач ИерархияСобытия) Экспорт
	
	ЗначениеПараметра = фмПараметрыКлиентСерверПовтИсп.ПрочитатьЗначениеПараметра("ЛоггерВключитьОтладку", "");
	Если ПустаяСтрока(ЗначениеПараметра) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВключенныеИерархииСобытий = СтрРазделить(ЗначениеПараметра, ",", Ложь);
	Возврат ВключенныеИерархииСобытий.Найти(ИерархияСобытия) <> Неопределено;
	
КонецФункции

#КонецОбласти
