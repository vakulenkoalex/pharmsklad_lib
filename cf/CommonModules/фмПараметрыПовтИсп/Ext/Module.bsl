﻿
#Область ПрограммныйИнтерфейс

// Текущая область применения параметра.
// 
// Возвращаемое значение:
//  ОпределяемыйТип.фмОбластьПримененияПараметра - область применения параметра.
//
Функция ТекущаяОбластьПримененияПараметра() Экспорт
	Возврат ПараметрыСеанса.фмТекущаяОбластьПримененияПараметра;
КонецФункции

// Пустое значение определяемого типа фмОбластьПримененияПараметра.
// 
// Возвращаемое значение:
//  Массив Из Неопределено - массив пустых значений.
//
Функция ПустоеЗначениеОбластьПрименения() Экспорт
	
	Массив = фмКонструкторы.ПустыеЗначенияТипов(Метаданные.ОпределяемыеТипы.фмОбластьПримененияПараметра.Тип);
	Возврат Новый ФиксированныйМассив(Массив);
	
КонецФункции

#КонецОбласти