﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Данные

// Создает массив и помещает в него переданное значение.
//
// Параметры:
//  Значение - Произвольный - любое значение.
//
// Возвращаемое значение:
//  Массив - массив из одного элемента.
//
Функция ЗначениеВМассиве(Знач Значение) Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Значение);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
