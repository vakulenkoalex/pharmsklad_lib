﻿
#Область ПрограммныйИнтерфейс

// Сформировать отчет
//
// Параметры:
//  ОтчетОбъект			 - ОтчетОбъект, Структура				 - отчет, для которого формируется результат (нужны свойства СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных).
//  ДокументРезультат	 - ТаблицаЗначений, ТабличныйДокумент	 - объект, куда будет помещен результат отчета.
//  ДанныеРасшифровки	 - ДанныеРасшифровкиКомпоновкиДанных 	 - объект, куда будет помещена расшифровка отчета.
//  ВнешниеНаборыДанных	 - Структура							 - ключ: имя внешнего набора данных, значение: таблица значений.
//
Процедура СформироватьОтчет(ОтчетОбъект, ДокументРезультат, ДанныеРасшифровки = Неопределено, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	Если ТипЗнч(ДокументРезультат) = Тип("ТаблицаЗначений") Тогда
		ТипГенератора = Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений");
	Иначе
		ТипГенератора = Тип("ГенераторМакетаКомпоновкиДанных");
	КонецЕсли;
	
	Если ТипЗнч(ОтчетОбъект) = Тип("Структура") И ОтчетОбъект.Свойство("НастройкиКомпоновкиДанных") Тогда
		НастройкиКомпоновкиДанных = ОтчетОбъект.НастройкиКомпоновкиДанных;
	Иначе
		НастройкиКомпоновкиДанных = ОтчетОбъект.КомпоновщикНастроек.ПолучитьНастройки();
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ОтчетОбъект.СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, ДанныеРасшифровки, , ТипГенератора);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	Если ТипЗнч(ДокументРезультат) = Тип("ТаблицаЗначений") Тогда
		
		ПроцессорВыводаРезультата = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений; 
		ПроцессорВыводаРезультата.УстановитьОбъект(ДокументРезультат);
	
	Иначе
		
		ПроцессорВыводаРезультата = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент; 
		ПроцессорВыводаРезультата.УстановитьДокумент(ДокументРезультат);
		
	КонецЕсли;
	
	ПроцессорВыводаРезультата.Вывести(ПроцессорКомпоновки, Истина);
	
КонецПроцедуры

// Свернуть группировки отчета
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент - объект, к котором требуется свернуть группировки.
//
Процедура СвернутьГруппировкиОтчета(ТабличныйДокумент) Экспорт
	
	КоличествоГруппировокСтрок = ТабличныйДокумент.КоличествоУровнейГруппировокСтрок() - 2;
	Если КоличествоГруппировокСтрок >= 0 Тогда
		Для Счетчик = 0 По КоличествоГруппировокСтрок Цикл
			ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(КоличествоГруппировокСтрок - Счетчик);
		КонецЦикла;
	КонецЕсли;
	
	КоличествоГруппировокКолонок = ТабличныйДокумент.КоличествоУровнейГруппировокКолонок() - 2;
	Если КоличествоГруппировокКолонок >= 0 Тогда
		Для Счетчик = 0 По КоличествоГруппировокКолонок Цикл
			ТабличныйДокумент.ПоказатьУровеньГруппировокКолонок(КоличествоГруппировокКолонок - Счетчик);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Загрузить вариант отчета
//
// Параметры:
//  ОтчетОбъект	 - ОтчетОбъект - отчет, в который нужно загрузить настройку.
//  ИмяВарианта	 - Строка - имя варианта.
//  Отборы		 - Соответствие - ключ: имя поля, значение: значение отбора.
//
Процедура ЗагрузитьВариантОтчета(ОтчетОбъект, Знач ИмяВарианта, Знач Отборы = Неопределено) Экспорт
	
	ОтчетОбъект.КомпоновщикНастроек.ЗагрузитьНастройки(ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ИмяВарианта).Настройки);
	
	Если Отборы <> Неопределено Тогда
		ПрименитьОтборыКОтчету(Отборы, ОтчетОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Установить значение отбора или параметра отчета
//
// Параметры:
//  КомпоновщикНастроек	 - КомпоновщикНастроекКомпоновкиДанных	 - компоновщик, в который добавляется отбор.
//  ИмяОтбора			 - Строка								 - имя поля, по которому устанавливается отбор.
//  Значение			 - Произвольное							 - значение поля, тип зависит от значений, содержащихся в поле.
//  ВидСравнения		 - ВидСравненияКомпоновкиДанных			 - вид сравнения.
//
Процедура УстановитьЗначениеОтбора(КомпоновщикНастроек, Знач ИмяОтбора, Знач Значение, Знач ВидСравнения = Неопределено) Экспорт
	
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	НастройкиКомпоновщика = КомпоновщикНастроек.Настройки;
	ПараметрКомпоновки = Новый ПараметрКомпоновкиДанных(ИмяОтбора);
	
	Если НастройкиКомпоновщика.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрКомпоновки) = Неопределено Тогда
		
		ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяОтбора);
		ПроверитьДоступностьПоляДляОтбора(НастройкиКомпоновщика, ПолеКомпоновки);
		
		ЭлементОтбора = НастройкиКомпоновщика.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки;
		ЭлементОтбора.ВидСравнения = ВидСравнения;
		ЭлементОтбора.ПравоеЗначение = Значение;
		ЭлементОтбора.Использование = Истина;
		
	Иначе
		НастройкиКомпоновщика.ПараметрыДанных.УстановитьЗначениеПараметра(ПараметрКомпоновки, Значение);
	КонецЕсли;
	
КонецПроцедуры

// Получить результат варианта отчета как таблицу значений
//
// Параметры:
//  ОтчетОбъект	 - ОтчетОбъект	 - отчет, в который нужно загрузить настройку.
//  ИмяВарианта	 - Строка		 - имя варианта.
//  Отборы		 - Соответствие	 - ключ: имя поля, значение: значение отбора.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - результат отчета.
//
Функция РезультатОтчетаВТаблицу(ОтчетОбъект, Знач ИмяВарианта, Знач Отборы = Неопределено) Экспорт
	
	РезультатОтчета = Новый ТаблицаЗначений();
	
	ЗагрузитьВариантОтчета(ОтчетОбъект, ИмяВарианта, Отборы);
	ОтчетОбъект.СкомпоноватьРезультат(РезультатОтчета);
	
	Возврат РезультатОтчета;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПрименитьОтборыКОтчету(Знач Отборы, ОтчетОбъект)
	
	Для Каждого Элемент Из Отборы Цикл
		
		Если ТипЗнч(Элемент.Значение) = Тип("Массив") Или ТипЗнч(Элемент.Значение) = Тип("СписокЗначений") Тогда
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке;
		Иначе
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
		
		УстановитьЗначениеОтбора(ОтчетОбъект.КомпоновщикНастроек, Элемент.Ключ, Элемент.Значение, ВидСравненияОтбора);
		
	КонецЦикла;

КонецПроцедуры

Процедура ПроверитьДоступностьПоляДляОтбора(Знач НастройкиКомпоновщика, Знач ПолеКомпоновкиДанных)
	
	Если НастройкиКомпоновщика.ДоступныеПоляОтбора.Элементы.Найти(ПолеКомпоновкиДанных) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Поле ""%1"" недоступно для отбора", ПолеКомпоновкиДанных);
	
КонецПроцедуры

#КонецОбласти
