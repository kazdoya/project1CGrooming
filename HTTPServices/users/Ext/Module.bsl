﻿
Функция getUserGET(Запрос)	
	
	Логин = Строка(Запрос.ПараметрыЗапроса.Получить("username")); //(1)
	
	ЗапросПользователи = Новый Запрос;
	Если Логин <> "" Тогда //(2)
		ЗапросПользователи.Текст = "ВЫБРАТЬ
		|    УНИКАЛЬНЫЙИДЕНТИФИКАТОР(Пользователи.Ссылка) КАК Ссылка,
		|    Пользователи.Наименование КАК Наименование,
		|    Пользователи.Код КАК Код
		|ИЗ
		|    Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|    НЕ Пользователи.ПометкаУдаления
		|    И Пользователи.Наименование = &Наименование
		|
		|УПОРЯДОЧИТЬ ПО
		|    Наименование";
		
		ЗапросПользователи.УстановитьПараметр("Наименование", Логин); //(3)
	Иначе //(4)
		ЗапросПользователи.Текст = "ВЫБРАТЬ
		|    УНИКАЛЬНЫЙИДЕНТИФИКАТОР(Пользователи.Ссылка) КАК Ссылка,
		|    Пользователи.Наименование КАК Наименование,
		|    Пользователи.Код КАК Код
		|ИЗ
		|    Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|    НЕ Пользователи.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|    Наименование";
		
	КонецЕсли;    
	
	РезультатЗапроса = ЗапросПользователи.Выполнить();
	
	МассивПользователей= Новый Массив; //1
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДанныеПользователя = Новый Структура; //2
		ДанныеПользователя.Вставить("guid", Строка(Выборка.Ссылка));
		ДанныеПользователя.Вставить("name", Строка(Выборка.Наименование));
		ДанныеПользователя.Вставить("code", Строка(Выборка.Код));
		
		МассивПользователей.Добавить(ДанныеПользователя); //3
		
	КонецЦикла;
	
	Ответ = Новый HTTPСервисОтвет(200); //4
	
	ЗаписьJSON = Новый ЗаписьJSON; //5
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, МассивПользователей);
	СтрокаОтвета = ЗаписьJSON.Закрыть();
	
	Ответ.УстановитьТелоИзСтроки(СтрокаОтвета); //6
	
	Возврат Ответ; //7
	
КонецФункции
