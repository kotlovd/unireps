
	СтандартнаяОбработка=ложь;
	
	Фильтр = "PDF (*.pdf)|*.pdf";

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок 			= "Выберите файл";
	Диалог.ПолноеИмяФайла 		= "";  
	Диалог.Фильтр 				= Фильтр; 
    Диалог.МножественныйВыбор 	= Ложь;
	Диалог.Каталог 				= "F:\";
	
	Если Диалог.Выбрать() Тогда
		ПутьКФайлу = Диалог.ПолноеИмяФайла;
	КонецЕсли;
 