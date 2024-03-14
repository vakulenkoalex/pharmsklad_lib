﻿
#Область ПрограммныйИнтерфейс

// Останавливает выполнение кода на заданное время через цикл.
//
// Параметры:
//  КоличествоСекунд - Число - время ожидания в секундах.
//
Процедура ПаузаЧерезЦикл(Знач КоличествоСекунд) Экспорт
	
	Если НеНужнаЗапускатьПаузу(КоличествоСекунд) Тогда
		Возврат;
	КонецЕсли;
	
	ПодождатьДоЧерезЦикл(ТекущаяДата() + КоличествоСекунд);
	
КонецПроцедуры

// Подождать пока не наступит указанное время через цикл.
//
// Параметры:
//  ВремяЗавершения - Дата - время.
//
Процедура ПодождатьДоЧерезЦикл(Знач ВремяЗавершения) Экспорт
	
	Если ТипЗнч(ВремяЗавершения) <> Тип("Дата") Тогда
		Возврат;
	КонецЕсли;
	
	Пока ТекущаяДата() < ВремяЗавершения Цикл
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция НеНужнаЗапускатьПаузу(Знач КоличествоСекунд) Экспорт
	Возврат ТипЗнч(КоличествоСекунд) <> Тип("Число") Или КоличествоСекунд <= 0;
КонецФункции

#КонецОбласти