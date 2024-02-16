﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

&Вместо("JSON")
Функция фмлог_JSON(Знач Данные)
	
	ПараметрыМетода = Мокито.МассивПараметров(Данные);
	
	ПрерватьВыполнение = Ложь;
	Результат = Мокито.АнализВызова(ЭтотОбъект, "JSON", ПараметрыМетода, ПрерватьВыполнение);
	
	Если Не ПрерватьВыполнение Тогда
		Возврат ПродолжитьВызов(Данные);
	Иначе
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли