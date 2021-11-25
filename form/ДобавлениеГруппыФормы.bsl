&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Пример:
	//Добавление группы формы
	//Добавление элементов в группу формы
	
	Группа = Элементы.Добавить(
		"ГруппаШапка",
		Тип("ГруппаФормы"),
		ЭтаФорма);
		
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	
	Группа.Заголовок = "Реквизиты объекта:";
	
	//Добавить поле ввода в группу
	ПолеВвода = Элементы.Добавить("ФормаКомментарий", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.Комментарий";

	
КонецПроцедуры