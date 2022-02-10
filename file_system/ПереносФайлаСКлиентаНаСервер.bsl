&НаКлиенте
Процедура ОбработатьФайл()
	
	ПутьКФайлу = ""; // инициализировать путь к файлу

	ИмяФайлаДляОбработки = ПутьКФайлу;
	ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработатьФайлЗавершение", ЭтотОбъект);
	
	НачатьПомещениеФайла(ОписаниеОповещения, ,
		ИмяФайлаДляОбработки, Ложь,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьФайлЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Результат = ПроизвестиОбработкуНаСервере(Адрес);
	
КонецПроцедуры

&НаСервере
Функция ПроизвестиОбработкуНаСервере(Адрес)
	
	Данные = ПолучитьИзВременногоХранилища(Адрес);
	ИмяПромежуточногоФайла = ПолучитьИмяВременногоФайла("txt");
	Данные.Записать(ИмяПромежуточногоФайла);
	
	Чтение = Новый ЧтениеТекста(ИмяПромежуточногоФайла);

	// Обработка данных
	
	Результат = Чтение.Прочитать();
	
	УдалитьФайлы(ИмяПромежуточногоФайла);
	
	Возврат Результат;
	
КонецФункции
