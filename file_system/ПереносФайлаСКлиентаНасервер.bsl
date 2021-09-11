&НаКлиенте
Процедура ОбработатьФайл()
	
	ИмяФайлаДляОбработки = "C:\Файлы для обработки\Загрузка.xml";
	ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработатьФайлЗавершение", ЭтотОбъект);
	
	НачатьПомещениеФайла(ОписаниеОповещения, ,
		ИмяФайлаДляОбработки, Ложь,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьФайлЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры)
	
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