﻿
#Область ПрограммныйИнтерфейс

Процедура ЛоггерПутьКФайлу(Знач Путь) Экспорт
	
	Запись = РегистрыСведений.фмПараметры.СоздатьМенеджерЗаписи();
	Запись.ИмяПараметра = "ЛоггерПутьКФайлу";
	Запись.ЗначениеПараметра = Путь;
	Запись.Записать();
	
КонецПроцедуры

#КонецОбласти