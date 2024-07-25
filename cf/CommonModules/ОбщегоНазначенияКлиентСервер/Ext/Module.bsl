﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОповещениеПользователя

// Формирует текст ошибок заполнения полей и списков.
//
// Параметры:
//  ВидПоля - Строка - может принимать значения: Поле, Колонка, Список.
//  ВидСообщения - Строка - может принимать значения: Заполнение, Корректность.
//  ИмяПоля - Строка - имя поля.
//  НомерСтроки - Строка
//              - Число - номер строки.
//  ИмяСписка - Строка - имя списка.
//  ТекстСообщения - Строка - детальная расшифровка ошибки заполнения.
//
// Возвращаемое значение:
//   Строка - текст ошибки заполнения.
//
Функция ТекстОшибкиЗаполнения(
		ВидПоля = "Поле",
		ВидСообщения = "Заполнение",
		ИмяПоля = "",
		НомерСтроки = "",
		ИмяСписка = "",
		ТекстСообщения = "") Экспорт
	
	Если ВРег(ВидПоля) = "ПОЛЕ" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон =
				НСтр("ru = 'Поле ""%1"" не заполнено'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон =
				НСтр("ru = 'Поле ""%1"" заполнено некорректно.
				           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "КОЛОНКА" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""%3""'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = 
				НСтр("ru = 'Некорректно заполнена колонка ""%1"" в строке %2 списка ""%3"".
				           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "СПИСОК" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Не введено ни одной строки в список ""%3""'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон =
				НСтр("ru = 'Некорректно заполнен список ""%3"".
				           |%4'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Шаблон,
		ИмяПоля,
		НомерСтроки,
		ИмяСписка,
		ТекстСообщения);
	
КонецФункции

// Формирует путь к заданной строке НомерСтроки и колонке ИмяРеквизита 
// табличной части ИмяТабличнойЧасти для выдачи сообщений в форме.
// Для совместного использования с процедурой СообщитьПользователю
// (для передачи в параметры Поле или ПутьКДанным). 
//
// Параметры:
//  ИмяТабличнойЧасти - Строка - имя табличной части.
//  НомерСтроки - Число - номер строки табличной части.
//  ИмяРеквизита - Строка - имя реквизита.
//
// Возвращаемое значение:
//  Строка - путь к ячейке таблицы.
//
Функция ПутьКТабличнойЧасти(
		Знач ИмяТабличнойЧасти,
		Знач НомерСтроки, 
		Знач ИмяРеквизита) Экспорт
	
	Возврат ИмяТабличнойЧасти + "[" + Формат(НомерСтроки - 1, "ЧН=0; ЧГ=0") + "]." + ИмяРеквизита;
	
КонецФункции

#КонецОбласти

#Область Данные

// Вызывает исключение с текстом Сообщение, если Условие не равно Истина.
// Применяется для самодиагностики кода.
//
// Параметры:
//   Условие - Булево - если не равно Истина, то вызывается исключение.
//   Сообщение - Строка - текст сообщения. Если не задан, то исключение вызывается с сообщением по умолчанию.
//   КонтекстПроверки - Строка - например, имя процедуры или функции, в которой выполняется проверка.
//
Процедура Проверить(Знач Условие, Знач Сообщение = "", Знач КонтекстПроверки = "") Экспорт
	
	Если Условие <> Истина Тогда
		
		Если ПустаяСтрока(Сообщение) Тогда
			ТекстИсключения = НСтр("ru = 'Недопустимая операция'"); // Assertion failed
		Иначе
			ТекстИсключения = Сообщение;
		КонецЕсли;
		
		Если Не ПустаяСтрока(КонтекстПроверки) Тогда
			ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 в %2'"), ТекстИсключения, КонтекстПроверки);
		КонецЕсли;
		
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывает исключение, если тип значения параметра ИмяПараметра процедуры или функции ИмяПроцедурыИлиФункции
// отличается от ожидаемого.
// Для быстрой диагностики типов параметров, передаваемых в процедуры и функции программного интерфейса.
//
// В связи с особенностью реализации ОписанияТипов всегда включает в себя тип <Неопределено>.
// если требуется жесткая проверка типа, используйте в параметре ОжидаемыеТипы 
// конкретный тип, массив или соответствие типов.
//
// Параметры:
//   ИмяПроцедурыИлиФункции - Строка - имя процедуры или функции, параметр которой проверяется.
//   ИмяПараметра - Строка - имя проверяемого параметра процедуры или функции.
//   ЗначениеПараметра - Произвольный - фактическое значение параметра.
//   ОжидаемыеТипы - ОписаниеТипов
//                 - Тип
//                 - Массив
//                 - ФиксированныйМассив
//                 - Соответствие
//                 - ФиксированноеСоответствие - тип(ы)
//       параметра процедуры или функции.
//   ОжидаемыеТипыСвойств - Структура - если ожидаемый тип - структура, то 
//       в этом параметре можно указать типы ее свойств.
//   ОжидаемыеЗначения - Массив, Строка - допустимые значения параметра в виде массива или строки через запятую.
//
Процедура ПроверитьПараметр(Знач ИмяПроцедурыИлиФункции, Знач ИмяПараметра, Знач ЗначениеПараметра, 
	Знач ОжидаемыеТипы, Знач ОжидаемыеТипыСвойств = Неопределено, Знач ОжидаемыеЗначения = Неопределено) Экспорт
	
	Контекст = "ОбщегоНазначенияКлиентСервер.ПроверитьПараметр";
	Проверить(ТипЗнч(ИмяПроцедурыИлиФункции) = Тип("Строка"), 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение параметра %1.'"), "ИмяПроцедурыИлиФункции"), 
		Контекст);
	Проверить(ТипЗнч(ИмяПараметра) = Тип("Строка"), 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение параметра %1.'"), "ИмяПараметра"), 
			Контекст);
	
	ЭтоКорректныйТип = ЗначениеОжидаемогоТипа(ЗначениеПараметра, ОжидаемыеТипы);
	Проверить(ЭтоКорректныйТип <> Неопределено, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение параметра %1.'"), "ОжидаемыеТипы"),
		Контекст);
		
	Если ЗначениеПараметра = Неопределено Тогда
		ПредставлениеЗначенияПараметра = "Неопределено";
	ИначеЕсли ТипЗнч(ЗначениеПараметра) = Тип("ДвоичныеДанные") И ЗначениеПараметра.Размер() = 0 Тогда
		ПредставлениеЗначенияПараметра = "";
	Иначе
		ПредставлениеЗначенияПараметра = Строка(ЗначениеПараметра);
	КонецЕсли;
	
	Проверить(ЭтоКорректныйТип,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение параметра %1 в %2. 
			           |Ожидалось: %3; передано значение: %4 (тип %5).'"),
			ИмяПараметра, ИмяПроцедурыИлиФункции, ПредставлениеТипов(ОжидаемыеТипы), 
			ПредставлениеЗначенияПараметра,
		ТипЗнч(ЗначениеПараметра)));
	
	Если ТипЗнч(ЗначениеПараметра) = Тип("Структура") И ОжидаемыеТипыСвойств <> Неопределено Тогда
		
		Проверить(ТипЗнч(ОжидаемыеТипыСвойств) = Тип("Структура"), 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Недопустимое значение параметра %1.'"), "ИмяПроцедурыИлиФункции"),
			Контекст);
		
		Для каждого Свойство Из ОжидаемыеТипыСвойств Цикл
			
			ОжидаемоеИмяСвойства = Свойство.Ключ;
			ОжидаемыйТипСвойства = Свойство.Значение;
			ЗначениеСвойства = Неопределено;
			
			Проверить(ЗначениеПараметра.Свойство(ОжидаемоеИмяСвойства, ЗначениеСвойства), 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Недопустимое значение параметра %1 (Структура) в %2. 
					           |В структуре ожидалось свойство %3 (тип %4).'"), 
					ИмяПараметра, ИмяПроцедурыИлиФункции, ОжидаемоеИмяСвойства, ОжидаемыйТипСвойства));
			
			ЭтоКорректныйТип = ЗначениеОжидаемогоТипа(ЗначениеСвойства, ОжидаемыйТипСвойства);
			Проверить(ЭтоКорректныйТип, 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Недопустимое значение свойства %1 в параметре %2 (Структура) в %3. 
					           |Ожидалось: %4; передано значение: %5 (тип %6).'"), 
					ОжидаемоеИмяСвойства, ИмяПараметра,	ИмяПроцедурыИлиФункции,
					ПредставлениеТипов(ОжидаемыеТипы), 
					?(ЗначениеСвойства <> Неопределено, ЗначениеСвойства, НСтр("ru = 'Неопределено'")),
				ТипЗнч(ЗначениеСвойства)));
			
		КонецЦикла;
	КонецЕсли;
	
	Если ОжидаемыеЗначения <> Неопределено Тогда
		Если ТипЗнч(ОжидаемыеЗначения) = Тип("Строка") Тогда
			ОжидаемыеЗначения = СтрРазделить(ОжидаемыеЗначения, ",");
		КонецЕсли; 
		Проверить(ОжидаемыеЗначения.Найти(ЗначениеПараметра) <> Неопределено,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Недопустимое значение параметра %1 в %2. 
				           |Ожидалось: %3; 
				           |передано значение: %4 (тип %5).'"),
				ИмяПараметра, ИмяПроцедурыИлиФункции, СтрСоединить(ОжидаемыеЗначения, ","), 
				ПредставлениеЗначенияПараметра, ТипЗнч(ЗначениеПараметра)));
	КонецЕсли;
	
КонецПроцедуры

// Дополняет структуру значениями из другой структуры.
//
// Параметры:
//   Приемник - Структура - коллекция, в которую будут добавляться новые значения.
//   Источник - Структура - коллекция, из которой будут считываться пары Ключ и Значение для заполнения.
//   Заменять - Булево
//            - Неопределено - что делать в местах пересечения ключей источника и приемника:
//                             Истина - заменять значения приемника (самый быстрый способ),
//                             Ложь   - не заменять значения приемника (пропускать),
//                             Неопределено - значение по умолчанию. Бросать исключение.
//
Процедура ДополнитьСтруктуру(Приемник, Источник, Заменять = Неопределено) Экспорт
	
	Для Каждого Элемент Из Источник Цикл
		Если Заменять <> Истина И Приемник.Свойство(Элемент.Ключ) Тогда
			Если Заменять = Ложь Тогда
				Продолжить;
			Иначе
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Пересечение ключей источника и приемника: ""%1"".'"), Элемент.Ключ);
			КонецЕсли
		КонецЕсли;
		Приемник.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Создает массив и помещает в него переданные значения.
//
// Параметры:
//  Значение1 - Произвольный - любое значение.
//  Значение2 - Произвольный
//  Значение3 - Произвольный
//  Значение4 - Произвольный
//
// Возвращаемое значение:
//  Массив
//  
// Пример:
//   Результат = ОбщегоНазначенияКлиентСервер.МассивЗначений(1, 2, 3);
//
Функция МассивЗначений(Знач Значение1, Знач Значение2 = Неопределено, Знач Значение3 = Неопределено, 
	Знач Значение4 = Неопределено) Экспорт
	
	Результат = Новый Массив;
	Если Значение4 <> Неопределено Тогда
		Результат.Добавить(Значение4);
	КонецЕсли;
	Если Значение3 <> Неопределено Тогда
		Результат.Добавить(Значение3);
	КонецЕсли;
	Если Значение2 <> Неопределено Тогда
		Результат.Добавить(Значение2);
	КонецЕсли;
	Результат.Добавить(Значение1);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Данные

