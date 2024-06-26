﻿  &НаКлиенте
  Процедура УправлениеВидимостью()  
	  ЭтоЦикличныйГрафик = Способзаполнения = 2;
	  Элементы.ШагДней.Видимость = ЭтоЦикличныйГрафик;
	  Элементы.НачалоГрафика.Видимость = ЭтоЦикличныйГрафик;
  КонецПроцедуры
  
  &НаКлиенте
  Процедура СпособЗаполненияПриИзменении(Элемент)
	  УправлениеВидимостью();
  КонецПроцедуры
  
  &НаКлиенте
  Процедура ПроверкаКорректностиПериода()
	  Если ЗначениеЗаполнено(Объект.КонецПериода) И Объект.НачалоПериода >  Объект.КонецПериода Тогда
		  Сообщение = Новый СообщениеПользователю;
		  Сообщение.Текст = "Начало периода не может быть больше окончания!";
		  Сообщение.Сообщить();
		  Объект.КонецПериода = '00010101';
	  КонецЕсли;
  КонецПроцедуры
  
  &НаКлиенте
  Процедура НачалоПериодаПриИзменении(Элемент)
	  ПроверкаКорректностиПериода();
  КонецПроцедуры
  
  &НаКлиенте
  Процедура КонецПериодаПриИзменении(Элемент)
	  ПроверкаКорректностиПериода();
  КонецПроцедуры
  
  &НаКлиенте
  Процедура ПриОткрытии(Отказ)
	  Если НачалоПериода = '00010101' И КонецПериода = '00010101' Тогда
		  НачалоПериода = НачалоГода(ТекущаяДата());
		  КонецПериода  = КонецГода(ТекущаяДата());
	  КонецЕсли;
	  Если СпособЗаполнения = 0 Тогда
		  СпособЗаполнения = 1;
	  КонецЕсли;
	  Если НачалоГрафика = 0 Тогда
		  НачалоГрафика = 1; 
	  КонецЕсли;
	  УправлениеВидимостью();
  КонецПроцедуры
  
  &НаКлиенте
  Процедура ЗаполнитьГрафикПятидневки()
	  
	  СуткиВСекундах = 86400;
	  ТекущийДень = НачалоПериода;
	  
	  Пока ТекущийДень <= КонецПериода Цикл
		  
		  НоваяСтрока = Объект.СписокДней.Добавить();
		  НоваяСтрока.День = ТекущийДень;
		  
		  ЭтоРабочийДень = (ДеньНедели(ТекущийДень) < 6);
		  
		  Если ЭтоРабочийДень Тогда
			  НоваяСтрока.КоличествоЧасов = КоличествоЧасов;
		  КонецЕсли;
		  
		  ТекущийДень = ТекущийДень + СуткиВСекундах;
		  
	  КонецЦикла;
	  
  КонецПроцедуры   
  
  &НаКлиенте
  Процедура ЗаполнитьЦиклическийГрафик()
	  
	  СуткиВСекундах = 86400;
	  ТекущийДень = НачалоПериода;
	  
	  Если НачалоГрафика = 1 Тогда
		  ЭтоРабочийДень = Истина;
	  Иначе
		  ЭтоРабочийДень = Ложь;
	  КонецЕсли;
	  
	  Сч = 0;
	  
	  Пока ТекущийДень <= КонецПериода Цикл
		  
		  НоваяСтрока = Объект.СписокДней.Добавить();
		  НоваяСтрока.День = ТекущийДень;
		  
		  Если ЭтоРабочийДень Тогда
			  НоваяСтрока.КоличествоЧасов = КоличествоЧасов;
		  КонецЕсли;
		  
		  Сч = Сч + 1;
		  ТекущийДень = ТекущийДень + СуткиВСекундах;
		  
		  // Если значение текущего счетчика кратно шагу дней, 
		  // меняем признак рабочего дня на противоположный
		  Если Сч % ШагДней = 0 Тогда 
			  ЭтоРабочийДень = Не ЭтоРабочийДень;
		  КонецЕсли;
		  
	  КонецЦикла;
	  
  КонецПроцедуры
  
  &НаКлиенте
  Процедура ЗаполнитьГрафик(Команда)
	  Объект.СписокДней.Очистить();
	  
	  Если СпособЗаполнения = 1 Тогда
		  ЗаполнитьГрафикПятидневки();
	  ИначеЕсли СпособЗаполнения = 2 Тогда
		  ЗаполнитьЦиклическийГрафик();
	  КонецЕсли;
  КонецПроцедуры
  
  &НаСервере
  Процедура ЗагрузитьВГрафикиПредприятияНаСервере()
	  Запрос = Новый Запрос;
	  Запрос.Текст =
	  "ВЫБРАТЬ
	  |	ГрафикиРаботыСотрудниковСписокДней.День КАК День,
	  |	ГрафикиРаботыСотрудниковСписокДней.КоличествоЧасов КАК КоличествоЧасов,
	  |	ГрафикиРаботыСотрудниковСписокДней.Ссылка КАК Ссылка
	  |ИЗ
	  |	Справочник.ГрафикиРаботыСотрудников.СписокДней КАК ГрафикиРаботыСотрудниковСписокДней
	  |ГДЕ
	  |	ГрафикиРаботыСотрудниковСписокДней.КоличествоЧасов > 0
	  |	И ГрафикиРаботыСотрудниковСписокДней.Ссылка = &Ссылка";  
	  
	  Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	  
	  ДанныеГрафика = Запрос.Выполнить().Выгрузить(); 
	  РегистрыСведений.ГрафикиРаботыПредприятия.ЗаполнитьГрафики(ДанныеГрафика); 
	  
	  СообщениеПользователю = Новый СообщениеПользователю;
	  СообщениеПользователю.Текст = СтрШаблон("График работы %1 успешно загружен.", Объект.Наименование);
	  СообщениеПользователю.Сообщить();
	  
  КонецПроцедуры
  
  &НаКлиенте
  Процедура ЗагрузитьВГрафикиПредприятия(Команда)
	  Если Объект.СписокДней.Количество() > 0 Тогда
		  ЗагрузитьВГрафикиПредприятияНаСервере();
	  Иначе
		  Сообщить("График работы не содержит данных, сначала заполните график работы!");
	  КонецЕсли;
  КонецПроцедуры
