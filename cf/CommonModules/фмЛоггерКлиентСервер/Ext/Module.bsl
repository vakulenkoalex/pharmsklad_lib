﻿
#Область ПрограммныйИнтерфейс

#Если Не ВебКлиент Тогда

// Создать логгер.
//
// Параметры:
//  ИерархияСобытия - Строка, ОбъектМетаданных - иерархия события.
// 
// Возвращаемое значение:
//  УправляемаяФорма, ОбработкаОбъект.фмЛоггер - контейнер для записи.
//
Функция СоздатьЛоггер(Знач ИерархияСобытия) Экспорт
	
	#Если ТонкийКлиент Тогда
	Возврат фмЛоггерКлиент.СоздатьЛоггер(ИерархияСобытия);
	#Иначе
	Возврат фмЛоггер.СоздатьЛоггер(ИерархияСобытия);
	#КонецЕсли
	
КонецФункции

#КонецЕсли

#КонецОбласти
