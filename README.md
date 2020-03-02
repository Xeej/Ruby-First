
[Ruby за двадцать минут](https://www.ruby-lang.org/ru/documentation/quickstart/)

[CSV](https://ruby-doc.org/stdlib-2.7.0/libdoc/csv/rdoc/CSV.html)

У вас есть данные в виде CSV файлов. Вот ссылки на них:

1. [vms.csv](./vms.csv) - список виртуальных машин
2. [volumes.csv](./volumes.csv) - список дополнительных HDD виртуальных машин
3. [prices.csv](./prices.csv) - цены на вычислительные ресурсы

В первом файле находится выгрузка данных по виртуальным машинам (ВМ) со следующими столбцами:
* id - идентификатор ВМ
* cpu - количество CPU в ВМ в штуках
* ram - количество оперативной памяти в гигабайтах
* hdd_type - тип жесткого диска
* hdd_capacity - объем жесткого диска

Во втором файле находится выгрузка данных по ценам на вычислительные ресурсы:
* type - тип вычислительных ресурсов
* price - цена в копейках

В третьем файле находится выгрузка данных по дополнительным жестким дискам:
* vm_id - идентификатор ВМ
* hdd_type - тип жесткого диска
* hdd_capacity - объем жесткого диска

Ваша задача написать программу на Ruby реализующую систему отчетов. Отчет необходимо выводить в STDOUT в виде текста.

* Отчет который выводит n самых дорогих ВМ
* Отчет который выводит n самых дешевых ВМ
* Отчет который выводит n самых объемных ВМ по параметру type
* Отчет который выводит n ВМ у которых подключено больше всего дополнительных дисков (по количеству) (с учетом типа диска если параметр hdd_type указан)
* Отчет который выводит n ВМ у которых подключено больше всего дополнительных дисков (по объему) (с учетом типа диска если параметр hdd_type указан)

Используя классы и модули реализуйте необходимые абстракции для сущностей задачи. Старайтесь организовать код так, что бы он был: простым, читаемым и легко модифицируемым.
Там где нужно используйте комментарии.

Результат можно передавать в виде снипетов в gitlab.w55.ru или в виде вашего личного репозитория там же.

Для того, чтобы прокинуть текущую рабочую папку хостовой машины внутрь docker контейнера нужно добавить аргумент ```-v `pwd`:/app```

Полностью команда будет выглядеть так:
```
docker run --rm -it -v `pwd`:/app ruby:2.7-alpine
```
###########################################################
Для запуска программы: 
sudo snap install ruby --classic
pwd-> ruby first.rb
