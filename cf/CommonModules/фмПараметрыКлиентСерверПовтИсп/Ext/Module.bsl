﻿
#Область СлужебныйПрограммныйИнтерфейс

// Прочитать значение параметра.
//
// Параметры:
//  ИмяПараметра        - Строка - имя параметра.
//  ЗначениеПоУмолчанию - ОпределяемыйТип.фмЗначениеПараметра - значение по умолчанию.
//  ОбластьПрименения	- ОпределяемыйТип.фмОбластьПримененияПараметра, Неопределено - переопределить область применения.
// 
// Возвращаемое значение:
//  ОпределяемыйТип.фмЗначениеПараметра - значение параметра.
//
Функция ПрочитатьЗначениеПараметра(Знач ИмяПараметра, Знач ЗначениеПоУмолчанию = Неопределено, ОбластьПрименения = Неопределено) Экспорт
	Возврат фмПараметрыВызовСервера.ПрочитатьЗначениеПараметра(ИмяПараметра, ЗначениеПоУмолчанию, ОбластьПрименения);
КонецФункции

#КонецОбласти