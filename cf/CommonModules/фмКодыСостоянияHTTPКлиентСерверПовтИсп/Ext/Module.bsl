﻿
#Область СлужебныйПрограммныйИнтерфейс

// Коды ответа Http сервиса.
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура - структура.
//
Функция КодыОтветаСервиса() Экспорт
	
	Структура = Новый Структура();
	Структура.Вставить("OK", 200);
	Структура.Вставить("NO_CONTENT", 204);
	Структура.Вставить("INTERNAL_SERVER_ERROR", 500);
	Структура.Вставить("UNAUTHORIZED", 401);
	
	Возврат Новый ФиксированнаяСтруктура(Структура);
	
КонецФункции

// Код ответа сервиса равен 200.
//
// Параметры:
//  КодСостояния - Число - код состояния ответа.
// 
// Возвращаемое значение:
//  Булево - если Истина, то КодСостояния равен 200.
//
Функция УспешныйКодОтветаСервиса(Знач КодСостояния) Экспорт
	Возврат КодСостояния = КодыОтветаСервиса().OK;
КонецФункции

#КонецОбласти
