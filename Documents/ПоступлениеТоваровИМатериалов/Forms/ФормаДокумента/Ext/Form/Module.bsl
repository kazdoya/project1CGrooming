﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		КонецЕсли
КонецПроцедуры

 &НаКлиенте
Процедура ПересчетСуммыДокумента()
Объект.СуммаДокумента = Объект.ОписьТовара.Итог("Сумма"); 
КонецПроцедуры


&НаКлиенте
Процедура ОписьТовараКоличествоПриИзменении(Элемент)
	СтрокаТЧ = Элементы.ОписьТовара.ТекущиеДанные;
	РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
	ПересчетСуммыДокумента();
КонецПроцедуры


&НаКлиенте
Процедура ОписьТовараЦенаПриИзменении(Элемент)
	СтрокаТЧ = Элементы.ОписьТовара.ТекущиеДанные;
	РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
	ПересчетСуммыДокумента();
КонецПроцедуры


&НаКлиенте
Процедура ОписьТовараТоварПриИзменении(Элемент)
	СтрокаТЧ = Элементы.ОписьТовара.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТЧ.Товар) Тогда
		СтрокаТЧ.Стоимость = РаботаСЦенамиСервер.ПолучитьЦенуКонтрагентаНаДату(СтрокаТЧ.Товар,Объект.Поставщик,Объект.ДатаВходящегоДокумента);
	Иначе
		СтрокаТЧ.Стоимость = 0;
	КонецЕсли;
КонецПроцедуры


//&НаСервере
//Процедура ОбновитьЦеныНаСервере()
//	Для сч = 0 По Объект.ОписьТовара.Количество() - 1 Цикл
//		Объект.ОписьТовара[сч].Стоимость = РаботаСЦенамиСервер.ПолучитьЦенуКонтрагентаНаДату(Объект.ОписьТовара[сч].Товар,Объект.Поставщик,Объект.ДатаВходящегоДокумента);
//	КонецЦикла;	
//КонецПроцедуры


&НаКлиенте
Процедура ОбновитьЦены(Команда)
	//ОбновитьЦеныНаСервере();
	Для каждого Строка из Объект.ОписьТовара Цикл
		Строка.Стоимость = РаботаСЦенамиСервер.ПолучитьЦенуКонтрагентаНаДату(Строка.Товар, Объект.Поставщик, Объект.ДатаВходящегоДокумента);
	КонецЦикла;
КонецПроцедуры

