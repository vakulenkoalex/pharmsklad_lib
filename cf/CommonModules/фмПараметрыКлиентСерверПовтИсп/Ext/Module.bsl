﻿
#Область ПрограммныйИнтерфейс

// Прочитать значение параметра.
//
// Параметры:
//  ИмяПараметра        - Строка - имя параметра.
//  ЗначениеПоУмолчанию - ОпределяемыйТип.фмЗначениеПараметра - значение по умолчанию.
//  ОбластьПрименения   - ОпределяемыйТип.фмОбластьПримененияПараметра - область применения параметра.
// 
// Возвращаемое значение:
//  ОпределяемыйТип.фмЗначениеПараметра - значение параметра.
//
Функция ПрочитатьЗначениеПараметра(Знач ИмяПараметра, Знач ЗначениеПоУмолчанию = Неопределено, Знач ОбластьПрименения = Неопределено) Экспорт
	Возврат фмПараметрыВызовСервера.ПрочитатьЗначениеПараметра(ИмяПараметра, ЗначениеПоУмолчанию, ОбластьПрименения);
КонецФункции

// Текущая область применения параметра.
// 
// Возвращаемое значение:
//  ОпределяемыйТип.фмОбластьПримененияПараметра - область применения параметра.
//
Функция ТекущаяОбластьПримененияПараметра() Экспорт
	Возврат фмПараметрыВызовСервера.ТекущаяОбластьПримененияПараметра();
КонецФункции

#КонецОбласти