#Область ПроверитьПараметр

Функция ЗначениеОжидаемогоТипа(Значение, ОжидаемыеТипы)
	
	ТипЗначения = ТипЗнч(Значение);
	Если ТипЗнч(ОжидаемыеТипы) = Тип("ОписаниеТипов") Тогда
		Возврат ОжидаемыеТипы.Типы().Найти(ТипЗначения) <> Неопределено;
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Тип") Тогда
		Возврат ТипЗначения = ОжидаемыеТипы;
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Массив") 
		Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированныйМассив") Тогда
		Возврат ОжидаемыеТипы.Найти(ТипЗначения) <> Неопределено;
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Соответствие") 
		Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированноеСоответствие") Тогда
		Возврат ОжидаемыеТипы.Получить(ТипЗначения) <> Неопределено;
	КонецЕсли;
	Возврат Неопределено;
	
КонецФункции

Функция ПредставлениеТипов(ОжидаемыеТипы)
	
	Если ТипЗнч(ОжидаемыеТипы) = Тип("Массив")
		Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированныйМассив")
		Или ТипЗнч(ОжидаемыеТипы) = Тип("Соответствие")
		Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированноеСоответствие") Тогда
		
		Результат = "";
		Индекс = 0;
		Для Каждого Элемент Из ОжидаемыеТипы Цикл
			
			Если ТипЗнч(ОжидаемыеТипы) = Тип("Соответствие")
				Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированноеСоответствие") Тогда 
				
				Тип = Элемент.Ключ;
			Иначе 
				Тип = Элемент;
			КонецЕсли;
			
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + ", ";
			КонецЕсли;
			
			Результат = Результат + ПредставлениеТипа(Тип);
			Индекс = Индекс + 1;
			Если Индекс > 10 Тогда
				Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = '%1,... (всего %2 типов)'"), 
					Результат, 
					ОжидаемыеТипы.Количество());
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Возврат Результат;
		
	Иначе 
		Возврат ПредставлениеТипа(ОжидаемыеТипы);
	КонецЕсли;
	
КонецФункции

Функция ПредставлениеТипа(Тип)
	
	Если Тип = Неопределено Тогда
		
		Возврат "Неопределено";
		
	ИначеЕсли ТипЗнч(Тип) = Тип("ОписаниеТипов") Тогда
		
		ТипСтрокой = Строка(Тип);
		Возврат 
			?(СтрДлина(ТипСтрокой) > 150, 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = '%1,... (всего %2 типов)'"),
					Лев(ТипСтрокой, 150),
					Тип.Типы().Количество()), 
				ТипСтрокой);
		
	Иначе
		
		ТипСтрокой = Строка(Тип);
		Возврат 
			?(СтрДлина(ТипСтрокой) > 150, 
				Лев(ТипСтрокой, 150) + "...", 
				ТипСтрокой);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти