// Код программно формирует произвольный электронный документ


&НаКлиенте
Процедура Сделать(Команда)
	
	Файл = Новый Файл(ПутьКФайлу);
	
	ПараметрыФормы = Новый Структура;   
	ПараметрыФормы.Вставить("ДвоичныеДанныеФайла", 	Новый ДвоичныеДанные(ПутьКФайлу));
	ПараметрыФормы.Вставить("НаименованиеФайла", 	Файл.ИмяБезРасширения);
	ПараметрыФормы.Вставить("Расширение", 			Файл.Расширение);
	ПараметрыФормы.Вставить("Основание", 			Основание); ;
	ПараметрыФормы.Вставить("ТипДокумента",			ПредопределенноеЗначение("Перечисление.ТипыДокументовЭДО.АктСверки"));
	
	СделатьНаСервере(ПараметрыФормы); 
	
КонецПроцедуры 
 
&НаСервереБезКонтекста
Функция СделатьНаСервере(ДанныеПЭД)
	
	ЭД = Документы.ЭлектронныйДокументИсходящийЭДО.СоздатьДокумент();
	ЭД.УстановитьНовыйНомер();
	
	Основание = Неопределено;
	ДанныеПЭД.Свойство("Основание", Основание);
	Основание = Метаданные.ОпределяемыеТипы.ОснованияЭлектронныхДокументовЭДО.Тип.ПривестиЗначение(Основание); 
	РеквизитыОснования = ИнтеграцияЭДО.ОписаниеОснованияЭлектронногоДокумента(Основание);
	
	ЭД.Заполнить(Основание);

	ЭД.Дата						= ТекущаяДатаСеанса();
	ЭД.Организация 				= РеквизитыОснования.Организация;
	ЭД.Контрагент  				= РеквизитыОснования.Контрагент;
	ЭД.МаршрутПодписания		= Справочники.МаршрутыПодписания.ОднойДоступнойПодписью;
	ЭД.ТребуетсяИзвещение 		= Истина;
	ЭД.ТребуетсяПодтверждение 	= Истина;
	ЭД.ТипРегламента 			= Перечисления.ТипыРегламентовЭДО.Неформализованный;
	ЭД.ДатаДокумента 			= ТекущаяДатаСеанса();
	ЭД.ВидДокумента				= ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(ДанныеПЭД.ТипДокумента);
	ЭД.Комментарий 				= ДанныеПЭД.НаименованиеФайла;
	ЭД.ИдентификаторДокументооборота = ЭлектронныеДокументыЭДО.НовыйИдентификаторДокументооборота();
	
	КлючНастроекОтправки = НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки();
	КлючНастроекОтправки.Отправитель 	= ЭД.Организация;
	КлючНастроекОтправки.Получатель 	= ЭД.Контрагент;
	КлючНастроекОтправки.Договор 		= ЭД.ДоговорКонтрагента;
	КлючНастроекОтправки.ВидДокумента 	= ЭД.ВидДокумента;
	
	НастройкиОтправки = НастройкиЭДО.НастройкиОтправки(КлючНастроекОтправки);
	Если НастройкиОтправки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПриИзмененииКлючевыхРеквизитов(ЭД);
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(ДанныеПЭД.ДвоичныеДанныеФайла, Новый УникальныйИдентификатор);
	НаименованиеФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ДанныеПЭД.НаименованиеФайла, "_");	
	НаименованиеФайла = РаботаСФайламиБЭД.ДопустимоеИмяФайла(ДанныеПЭД.НаименованиеФайла, Истина);	
	НаименованиеФайла = СтрШаблон("%1.%2", ДанныеПЭД.НаименованиеФайла, ДанныеПЭД.Расширение);
	
	НастройкиСхемыРегламента = НастройкиСхемыРегламента(ЭД);
	ДанныеЭлементовСхемы = ИнтерфейсДокументовЭДО.НовыеДанныеЭлементовСхемы();
	ЗаполнитьДанныеЭлементаСхемыИнформацияОтправителя(ЭД, ДанныеЭлементовСхемы, ДанныеПЭД.ТипДокумента);
		
	СхемаРегламента = ЭлектронныеДокументыЭДО.НоваяСхемаРегламента(НастройкиСхемыРегламента, ДанныеЭлементовСхемы);
	СхемаРегламента.Колонки.Добавить("АдресФайла", Новый ОписаниеТипов("Строка"));
	СхемаРегламента.Колонки.Добавить("ИмяФайла", Новый ОписаниеТипов("Строка"));
	СхемаРегламента.Колонки.Добавить("РасширениеФайла", Новый ОписаниеТипов("Строка"));
	СхемаРегламента.Колонки.Добавить("АдресОписанияСообщения", Новый ОписаниеТипов("Строка"));
	СхемаРегламента.Колонки.Добавить("Направление", Новый ОписаниеТипов("ПеречислениеСсылка.НаправленияЭДО"));
	СхемаРегламента.Колонки.Добавить("ДополнительнаяИнформация", Новый ОписаниеТипов("Строка"));
	
	ЭлементСхемы = СхемаРегламента.Строки[0];	
	ЭлементСхемы.АдресФайла		 = АдресВХранилище;
	ЭлементСхемы.ИмяФайла 		 = НаименованиеФайла;
	ЭлементСхемы.РасширениеФайла = ДанныеПЭД.Расширение;
	ЭлементСхемы.Направление 	 = перечисления.НаправленияЭДО.Исходящий;
	
	ОписаниеСообщения 	= ОписаниеСообщения(ЭД, ЭлементСхемы);
	КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	
	ЭлектронныеДокументыЭДО.ПередЗаписьюНовогоДокумента(ЭД, ОписаниеСообщения);
	
	НачатьТранзакцию();
	
	Попытка	
		ЭД.Записать();	
	Исключение
		ОтменитьТранзакцию();
		Сообщить(ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
	
	ЭлектронныеДокументыЭДО.ПриЗаписиНовогоДокумента(ЭД, ОписаниеСообщения, КонтекстДиагностики, 
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Основание));
	
	Попытка	
		ЭД.Записать();	
	Исключение
		ОтменитьТранзакцию();
		Сообщить(ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
	Возврат ЭД.Ссылка;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеСообщения(ЭД, ЭлементСхемыРегламента)
	
	Если ЗначениеЗаполнено(ЭлементСхемыРегламента.АдресОписанияСообщения) Тогда
		ОписаниеСообщения = ПолучитьИзВременногоХранилища(ЭлементСхемыРегламента.АдресОписанияСообщения);
	Иначе
		ОписаниеСообщения = ОписаниеСообщенияПроизвольногоФормата(ЭД, ЭлементСхемыРегламента);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОписаниеСообщения.Данные.Содержание) Тогда
		СодержаниеСообщения = ЭлектронныеДокументыЭДО.НовоеСодержаниеСообщения();
		
		СодержаниеСообщения.ТипРегламента  = Перечисления.ТипыРегламентовЭДО.Неформализованный;
		СодержаниеСообщения.НомерДокумента = ЭД.НомерДокумента;
		СодержаниеСообщения.ДатаДокумента  = ЭД.ДатаДокумента;
		СодержаниеСообщения.СуммаДокумента = ЭД.СуммаДокумента;
		СодержаниеСообщения.ЕстьМаркировка = Ложь;
		
		ОписаниеСообщения.Данные.Содержание = СодержаниеСообщения;
	КонецЕсли;
	
	ОписаниеСообщения.ДополнительнаяИнформация = ЭлементСхемыРегламента.ДополнительнаяИнформация;
	
	Возврат ОписаниеСообщения;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеСообщенияПроизвольногоФормата(ЭД, ЭлементСхемыРегламента)
	
	ОписаниеСообщения = ЭлектронныеДокументыЭДО.НовоеОписаниеСообщения();
	ОписаниеСообщения.ТипЭлементаРегламента = ЭлементСхемыРегламента.ТипЭлементаРегламента;
	ОписаниеСообщения.Направление = ЭлементСхемыРегламента.Направление;
	ОписаниеСообщения.ДополнительнаяИнформация = ЭлементСхемыРегламента.ДополнительнаяИнформация;
	ОписаниеСообщения.ВидСообщения = ЭД.ВидДокумента;
	
	ОписаниеСообщения.Данные.Документ.ДвоичныеДанные = ПолучитьИзВременногоХранилища(ЭлементСхемыРегламента.АдресФайла);
	ОписаниеСообщения.Данные.Документ.ИмяФайла = ЭлементСхемыРегламента.ИмяФайла;
	
	Возврат ОписаниеСообщения;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПриИзмененииКлючевыхРеквизитов(ЭД)
	
	КлючНастройкиОтправки = НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки();
	КлючНастройкиОтправки.ВидДокумента = ЭД.ВидДокумента;
	КлючНастройкиОтправки.Отправитель = ЭД.Организация;
	КлючНастройкиОтправки.Получатель = ЭД.Контрагент;
	КлючНастройкиОтправки.Договор = ЭД.ДоговорКонтрагента;
	
	НастройкиОтправки = НастройкиЭДО.НастройкиОтправки(КлючНастройкиОтправки);
	
	ЭД.ТребуетсяПодтверждение 	= ?(ЗначениеЗаполнено(НастройкиОтправки), НастройкиОтправки.ТребуетсяОтветнаяПодпись, Ложь);
	ЭД.ТребуетсяИзвещение 		= ?(ЗначениеЗаполнено(НастройкиОтправки), НастройкиОтправки.ТребуетсяИзвещениеОПолучении, Ложь);
	ЭД.ИдентификаторОрганизации = ?(ЗначениеЗаполнено(НастройкиОтправки), НастройкиОтправки.ИдентификаторОтправителя, "");
	ЭД.ИдентификаторКонтрагента = ?(ЗначениеЗаполнено(НастройкиОтправки), НастройкиОтправки.ИдентификаторПолучателя, "");
	ЭД.СпособОбмена 			= ?(ЗначениеЗаполнено(НастройкиОтправки), НастройкиОтправки.СпособОбмена, Неопределено);
	ЭД.ОбменБезПодписи 			= ?(ЗначениеЗаполнено(НастройкиОтправки), НастройкиОтправки.ОбменБезПодписи, Ложь);
	ЭД.МаршрутПодписания 		= ?(ЗначениеЗаполнено(НастройкиОтправки), НастройкиОтправки.МаршрутПодписания, Неопределено);
	ЭД.ВидПодписи 				= Перечисления.ВидыЭлектронныхПодписей.УсиленнаяКвалифицированная;
		
	Если ЭД.МаршрутПодписания = МаршрутыПодписанияБЭД.МаршрутУказыватьПриСоздании() Тогда
		ЭД.МаршрутПодписания = Неопределено;
	КонецЕсли;
	
	ЭД.СписокПодписантов.Очистить();
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиСхемыРегламента(ЭД)
	
	НастройкиСхемы = РегламентыЭДО.НовыеНастройкиСхемыРегламента();
	НастройкиСхемы.ТипРегламента 			= ЭД.ТипРегламента;
	НастройкиСхемы.СпособОбмена 			= ЭД.СпособОбмена;
	НастройкиСхемы.ТребуетсяИзвещение 		= ЭД.ТребуетсяИзвещение;
	НастройкиСхемы.ТребуетсяПодтверждение 	= ЭД.ТребуетсяПодтверждение;

	Возврат НастройкиСхемы;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьДанныеЭлементаСхемыИнформацияОтправителя(ЭД, ДанныеЭлементовСхемы, ТипДокумента, АдресОписанияСообщения="")
	
	ДанныеЭлемента = ДанныеЭлементовСхемы.Добавить();
	ДанныеЭлемента.ВидДокумента = ЭД.ВидДокумента;
	ДанныеЭлемента.ТипДокумента = ТипДокумента;
	ДанныеЭлемента.ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя;
	
	Если ТипДокумента = Перечисления.ТипыДокументовЭДО.Внутренний Тогда
		ДанныеЭлемента.Направление = Перечисления.НаправленияЭДО.Внутренний;
	ИначеЕсли ЭлектронныеДокументыЭДО.ЭтоТипДокументаИнтеркампани(ТипДокумента) Тогда
		ДанныеЭлемента.Направление = Перечисления.НаправленияЭДО.Интеркампани;
	Иначе
		ДанныеЭлемента.Направление = Перечисления.НаправленияЭДО.Исходящий;
	КонецЕсли;
	
	ДанныеЭлемента.Статус = Перечисления.СтатусыСообщенийЭДО.НеСформирован;
	ДанныеЭлемента.АдресОписанияСообщения = АдресОписанияСообщения;
		
	ДанныеЭлемента.Наименование = ИнтерфейсДокументовЭДО.ПредставлениеИнформацииОтправителя(
		ЭД.НомерДокумента, ЭД.ДатаДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Выберите файл";
	Диалог.ПолноеИмяФайла = ""; 
	Фильтр = "PDF (*.pdf)|*.pdf"; 
	Диалог.Фильтр = Фильтр; 
    Диалог.МножественныйВыбор = Ложь;
	
	Если Диалог.Выбрать() Тогда
		ПутьКФайлу = Диалог.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры
