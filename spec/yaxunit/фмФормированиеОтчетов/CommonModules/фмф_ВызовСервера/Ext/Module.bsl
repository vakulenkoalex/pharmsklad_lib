﻿
#Область ПрограммныйИнтерфейс

Функция СоздатьКомпоновщикНастроекОтчета(Знач УникальныйИдентификатор) Экспорт
	
	ОтчетОбъект = Отчеты.фмф_Тестирование.Создать();
	
	// чтобы работало на клиенте нужно инициализировать КомпоновщикНастроек через адрес во временном хранилище.
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ОтчетОбъект.СхемаКомпоновкиДанных, УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресВоВременномХранилище);
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(ОтчетОбъект.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	Возврат КомпоновщикНастроек;
	
КонецФункции

#КонецОбласти