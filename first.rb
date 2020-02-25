#контейнер и укажем путь для файлов !!!!!!ковычки косые!!!!!!!
docker run --rm -it -v `pwd`:/home/denis/projectruby/first ruby:2.7-alpine


fh = open '/home/denis/projectruby/first/prices.csv'
$array_prices=Array.new
while (line = fh.gets) 
    #пройдемся построчно и получим массив цены
    $array_prices[$array_prices.length]=line.chomp.split(',')
end
#переведем двумерный масив ключ значение где ключ стринг а значение инт
$array_prices.each do |element| element[1]=element[1].to_i end
#переведем двумерный массив в хэш функцию
$hash_prices= Hash[*$array_prices.flatten]
#класс жестких дисков
class Inform_Hdd
    #иниализация жесткого диска
    def initialize(hdd_type, hdd_capacity)
        #@hdd_type, @hdd_capacity = hdd_type, hdd_capacity
        @array=Array.new
        arr=Array.new
        arr[arr.length]=hdd_type
        arr[arr.length]=hdd_capacity.to_i
        @array[@array.length]=arr
        @hdd_capacity_total=hdd_capacity.to_i
    end
    #добавить жесткий диск
    def Add(hdd_type,hdd_capacity)
        arr=Array.new
        arr[arr.length]=hdd_type
        arr[arr.length]=hdd_capacity.to_i
        @array[@array.length]=arr
        @hdd_capacity_total+=hdd_capacity.to_i
    end
    #получить цену всех существующих жестких дисков
    def GetPrice
        price=0
        @array.each do |element| 
            price+=$hash_prices[element[0]] 
        end
        price.to_i
    end

    def GetHddCapacityTotal
        @hdd_capacity_total
    end

end
#класс виртуальной машины
class Virtual_Machine 
    #инициальзация виртуальнйо машины
    def initialize(id, cpu, ram, hdd_type, hdd_capacity)
        @id, @cpu, @ram = id, cpu, ram
        
        @inform_hdd= Inform_Hdd.new(hdd_type,hdd_capacity)
    end    

    def AddInf(hdd_type,hdd_capacity)
        @inform_hdd.Add(hdd_type,hdd_capacity)
    end
    #получить цену жестких дисков с учетом озу и процессоров
    def GetPrice
        price=@cpu*$hash_prices["cpu"]+$hash_prices["ram"]+@inform_hdd.GetPrice
        price.to_i
    end
    def GetHddCapacityTotal
        @inform_hdd.GetHddCapacityTotal
    end
    #дебаг
    def GetPriceInf
        @inform_hdd.GetPrice
    end
    
end
#класс множества виртуальных машин
class VIRTUAL_MACHINES 
    
    def initialize(id, cpu, ram, hdd_type, hdd_capacity)
        @virtual_machine=Array.new
        @virtual_machine[id]=Virtual_Machine.new(id,cpu,ram,hdd_type,hdd_capacity)
        
    end
    #добавить виртуальную машину
    def AddVMachine(id, cpu, ram, hdd_type, hdd_capacity)
        @virtual_machine[id]=Virtual_Machine.new(id,cpu,ram,hdd_type,hdd_capacity)
    end
    #добавить жетский диск к виртаульной машине
    def AddInf(id,hdd_type,hdd_capacity)
        @virtual_machine[id].AddInf(hdd_type,hdd_capacity)
    end
    #получить цену всей виртуальнйо машины
    def GetPrice(id)
        price = @virtual_machine[id].GetPrice
        price.to_i
    end 
    #важно чтобы ид был монотонный
    def GetLength
        @virtual_machine.length
    end
    def GetHddCapacityTotal(id)
        @virtual_machine[id].GetHddCapacityTotal.to_i
    end
    #для дебага
    def GetPriceInf(id)
        @virtual_machine[id].GetPriceInf
    end
end 

fh = open '/home/denis/projectruby/first/vms.csv'
arrayvms=Array.new
line = fh.gets
arrayvms=line.chomp.split(',')
#инициализируем первую виртуальную машину
v_machines= VIRTUAL_MACHINES.new(arrayvms[0].to_i,arrayvms[1].to_i,arrayvms[2].to_i,arrayvms[3].to_s,arrayvms[4].to_i)
#заполним все виртуальные машины из бд вмс
while (line = fh.gets) 
    arrayvms=line.chomp.split(',') #чомп избавляемся от перехода на новую строку и др
    v_machines.AddVMachine(arrayvms[0].to_i,arrayvms[1].to_i,arrayvms[2].to_i,arrayvms[3].to_s,arrayvms[4].to_i)
end

fh = open '/home/denis/projectruby/first/volumes.csv'
arrayvms=Array.new
#добавим дополнительные жесткие диски из бд волумс
while (line = fh.gets) 
    arrayvms=line.chomp.split(',')
    v_machines.AddInf(arrayvms[0].to_i,arrayvms[1].to_s,arrayvms[2].to_i)
end

virtual_prices = Array.new

v_machines.GetLength.times do |i|
    arr=Array.new
    arr[1]=i
    arr[0]=v_machines.GetPrice(i)
    virtual_prices[i]=arr
end
#Sorted
sort_virtual_prices=Hash[*virtual_prices.flatten].sort

puts "Отчет который выводит n самых дорогих ВМ\n Введите 'N'"
n=gets.to_i

sort_virtual_prices.last(n).each do |element| 
    puts "id:#{element[1]}; Price:#{element[0]}"
end

puts "Отчет который выводит n самых дешевых ВМ\n Введите 'N'"
n=gets.to_i

sort_virtual_prices.first(n).each do |element| 
    puts "id:#{element[1]}; Price:#{element[0]}"
end
puts "Отчет который выводит n-ый ВМ по параметру hdd_type\n Введите 'N'"
n=gets.to_i
puts "Максимальный обьем HDD в сумме #{v_machines.GetHddCapacityTotal(n)}"

