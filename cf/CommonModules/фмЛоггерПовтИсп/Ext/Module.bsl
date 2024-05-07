﻿
#Область ПрограммныйИнтерфейс

// Нужно писать отладочные сообщения.
//
// Параметры:
//  ИерархияСобытия - Строка, ОбъектМетаданных - иерархия события.
// 
// Возвращаемое значение:
//  Булево - если Истина, то отладка включена.
//
Функция ОтладкаВключена(Знач ИерархияСобытия) Экспорт
	Возврат фмЛоггерПереопределяемый.ОтладкаВключена(ИерархияСобытия);
КонецФункции

// Создать логгер.
//
// Параметры:
//  ИерархияСобытия - Строка - иерархия события.
//  ИмяКлиента - Строка - переопределить имя компьютера, на котором произошло событие.
// 
// Возвращаемое значение:
//  ОбработкаОбъект.фмЛоггер - объект для записи лога.
//
Функция СоздатьЛоггер(Знач ИерархияСобытия, Знач ИмяКлиента = "") Экспорт
	Возврат Обработки.фмЛоггер.СоздатьОбъект(ИерархияСобытия, ИмяКлиента);
КонецФункции

// Нужно писать сообщения пользователю.
//
// Параметры:
//  ИерархияСобытия - Строка, ОбъектМетаданных - иерархия события.
// 
// Возвращаемое значение:
//  Булево - если Истина, то нужно писать сообщения пользователю.
//
Функция СообщенияПользователюВключены(Знач ИерархияСобытия) Экспорт
	Возврат фмЛоггерПереопределяемый.СообщенияПользователюВключены(ИерархияСобытия);
КонецФункции

#КонецОбласти