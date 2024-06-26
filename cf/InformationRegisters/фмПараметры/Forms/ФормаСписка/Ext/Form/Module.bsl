﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ОбластьПрименения.Видимость = фмПараметрыПовтИсп.ИспользуетсяОбластьПримененияПараметра();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьСправку(Команда)
	ОткрытьФорму("РегистрСведений.фмПараметры.Форма.ФормаСправка", Новый Структура("Текст", ТекстСправки()));
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКэшЗначенийПараметров(Команда)
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ТекстСправки()
	Возврат ПолучитьОбщийМакет("фмОписаниеПараметров").ПолучитьТекст();
КонецФункции

#КонецОбласти