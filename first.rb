#контейнер и укажем путь для файлов !!!!!!ковычки косые!!!!!!!
#docker run --rm -it -v `pwd`:/Ruby-First ruby:2.7-alpine
#docker run --rm -it -v `pwd`:/Ruby-First ruby:2.7-alpine sh

fh = open 'prices.csv'
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
        arr[arr.length]=hdd_type.chomp
        arr[arr.length]=hdd_capacity.to_i
        @array[@array.length]=arr
        @hdd_capacity_total=hdd_capacity.to_i
    end
    #добавить жесткий диск
    def Add(hdd_type,hdd_capacity)
        arr=Array.new
        arr[arr.length]=hdd_type.chomp
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
    #получить обьем по типу
    def GetCapacityType(type="")
        capacity=0 
        if type !=""
            @array.each do |element| 
                if element[0] == type
                    capacity+=element[1]  
                end
            end
        else
            @array.each do |element| 
                capacity+=element[1]
            end
        end
        capacity.to_i
    end
    #получить кол-во по типу
    def GetCountType(type="")
        count=0
        if type !=""
            @array.first(@array.length-1).each do |element| 
                if element[0] == type
                    count+=1  
                end
            end
        else
            @array.first(@array.length-1).each do |element| 
                count+=1
            end
        end
        count.to_i
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
        @cpu*$hash_prices['cpu']+@ram*$hash_prices['ram']+@inform_hdd.GetPrice
    end

    def GetCapacityType(type="")
        #puts "#{type}"
        case type 
        when "cpu"
          @cpu*$hash_prices["cpu"].to_i
        when "ram"
            @ram*$hash_prices["ram"].to_i
        when "ssd","sata","sas"
            @inform_hdd.GetCapacityType(type).to_i
        when ""
            @cpu*$hash_prices["cpu"].to_i+@ram*$hash_prices["ram"].to_i+@inform_hdd.GetCapacityType(type).to_i
        else
            puts "Error Type!"
        end
        
    end

    def GetCountType(type="")
        case type 
        when "ssd","sata","sas",""
            @inform_hdd.GetCountType(type)
        else
            puts "Error Type!"
        end
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
    def GetCapacityType(id,type="")
        @virtual_machine[id].GetCapacityType(type).to_i
    end

    def GetCountType(id,type="")
        @virtual_machine[id].GetCountType(type).to_i
    end
end 

fh = open 'vms.csv'
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

fh = open 'volumes.csv'
arrayvms=Array.new
#добавим дополнительные жесткие диски из бд волумс
while (line = fh.gets) 
    arrayvms=line.chomp.split(',')
    v_machines.AddInf(arrayvms[0].to_i,arrayvms[1].to_s,arrayvms[2].to_i)
end

idsvms = Array.new
idsvms = (0..v_machines.GetLength-1).to_a


puts "Отчет который выводит n самых дорогих ВМ\n Введите 'N'"
n=gets.to_i
idsvms = idsvms.sort{|a,b| v_machines.GetPrice(a)<=>v_machines.GetPrice(b)}
idsvms.last(n).each do |element|
    puts "id:#{element} Price:#{v_machines.GetPrice(element)}"
end

puts "Отчет который выводит n самых дешевых ВМ\n Введите 'N'"
n=gets.to_i

idsvms.first(n).each do |element| 
    puts "id:#{element}; Price:#{v_machines.GetPrice(element)}"
end
puts "Отчет который выводит n самых объемных ВМ по параметру type\n Введите 'N type' через пробел"
type=gets.to_s.chomp.split(" ").map(&:to_s)
if type[1]==nil
    type[1]=""
end
idsvms = idsvms.sort{|a,b| (v_machines.GetCapacityType(a,type[1])<=>v_machines.GetCapacityType(b,type[1]))}

idsvms.last(type[0].to_i).each do |element| 
    puts "id:#{element}; Capacity:#{v_machines.GetCapacityType(element,type[1])}"
end 

puts "Отчет который выводит n ВМ у которых подключено больше всего дополнительных дисков (по количеству) (с учетом типа диска если параметр hdd_type указан)\n Введите 'N type' через пробел"
type=gets.to_s.chomp.split(" ").map(&:to_s)
if type[1]==nil
    type[1]=""
end
idsvms = idsvms.sort{|a,b| (v_machines.GetCountType(a,type[1])-1<=>v_machines.GetCountType(b,type[1])-1)}

idsvms.last(type[0].to_i).each do |element| 
    puts "id:#{element}; Capacity:#{v_machines.GetCountType(element,type[1])}"
end 