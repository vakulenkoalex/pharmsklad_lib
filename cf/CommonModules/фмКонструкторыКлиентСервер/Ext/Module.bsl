﻿
#Область ПрограммныйИнтерфейс

// Создать соответствие с элементом.
//
// Параметры:
//  Ключ	 - Неопределено - Ключ устанавливаемого элемента.
//  Значение - Неопределено - Значение устанавливаемого элемента.
// 
// Возвращаемое значение:
//  Соответствие - созданное Соответствие.
//
Функция СоздатьСоответствие(Знач Ключ, Знач Значение) Экспорт
	
	Результат = Новый Соответствие();
	Результат.Вставить(Ключ, Значение);
	
	Возврат Результат;
	
КонецФункции

// Преобразует объект XDTO в структуру.
//
// Параметры:
//  ОбъектXDTO - ОбъектXDTO - Объект XDTO.
// 
// Возвращаемое значение:
//  Структура - Структура объекта.
//
Функция ОбъектXDTOВСтруктуру(Знач ОбъектXDTO) Экспорт
	
	Структура = Новый Структура;
	
	Для Каждого Свойство Из ОбъектXDTO.Свойства() Цикл
		
		ИмяСвойства      = Свойство.Имя;
		ЗначениеСвойства = ОбъектXDTO[ИмяСвойства];
		
		Если ТипЗнч(ЗначениеСвойства) = Тип("ОбъектXDTO") Тогда
			
			Структура.Вставить(ИмяСвойства, ОбъектXDTOВСтруктуру(ЗначениеСвойства));
			
		ИначеЕсли ТипЗнч(ЗначениеСвойства) = Тип("СписокXDTO") Тогда
			
			Структура.Вставить(ИмяСвойства, Новый Массив);
			Для Индекс = 0 По ЗначениеСвойства.Количество() - 1 Цикл
				
				ЭлементСписка = ЗначениеСвойства.Получить(Индекс);
				Если ТипЗнч(ЭлементСписка) = Тип("ОбъектXDTO") Тогда
					Структура[ИмяСвойства].Добавить(ОбъектXDTOВСтруктуру(ЭлементСписка));
				Иначе
					Структура[ИмяСвойства].Добавить(ЭлементСписка);
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе
			Структура.Вставить(ИмяСвойства, ЗначениеСвойства);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти
