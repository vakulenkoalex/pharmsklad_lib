﻿
#Область СлужебныеПроцедурыИФункции

Функция СоздатьЛоггер(Знач ИерархияСобытия, Знач ИмяКлиента = "") Экспорт
	
	Строка = Обработки.фмЛоггер.ИерархияСобытияВСтроку(ИерархияСобытия);
	Возврат фмЛоггерПовтИсп.СоздатьЛоггер(Строка, ИмяКлиента);
	
КонецФункции

#КонецОбласти
